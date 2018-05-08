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
      is_ended: this.props.is_ended,
      isShown: !this.props.is_ended,
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
          messages: response.data,
          unread: response.data.slice(-1)[0].type === 1,
          is_ended: this.props.is_ended,
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
          this.setState({is_ended: true});
        }
      });
  }

  closeChatDialog = () => {
    this.setState({isShown: false});
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
        {this.state.isShown &&
        <div className={"ChatDialog" + (this.state.unread ? " unread" : "")}>
          <p>{this.props.name}</p>
          {this.state.is_ended ? (
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
