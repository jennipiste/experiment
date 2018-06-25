import React, { Component } from 'react'; // eslint-disable-line no-unused-vars

class ChatMessage extends Component {
  render() {
    return (
      <div className={"ChatMessage " + (this.props.senderType === 1 ? "QuestionMessage" : "AnswerMessage")}>
        <p>{this.props.message}</p>
      </div>
    );
  }
}

export default ChatMessage;
