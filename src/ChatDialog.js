import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatMessageList from './ChatMessageList';
import ChatDialogFooter from './ChatDialogFooter';
import axios from 'axios';
import questions from './questions';
import waitTimes from './wait_times';
import filter from 'lodash/filter';

class ChatDialog extends Component {
  constructor(props) {
    super(props);

    this.state = {
      composedMessage: "",
      messages: [],
      unread: true,  // At first they all are unread
      isEnded: this.props.dialog ? this.props.dialog.is_ended : false,
      questionIndex: 1,  // Start from the second question, first is already sent
      activeElement: null,
    };

    this.textareaElement = null;
    this.pdf = this.props.dialog ? require("./manuals/" + this.props.dialog.subject + ".pdf") : null;
    this.questionTimeout = null;
  }

  componentDidMount() {
    this.initMessages();
    if (this.props.exp === 2) {
      this.props.markDialogUnread(this.props.dialogIndex);  // Dialogs are unread at the beginning
    }
  }

  componentWillReceiveProps(nextProps) {
    this.pdf = nextProps.dialog ? require("./manuals/" + nextProps.dialog.subject + ".pdf") : null;
    if (nextProps.dialog !== this.props.dialog) {
      this.initMessages(nextProps);
    }
  }

  componentWillUnmount() {
    clearTimeout(this.questionTimeout);
  }

  initMessages = (props=this.props) => {  // props can be either nextProps or this.props
    if (props.dialog) {
      axios.get("api/participants/" + props.dialog.participant + "/dialogs/" + props.dialog.id + "/messages")
        .then(response => {
          this.setState({
            messages: response.data,
            unread: response.data.length && response.data.slice(-1)[0].type === 1,
            isEnded: props.dialog ? props.dialog.is_ended : false,
            questionIndex: 1,
          }, () => {
            if (this.props.exp === 2 && props.isActive) {
              if (this.textareaElement) {
                this.textareaElement.focus();
              }
            }
          });
        });
    }
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

  clearTextarea = () => {
    this.textareaElement.value = "";
  }

  updateMessages = (newMessage) => {
    this.setState((prevState) => {
      const messages = prevState.messages;
      messages.push(newMessage);
      return {
        messages: messages,
        composedMessage: newMessage.type === 1 ? prevState.composedMessage : "",
        unread: newMessage.type === 1 ? true : false,
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
    });
  }

  sendMessage = () => {
    if (this.state.composedMessage.length) {
      const composedMessage = this.state.composedMessage;
      axios.post("api/participants/" + this.props.dialog.participant + "/dialogs/" + this.props.dialog.id + "/messages", {message: composedMessage})
        .then(response => {
          if (response.status === 201) {
            this.updateMessages(response.data);
            this.clearTextarea();
            // Set timeout for next question only after user's first message
            const previousMessageIndex = this.state.messages.length - 2;
            if (this.state.messages[previousMessageIndex].type === 1) {
              this.setTimeoutForNewQuestion();
            }
          }
        });
    }
    if (this.textareaElement) {
      this.textareaElement.focus();
    }
  }

  getTimeoutMilliSeconds = (questionIndex) => {
    const waitTime = waitTimes[this.props.dialog.subject][questionIndex];
    return waitTime * 1000;
  }

  setTimeoutForNewQuestion = () => {
    console.log("set timeout for new question, for dialog", this.props.dialogIndex);
    this.setState((prevState) => {
      let questionIndex = prevState.questionIndex;
      console.log("question index is", questionIndex, "for dialog", this.props.dialogIndex);
      // If there are questions left for the subject, set timeout for next
      if (questions[this.props.dialog.subject][questionIndex]) {
        const nextQuestion = questions[this.props.dialog.subject][questionIndex];
        const timeoutMilliSeconds = this.getTimeoutMilliSeconds(questionIndex);
        // Set timeout for next question
        this.questionTimeout = setTimeout(() => this.sendSystemMessage(nextQuestion), timeoutMilliSeconds);
        questionIndex++;
        console.log("now set new question index", questionIndex, "for dialog", this.props.dialogIndex);
        return {
          questionIndex: questionIndex,
        };
      } else {
        // Otherwise end the chat after 5 seconds
        console.log("end chat after 5 secs, dialog", this.props.dialogIndex);
        setTimeout(this.endChatDialog, 5000);
        return;
      }
    });
  }

  sendSystemMessage = (message) => {
    axios.post("api/dialogs/" + this.props.dialog.id + "/messages", {message: message})
      .then(response => {
        if (response.status === 201) {
          this.updateMessages(response.data);
        }
      });
  }

  endChatDialog = () => {
    axios.patch("api/dialogs/" + this.props.dialog.id, {is_ended: true})
      .then(response => {
        if (response.status === 200) {
          // Clear question timeout and set dialog ended
          clearTimeout(this.questionTimeout);
          this.questionTimeout = null;
          this.setState({isEnded: true});
          if (this.props.exp === 2) {
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
    return (
      <div>
        {this.props.isActive &&
          <div>
            {!this.props.dialog &&
              <div className="ChatDialog"></div>
            }
            {this.state.isEnded && this.props.dialog !== null &&
              <div className="ChatDialog ended">
                <p className="Subject">{this.props.dialog.subject}</p>
                <p>This dialog has ended!</p>
                <button onClick={() => this.props.onEndedOKClick(this.props.dialogIndex, this.props.dialog.id)}>OK</button>
              </div>
            }
            {!this.state.isEnded && this.props.dialog !== null &&
              <div className={"ChatDialog" + (this.state.unread ? " unread" : "")}>
                <a className="Subject" href={this.pdf} onClick={(event) => this.props.onSubjectClick(event, this.props.dialog.subject)}>{this.props.dialog.subject}</a>
                <ChatMessageList messages={this.state.messages} />
                <ChatDialogFooter>
                  <textarea className="MessageTextarea" {...textareaProps} ref={element => this.textareaElement = element} autoComplete="off" autoCorrect="off" autoCapitalize="off" spellCheck="false" />
                  <button className="SendButton" {...sendButtonProps}>SEND</button>
                </ChatDialogFooter>
                {/* for debugging purposes */}
                <button onClick={() => this.sendSystemMessage("system message")}>system message</button>
                <button onClick={() => this.endChatDialog()}>end dialog</button>
              </div>
            }
          </div>
        }
      </div>
    );
  }
}

export default ChatDialog;
