import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import axios from 'axios';
import ChatMessageList from './ChatMessageList';
import ChatDialogFooter from './ChatDialogFooter';
import WaitTime from './WaitTime';
import questions from './questions';
import waitTimes from './wait_times';

let d3 = require('d3-random');

class ChatDialog extends Component {
  constructor(props) {
    super(props);

    this.state = {
      composedMessage: "",
      messages: [],
      isUnread: false,
      isEnded: false,
      questionIndex: 0,
      isWaiting: false,
      waitingStartedAt: null,
      isFocused: false,
    };

    this.textareaElement = null;
    this.pdf = this.props.dialog ? require("./manuals/" + this.props.dialog.subject + ".pdf") : null;
    this.questionTimeout = null;
    this.areYouThereTimeout = null;
  }

  componentDidMount() {
    this.initDialog();
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.dialog && nextProps.dialog.is_ended) {
      this.setState({
        isEnded: true,
        isWaiting: false,
      });
      clearTimeout(this.questionTimeout);
      clearTimeout(this.areYouThereTimeout);
    }
    if (nextProps.dialog !== this.props.dialog) {
      this.pdf = nextProps.dialog ? require("./manuals/" + nextProps.dialog.subject + ".pdf") : null;
      this.initDialog(nextProps);
    }
  }

  componentDidUpdate() {
    if (this.props.layout === 2 && this.props.isActive) {
      if (this.textareaElement) {
        this.textareaElement.focus();
      }
    }
  }

  componentWillUnmount() {
    clearTimeout(this.questionTimeout);
    clearTimeout(this.areYouThereTimeout);
  }

  initDialog = (props=this.props) => {  // props can be either nextProps or this.props
    const dialog = props.dialog;
    if (dialog) {
      this.setState({
        composedMessage: "",
        messages: [],
        isEnded: dialog.is_ended,
        isUnread: false,
        isWaiting: false,
        waitingStartedAt: null,
      });
      // Send the first message
      const firstQuestion = questions[dialog.subject][0];
      this.sendSystemMessage(firstQuestion, 1, dialog);
      this.setState({
        questionIndex: 1
      });
    }
  }

  onTextareaValueChange = (target) => {
    this.setState({composedMessage: target.value});
  }

  onTextareaFocus = () => {
    this.setState({isFocused: true});
  }

  onTextareaBlur = () => {
    this.setState({isFocused: false});
  }

  updateMessages = (newMessage) => {
    this.setState((prevState) => {
      const messages = prevState.messages;
      messages.push(newMessage);
      return {
        messages: messages,
        composedMessage: newMessage.sender_type === 1 ? prevState.composedMessage : "",
        isUnread: newMessage.sender_type === 1 ? true : false,
      };
    }, () => {
      // For experiment 2, mark dialog read or unread
      if (this.props.layout === 2) {
        this.props.setLastMessage(this.props.dialogIndex, newMessage.message);
        if (newMessage.sender_type === 1 && !this.state.isWaiting) {
          this.props.markDialogWaiting(this.props.dialogIndex, newMessage.created_at);
        } else if (newMessage.sender_type === 2) {
          this.props.markDialogNotWaiting(this.props.dialogIndex);
        }
      }
      const re = /pieni hetki/i;
      const isPieniHetkiMessage = newMessage.message.match(re);
      if (isPieniHetkiMessage) {
        // Set timeout for "Are you still there" question
        const timeout = this.getAreYouThereTimeout();
        this.areYouThereTimeout = setTimeout(() => this.sendSystemMessage("Oletko vielä siellä?", 3), timeout);
      } else {
        // Set timeout for next question only after user's first message
        const previousMessageIndex = this.state.messages.length - 2;
        if ((newMessage.sender_type === 2 && previousMessageIndex >= 0 && this.state.messages[previousMessageIndex].sender_type === 1) || (newMessage.sender_type === 2 && this.state.messages[previousMessageIndex].message.match(re))) {
          this.setTimeoutForNewQuestion();
        }
      }
    });
  }

  sendMessage = () => {
    if (this.state.composedMessage.length) {
      const composedMessage = this.state.composedMessage;
      clearTimeout(this.areYouThereTimeout);
      // Post new message
      axios.post("api/participants/" + this.props.participant.id + "/dialogs/" + this.props.dialog.id + "/messages", {
        message: composedMessage,
        created_after_experiment_part_started: (new Date() - this.props.experimentPartStartedAt) / 1000,
      }).then(response => {
        if (response.status === 201) {
          this.updateMessages(response.data);
          this.setState({
            isWaiting: false,
            waitingStartedAt: null,
          });
        }
      });
    }
    if (this.textareaElement) {
      this.textareaElement.value = "";
      this.textareaElement.focus();
    }
  }

  getNewMessageTimeout = (questionIndex) => {
    const waitTime = waitTimes[this.props.dialog.subject][questionIndex-1];
    return waitTime * 1000;
  }

  setTimeoutForNewQuestion = () => {
    if (!this.state.isEnded) {
      this.setState((prevState) => {
        let questionIndex = prevState.questionIndex;
        // If there are questions left for the subject, set timeout for next
        if (questions[this.props.dialog.subject][questionIndex]) {
          const question_count = questions[this.props.dialog.subject].length;
          let type;
          // If this is the last question, message type is 4
          if (question_count === questionIndex + 1) {
            type = 4;
          } else {
            type = 2;
          }
          const nextQuestion = questions[this.props.dialog.subject][questionIndex];
          const timeoutMilliSeconds = this.getNewMessageTimeout(questionIndex);
          // Set timeout for next question
          this.questionTimeout = setTimeout(() => this.sendSystemMessage(nextQuestion, type), timeoutMilliSeconds);
          questionIndex++;
          return {
            questionIndex: questionIndex,
          };
        } else {
          // Otherwise end the chat after 5 seconds
          setTimeout(this.endChatDialog, 5000);
          return;
        }
      });
    }
  }

  getAreYouThereTimeout = () => {
    let random = d3.randomNormal(150, 20);
    return random() * 1000;
  }

  sendSystemMessage = (message, type, dialog=this.props.dialog) => {
    const re = /Oletko vielä siellä\?/i;
    if (!dialog.is_ended) {
      if (message.match(re) && this.state.composedMessage.length) {
        // Don't send "Are you still there" yet because the user is writing, but schedule new message
        const timeout = this.getAreYouThereTimeout();
        this.areYouThereTimeout = setTimeout(() => this.sendSystemMessage("Oletko vielä siellä?", 3), timeout);
      } else {
        clearTimeout(this.areYouThereTimeout);
        axios.post("api/dialogs/" + dialog.id + "/messages", {
          message: message,
          type: type,
          created_after_experiment_part_started: (new Date() - this.props.experimentPartStartedAt) / 1000,
        }).then(response => {
          if (response.status === 201) {
            this.updateMessages(response.data);
            if (!message.match(re) || !this.state.isWaiting) {
              this.setState({
                isWaiting: true,
                waitingStartedAt: response.data.created_at,
              });
            }
            // Set timeout for "Are you still there" question (only if last message has not been sent yet)
            if (questions[this.props.dialog.subject][this.state.questionIndex]) {
              const timeout = this.getAreYouThereTimeout();
              this.areYouThereTimeout = setTimeout(() => this.sendSystemMessage("Oletko vielä siellä?", 3), timeout);
            }
          }
        });
      }
    }
  }

  endChatDialog = () => {
    this.props.endChatDialog(this.props.dialog, this.props.dialogIndex);
    // Clear question timeout and set dialog ended
    clearTimeout(this.questionTimeout);
    clearTimeout(this.areYouThereTimeout);
    this.questionTimeout = null;
    this.areYouThereTimeout = null;
    this.setState({
      isEnded: true,
      isWaiting: false,
      waitingStartedAt: null,
    });
    if (this.props.layout === 2) {
      this.props.markDialogEnded(this.props.dialogIndex);
    }
  }

  composeMessage = (event) => {
    this.setState({
      composedMessage: event.target.value
    }, () => {
      this.sendMessage();
    });
  }

  render() {
    const textareaProps = {
      maxLength: 2000,
      value: this.state.composedMessage,
      onChange: event => this.onTextareaValueChange(event.target),
      onFocus: this.onTextareaFocus,
      onBlur: this.onTextareaBlur,
      autoComplete: "off",
      autoCorrect: "off",
      autoCapitalize: "off",
      spellCheck: "false",
      placeholder: "Kirjoita tähän",
      disabled: this.state.isEnded,
    };
    const sendButtonProps = {
      onClick: event => this.sendMessage(event),
      disabled: this.state.isEnded,
    };
    return (
      <div className={"Dialog" + (this.props.isActive ? " Active" : " Inactive")}>
        {!this.props.dialog ? (
          <div className="ChatDialog"></div>
        ) : (
          <div className={"ChatDialog" + (this.state.isUnread ? " Unread" : "") + (this.state.isEnded ? " Ended" : "") + (this.props.layout === 1 && this.state.isFocused ? " Focused" : "")}>
            <a className="Subject" href={this.pdf} onClick={(event) => this.props.onSubjectClick(event, this.props.dialog.subject)}>{this.props.dialog.subject}</a>
            {this.state.isUnread && this.state.isWaiting && this.props.layout !== 2 &&
              <div className="TitleWaitTime">
                <WaitTime waitingStartedAt={this.state.waitingStartedAt} />
              </div>
            }
            <ChatMessageList messages={this.state.messages} />
            <ChatDialogFooter>
              <textarea className="MessageTextarea" {...textareaProps} ref={element => this.textareaElement = element} />
              <button className="SendButton" {...sendButtonProps}>Lähetä</button>
            </ChatDialogFooter>
            {/* for debugging purposes */}
            {/* <button onClick={() => this.sendSystemMessage("system message")}>system message</button> */}
            {/* <button onClick={() => this.endChatDialog()}>end dialog</button> */}
            <div className="AnswerButtons">
              <button onClick={this.composeMessage} value="Hei!" >Hei!</button>
              <button onClick={this.composeMessage} value="Pieni hetki">Pieni hetki</button>
              <button onClick={this.composeMessage} value="Eipä kestä!">Eipä kestä!</button>
            </div>
          </div>
        )}
      </div>
    );
  }
}

export default ChatDialog;
