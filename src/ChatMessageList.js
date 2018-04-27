import React, { Component } from 'react';
import ChatMessage from './ChatMessage';
import map from 'lodash/map';

class ChatMessageList extends Component {
  constructor(props) {
    super(props);
    this.listElement = null;
  }

  scrollToBottom = () => {
    const scrollableHeight = this.listElement.scrollHeight - this.listElement.clientHeight;
    if (this.listElement.scrollTop !== scrollableHeight) {
        this.listElement.scrollTop = scrollableHeight;
    }
  }

  componentDidUpdate() {
    this.scrollToBottom();
  }

  render() {
    let messages = map(this.props.messages, (message, index) => {
      return <ChatMessage message={message.message} type={message.type} key={index}/>
    })

    return (
    <div className="ChatMessageList" ref={element => this.listElement = element}>
        {messages}
    </div>
    );
  }
}

export default ChatMessageList;
