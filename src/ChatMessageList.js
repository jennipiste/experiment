import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatMessage from './ChatMessage';
import map from 'lodash/map';

class ChatMessageList extends Component {
  constructor(props) {
    super(props);
    this.listElement = null;
  }

  componentDidMount() {
    this.scrollToBottom();
  }

  scrollToBottom = () => {
    console.log("scroll")
    const scrollableHeight = this.listElement.scrollHeight - this.listElement.clientHeight;
    if (this.listElement.scrollTop !== scrollableHeight) {
      this.listElement.scrollTop = scrollableHeight;
    }
  }

  componentWillUpdate(nextProps) {
    if (nextProps.messages !== this.props.messages) {
      this.scrollToBottom();
    }
  }

  render() {
    let messages = map(this.props.messages, (message, index) => {
      return <ChatMessage message={message.message} type={message.type} key={index} />;
    });

    return (
      <div className="ChatMessageList" ref={element => this.listElement = element}>
        {messages}
      </div>
    );
  }
}

export default ChatMessageList;
