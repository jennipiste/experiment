import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatMessageList from './ChatMessageList';
import ChatDialogFooter from './ChatDialogFooter';
import axios from 'axios';
import questions from './questions';

class ChatDialog extends Component {
  constructor(props) {
    super(props);

    this.state = {
      composedMessage: "",
      messages: [],
      unread: false,
      isEnded: this.props.is_ended,
      isClosed: this.props.is_closed,
      questionIndex: 0,
    };

    this.textareaElement = null;
    this.pdf;
    this.questionTimeout;
  }

  componentDidMount() {
    this.initMessages();
  }

  componentWillReceiveProps(nextProps) {
    this.pdf = require("./manuals/" + nextProps.subject + ".pdf");
    this.initMessages(nextProps);
  }

  initMessages = (props=this.props) => {  // props can be either nextProps or this.props
    axios.get("api/participants/" + props.participant + "/dialogs/" + props.id + "/messages")
      .then(response => {
        this.setState({
          messages: response.data,
          unread: response.data.length && response.data.slice(-1)[0].type === 1,
          isEnded: props.is_ended,
          isClosed: props.is_closed,
        }, () => {
          // If there is no messages, send the first question
          if (!this.state.messages.length) {
            this.setState({
              questionIndex: 0
            }, () => {
              let questionIndex = this.state.questionIndex;
              const nextQuestion = questions[props.subject][questionIndex];
              this.sendSystemMessage(nextQuestion);
              questionIndex++;
              this.setState({
                questionIndex: questionIndex
              });
            });
          }
          if (props.isActive) {
            if (this.textareaElement) {
              this.textareaElement.focus();
            }
          }
        });
      });
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
      if (newMessage.type === 1) {
        this.props.markDialogUnread(this.props.id);
      } else {
        this.props.markDialogRead(this.props.id);
      }
    });
  }

  sendMessage = () => {
    if (this.state.composedMessage.length) {
      const composedMessage = this.state.composedMessage;
      axios.post("api/participants/" + this.props.participant + "/dialogs/" + this.props.id + "/messages", {message: composedMessage})
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

  getTimeoutMilliSeconds = () => {
    // TODO: get real values from data
    const max = 120;
    const min = 10;
    const random = Math.random() * (max - min) + min;
    return random * 1000;
  }

  setTimeoutForNewQuestion = () => {
    let questionIndex = this.state.questionIndex;
    if (questionIndex < 3) {
      const nextQuestion = questions[this.props.subject][questionIndex];
      const milliSeconds = this.getTimeoutMilliSeconds();
      // Set timeout for next question
      this.questionTimeout = setTimeout(() => this.sendSystemMessage(nextQuestion), milliSeconds);
      // Increase questionIndex
      questionIndex++;
      this.setState({questionIndex: questionIndex});
    } else {
      this.endChatDialog();
    }
  }

  sendSystemMessage = (message) => {
    axios.post("api/dialogs/" + this.props.id + "/messages", {message: message})
      .then(response => {
        if (response.status === 201) {
          this.updateMessages(response.data);
        }
      });
  }

  endChatDialog = () => {
    axios.patch("api/dialogs/" + this.props.id, {is_ended: true})
      .then(response => {
        if (response.status === 200) {
          // Clear timeout for next question
          clearTimeout(this.questionTimeout);
          this.setState({isEnded: true});
        }
        // Set timeout to create new dialog
        setTimeout(() => this.props.onCreateNewChatDialog(this.props.id), 10000);
      });
  }

  openPDF = (event) => {
    event.preventDefault();
    const left = window.screenX + window.outerWidth;
    window.open(this.pdf, 'newwindow', 'fullscreen=yes, left=' + left + '');
    return false;
  }

  render() {
    const textareaProps = {
      maxLength: 2000,
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
            {this.state.isEnded ? (
              <div className="ChatDialog ended">
                <p className="Subject">{this.props.subject}</p>
                <p>This dialog has ended!</p>
              </div>
            ) : (
              <div className={"ChatDialog" + (this.state.unread ? " unread" : "")}>
                {this.props.subject && <a className="Subject" href={this.pdf} onClick={(event) => this.openPDF(event)}>{this.props.subject}</a>}
                <ChatMessageList messages={this.state.messages} />
                <ChatDialogFooter>
                  <textarea className="MessageTextarea" {...textareaProps} ref={element => this.textareaElement = element}/>
                  <button className="SendButton" {...sendButtonProps}>SEND</button>
                </ChatDialogFooter>
                {/* for debugging purposes */}
                <button onClick={() => this.sendSystemMessage("system message")}>system message</button>
                <button onClick={() => this.endChatDialog()}>end dialog</button>
              </div>
            )}
          </div>
        }
      </div>
    );
  }
}

export default ChatDialog;
