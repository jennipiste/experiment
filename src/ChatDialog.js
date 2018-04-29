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

  sendMessage = () => {
    if (this.state.composedMessage.length) {
      const composedMessage = this.state.composedMessage;
      axios.post("api/participants/" + this.props.participant + "/dialogs/" + this.props.id + "/messages", {message: composedMessage})
        .then(response => {
          if (response.status === 201) {
            this.setState((prevState) => {
              const messages = prevState.messages;
              messages.push(response.data);
              return {
                messages: messages,
                composedMessage: "",
              };
            }, this.clearTextarea);
          }
        });
    }
    if (this.textareaElement) {
      this.textareaElement.focus();
    }
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
      <div className="ChatDialog">
        <p>{this.props.name}</p>
        <ChatMessageList messages={this.state.messages} />

        <ChatDialogFooter>
          <textarea className="MessageTextarea" {...textareaProps} ref={element => this.textareaElement = element}/>
          <button className="SendButton" {...sendButtonProps}>SEND</button>
        </ChatDialogFooter>
      </div>
    );
  }
}

export default ChatDialog;
