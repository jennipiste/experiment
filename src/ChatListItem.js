import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import WaitTime from './WaitTime';


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
          {(this.props.waitingStartedAt && !this.props.isEnded) && <span className="Unread">
            <WaitTime waitingStartedAt={this.props.waitingStartedAt} />
          </span>}
        </div>
      </div>
    );
  }
}

export default ChatListItem;
