import React, { Component } from 'react';

class ChatDialogFooter extends Component {
  render() {
    return (
    <div className="ChatDialogFooter">
      {this.props.children}
    </div>
    );
  }
}

export default ChatDialogFooter;
