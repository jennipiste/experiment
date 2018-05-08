import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatMessageList from './ChatMessageList';
import ChatDialogFooter from './ChatDialogFooter';
import axios from 'axios';

class ChatDialog extends Component {
  constructor(props) {
    super(props);

    this.state = {
      composedMessage: "",
      messages: this.props.messages,
      unread: false,
    };

    this.textareaElement = null;
  }

  componentDidMount() {
    this.initMessages();
  }

  initMessages = () => {
    axios.get("api/participants/" + this.props.participant + "/dialogs/" + this.props.id + "/messages")
      .then(response => {
        this.setState({
          messages: response.data
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
        composedMessage: "",
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
      <div className={"ChatDialog" + (this.state.unread ? " unread" : "")}>
        <p>{this.props.name}</p>
        <ChatMessageList messages={this.state.messages} />

        <ChatDialogFooter>
          <textarea className="MessageTextarea" {...textareaProps} ref={element => this.textareaElement = element}/>
          <button className="SendButton" {...sendButtonProps}>SEND</button>
        </ChatDialogFooter>
        {/* for debugging purposes */}
        <button onClick={() => this.sendSystemMessage(systemMessage)}>system message</button>
      </div>
    );
  }
}

export default ChatDialog;
