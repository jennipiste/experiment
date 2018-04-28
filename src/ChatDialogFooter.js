import React, { Component } from 'react'; // eslint-disable-line no-unused-vars

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
