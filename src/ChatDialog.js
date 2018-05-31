import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatMessageList from './ChatMessageList';
import ChatDialogFooter from './ChatDialogFooter';
import axios from 'axios';
import questions from './questions';
import waitTimes from './wait_times';


class ChatDialog extends Component {
  constructor(props) {
    super(props);

    this.state = {
      composedMessage: "",
      messages: [],
      isUnread: false,
      isEnded: false,
      questionIndex: 0,
      questionWaitTime: null,
    };

    this.textareaElement = null;
    this.pdf = this.props.dialog ? require("./manuals/" + this.props.dialog.subject + ".pdf") : null;
    this.questionTimeout = null;
    this.timer = null;
  }

  componentDidMount() {
    this.initMessages();
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.dialog && nextProps.dialog.is_ended) {
      this.setState({
        isEnded: true,
      });
      clearTimeout(this.questionTimeout);
      clearInterval(this.timer);
    }
    if (nextProps.dialog !== this.props.dialog) {
      this.pdf = nextProps.dialog ? require("./manuals/" + nextProps.dialog.subject + ".pdf") : null;
      this.initMessages(nextProps);
    }
  }

  componentWillUnmount() {
    clearTimeout(this.questionTimeout);
    clearInterval(this.timer);
  }

  increaseWaitTime = (createdAT) => {
    const start = new Date(createdAT);
    this.setState({questionWaitTime: new Date() - start});
  }

  initMessages = (props=this.props) => {  // props can be either nextProps or this.props
    const dialog = props.dialog;
    if (dialog) {
      if (props.dialog.participant === "testi") {
        this.initTestMessages(props);
      } else {
        this.setState({
          messages: [],
          isEnded: dialog.is_ended,
          isUnread: false,
          questionWaitTime: null,
        });
        console.log("SHOULD SEND FIRST MESSAGE");
        // Send the first message
        const firstQuestion = questions[dialog.subject][0];
        this.sendSystemMessage(firstQuestion, dialog);
        this.setState({
          questionIndex: 1
        });
        if (props.exp === 2 && props.isActive) {
          if (this.textareaElement) {
            this.textareaElement.focus();
          }
        }
      }
    }
  }

  initTestMessages = (props) => {
    const firstMessage = {
      message: questions[props.dialog.subject][0],
      type: 1,
      created_at: new Date(),
    };

    let messages = this.state.messages;
    messages.push(firstMessage);
    this.setState({
      messages: messages,
      questionIndex: 1,
      isUnread: true,
      isEnded: false,
    });
    this.timer = setInterval(() => this.increaseWaitTime(firstMessage.created_at), 50);
  }

  onTextareaValueChange = (target) => {
    this.setState({composedMessage: target.value});
  }

  onTextareaKeyDown = (event) => {
    if (event.keyCode === 13 && !event.shiftKey) {
      event.preventDefault();
      event.stopPropagation();
      this.sendMessage();
    }
  }

  updateMessages = (newMessage) => {
    console.log("update messages");
    this.setState((prevState) => {
      const messages = prevState.messages;
      messages.push(newMessage);
      return {
        messages: messages,
        composedMessage: newMessage.type === 1 ? prevState.composedMessage : "",
        isUnread: newMessage.type === 1 ? true : false,
      };
    }, () => {
      // For experiment 2, mark dialog read or unread
      if (this.props.exp === 2) {
        if (newMessage.type === 1) {
          this.props.markDialogUnread(this.props.dialogIndex);
        } else {
          this.props.markDialogRead(this.props.dialogIndex);
        }
      }
      // Set timeout for next question only after user's first message
      const previousMessageIndex = this.state.messages.length - 2;
      if (previousMessageIndex >= 0 && this.state.messages[previousMessageIndex].type === 1) {
        if (this.props.dialog.participant === "testi") {
          this.setTimeoutForNewTestQuestion();
        } else {
          this.setTimeoutForNewQuestion();
        }
      }
    });
  }

  sendMessage = () => {
    if (this.state.composedMessage.length) {
      const composedMessage = this.state.composedMessage;
      if (this.props.dialog.participant === "testi") {
        // Set the message to state
        const newMessage = {
          message: composedMessage,
          type: 2,
        };
        this.updateMessages(newMessage);
      } else {
        // Post new message
        axios.post("api/participants/" + this.props.dialog.participant + "/dialogs/" + this.props.dialog.id + "/messages", {message: composedMessage})
          .then(response => {
            if (response.status === 201) {
              this.updateMessages(response.data);
            }
          });
      }
      clearInterval(this.timer);
      this.setState({questionWaitTime: null});
    }
    if (this.textareaElement) {
      this.textareaElement.value = "";
      this.textareaElement.focus();
    }
  }

  getTimeoutMilliSeconds = (questionIndex) => {
    const waitTime = waitTimes[this.props.dialog.subject][questionIndex];
    return waitTime * 1000;
  }

  setTimeoutForNewTestQuestion = () => {
    this.setState((prevState) => {
      let questionIndex = prevState.questionIndex;
      if (questions[this.props.dialog.subject][questionIndex]) {
        const nextQuestion = questions[this.props.dialog.subject][questionIndex];
        this.questionTimeout = setTimeout(() => {
          const newMessage = {
            message: nextQuestion,
            type: 1,
            created_at: new Date(),
          };
          this.updateMessages(newMessage);
          this.timer = setInterval(() => this.increaseWaitTime(newMessage.created_at), 50);
        }, 8000);
        questionIndex++;
        return {
          questionIndex: questionIndex,
        };
      } else {
        setTimeout(this.endTestDialog, 5000);
      }
    });
  }

  setTimeoutForNewQuestion = () => {
    this.setState((prevState) => {
      let questionIndex = prevState.questionIndex;
      console.log("questionIndex", questionIndex, "for dialogIndex", this.props.dialogIndex);
      // If there are questions left for the subject, set timeout for next
      if (questions[this.props.dialog.subject][questionIndex]) {
        const nextQuestion = questions[this.props.dialog.subject][questionIndex];
        const timeoutMilliSeconds = this.getTimeoutMilliSeconds(questionIndex);
        // Set timeout for next question
        this.questionTimeout = setTimeout(() => this.sendSystemMessage(nextQuestion), timeoutMilliSeconds);
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

  sendSystemMessage = (message, dialog=this.props.dialog) => {
    axios.post("api/dialogs/" + dialog.id + "/messages", {message: message})
      .then(response => {
        if (response.status === 201) {
          this.updateMessages(response.data);
          this.timer = setInterval(() => this.increaseWaitTime(response.data.created_at), 50);
        }
      });
  }

  endTestDialog = () => {
    clearTimeout(this.questionTimeout);
    this.questionTimeout = null;
    this.setState({isEnded: true});
    if (this.props.exp === 2) {
      // Mark dialog unread because user has to know that is has eneded
      this.props.markDialogEnded(this.props.dialogIndex);
    }
  }

  endChatDialog = () => {
    axios.patch("api/dialogs/" + this.props.dialog.id, {is_ended: true})
      .then(response => {
        if (response.status === 200) {
          // Clear question timeout and set dialog ended
          clearTimeout(this.questionTimeout);
          this.questionTimeout = null;
          clearInterval(this.timer);
          this.timer = null;
          this.setState({
            isEnded: true,
            questionWaitTime: null,
          });
          if (this.props.exp === 2) {
            // Mark dialog unread because user has to know that is has eneded
            this.props.markDialogEnded(this.props.dialogIndex);
          }
        }
      });
  }

  render() {
    const textareaProps = {
      maxLength: 2000,
      value: this.state.composedMessage,
      onChange: event => this.onTextareaValueChange(event.target),
      onKeyDown: event => this.onTextareaKeyDown(event),
    };
    const sendButtonProps = {
      onClick: event => this.sendMessage(event),
    };
    let waitTime = (this.state.questionWaitTime / 1000).toFixed(0);
    return (
      <div className={"Dialog" + (this.props.exp === 1 ? " Exp1" : " Exp2") + (this.props.isActive ? " Active" : " Inactive")}>
        {!this.props.dialog &&
          <div className="ChatDialog"></div>
        }
        {this.state.isEnded && this.props.dialog !== null &&
          <div className="ChatDialog Ended">
            <p className="Subject">{this.props.dialog.subject}</p>
            <p>Tämä dialogi on päättynyt!</p>
            <button className="CloseButton" onClick={() => this.props.onCloseButtonClick(this.props.dialogIndex, this.props.dialog.id)}>Sulje</button>
          </div>
        }
        {!this.state.isEnded && this.props.dialog !== null &&
          <div className={"ChatDialog" + (this.state.isUnread ? " Unread" : "")}>
            <a className="Subject" href={this.pdf} onClick={(event) => this.props.onSubjectClick(event, this.props.dialog.subject)}>{this.props.dialog.subject}</a>
            {this.state.isUnread && this.state.questionWaitTime && <span>{waitTime}</span>}
            <ChatMessageList messages={this.state.messages} />
            <ChatDialogFooter>
              <textarea className="MessageTextarea" {...textareaProps} ref={element => this.textareaElement = element} autoComplete="off" autoCorrect="off" autoCapitalize="off" spellCheck="false" />
              <button className="SendButton" {...sendButtonProps}>Lähetä</button>
            </ChatDialogFooter>
            {/* for debugging purposes */}
            <button onClick={() => this.sendSystemMessage("system message")}>system message</button>
            <button onClick={() => this.endChatDialog()}>end dialog</button>
          </div>
        }
      </div>
    );
  }
}

export default ChatDialog;
