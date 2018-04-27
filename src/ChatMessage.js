import React, { Component } from 'react';

class ChatMessage extends Component {
  constructor(props) {
    super(props);
  }

  render = () => {
    return (
    <div className={"ChatMessage " + (this.props.type === 1 ? "IncomingMessage" : "OutgoingMessage")}>
        <p >{this.props.message}</p>
    </div>
    );
  }
}

export default ChatMessage;
