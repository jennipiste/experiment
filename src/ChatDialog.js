import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatMessageList from './ChatMessageList';
import ChatDialogFooter from './ChatDialogFooter';
import axios from 'axios';

class ChatDialog extends Component {
  constructor(props) {
    super(props);

    this.state = {
      composedMessage: "",
      messages: [],
      unread: false,
      isEnded: this.props.is_ended,
      isClosed: this.props.is_closed,
    };

    this.textareaElement = null;
    this.pdf = require("./manuals/" + this.props.subject + ".pdf");
  }

  componentDidMount() {
    this.initMessages();
  }

  componentWillReceiveProps(nextProps) {
    this.initMessages(nextProps);
  }

  initMessages = (props=this.props) => {  // props can be either nextProps or this.props
    axios.get("api/participants/" + props.participant + "/dialogs/" + props.id + "/messages")
      .then(response => {
        this.setState({
          messages: response.data,
          unread: response.data.length && response.data.slice(-1)[0].type === 1,
        });
        if (props.exp === 2) {
          this.setState({
            isEnded: props.is_ended,
            isClosed: props.is_closed,
          });
        }
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
          }
        });
    }
    if (this.textareaElement) {
      this.textareaElement.focus();
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
          this.setState({isEnded: true});
        }
      });
  }

  closeChatDialog = () => {
    axios.patch("api/dialogs/" + this.props.id, {is_closed: true})
      .then(response => {
        if (response.status === 200) {
          this.setState({isClosed: true});
          this.props.onChatDialogClose();
        }
      });
  }

  openPDF = (event) => {
    event.preventDefault();
    const left = window.screenX + window.outerWidth;
    window.open(this.pdf + "#3", 'newwindow', 'fullscreen=yes, left=' + left + '');
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
    const systemMessage = "system message";
    return (
      <div>
        {(!this.state.isClosed || this.props.exp === 2) &&
        <div className={"ChatDialog" + (this.state.unread ? " unread" : "")}>
          <p>{this.props.name}</p>
          {this.props.subject && <a href={this.pdf} onClick={(event) => this.openPDF(event)}>{this.props.subject}</a>}
          {this.state.isEnded ? (
            <div className="CloseDialog"><button onClick={() => this.closeChatDialog()}>Close</button></div>
          ) : (
            <ChatMessageList messages={this.state.messages} />
          )}

          <ChatDialogFooter>
            <textarea className="MessageTextarea" {...textareaProps} ref={element => this.textareaElement = element}/>
            <button className="SendButton" {...sendButtonProps}>SEND</button>
          </ChatDialogFooter>
          {/* for debugging purposes */}
          <button onClick={() => this.sendSystemMessage(systemMessage)}>system message</button>
          <button onClick={() => this.endChatDialog()}>end dialog</button>
        </div>
        }
      </div>
    );
  }
}

export default ChatDialog;
