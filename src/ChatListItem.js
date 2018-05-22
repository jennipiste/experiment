import React, { Component } from 'react'; // eslint-disable-line no-unused-vars

class ChatListItem extends Component {
  render() {
    return (
      <div>
        <div className={"ChatListItem " + (this.props.isActive ? "active" : "")} onClick={event => this.props.onChatListItemClick(event, this.props.dialogIndex)} >
          {this.props.dialog ? (
            <span className="Subject">{this.props.dialog.subject}</span>
          ) : (
            <span className="Subject">Dialog not yet started</span>
          )}
          {this.props.isUnread && <span className="unread">new!</span>}
        </div>
      </div>
    );
  }
}

export default ChatListItem;
