import React, { Component } from 'react'; // eslint-disable-line no-unused-vars

class ChatListItem extends Component {
  render() {
    return (
      <div>
        <div className={"ChatListItem" + (this.props.isActive ? " Active" : "") + (this.props.isEnded ? " Ended" : "")} onClick={event => this.props.onChatListItemClick(event, this.props.dialogIndex)} >
          {this.props.dialog ? (
            <span className="Subject">{this.props.dialog.subject}</span>
          ) : (
            <span className="Subject Ended">Ei käynnissä olevaa dialogia</span>
          )}
          {(this.props.isUnread && !this.props.isEnded) && <span className="Unread">new!</span>}
          {this.props.isEnded && <span className="Ended">ended!</span>}
        </div>
      </div>
    );
  }
}

export default ChatListItem;
