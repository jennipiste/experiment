import React, { Component } from 'react';
import ChatMessageList from './ChatMessageList';
import ChatDialogFooter from './ChatDialogFooter';

class ChatDialog extends Component {
  constructor(props) {
    super(props);

    this.state = {
      composedMessage: "",
      messages: this.props.messages,
    }

    this.textareaElement = null;
  }

  componentDidMount() {
    this.setState({messages: this.props.messages});
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.messages.lenght) {
      this.setState({messages: nextProps.messages});
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

  sendMessage = () => {
    if (this.state.composedMessage.length) {
      const composedMessage = this.state.composedMessage;
      this.textareaElement.value = "";
      this.setState((prevState) => {
        let messages = prevState.messages;
        messages.push({message: composedMessage, type: 2});
        return {
          messages: messages,
          composedMessage: "",
        }
      });
    }
    this.textareaElement.focus();
  }

  render() {
    const textareaProps = {
      maxLength: 2000,
      onChange: event => this.onTextareaValueChange(event.target),
      onKeyDown: event => this.onTextareaKeyDown(event),
    };
    const sendButtonProps = {
      onClick: event => this.sendMessage(),
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
