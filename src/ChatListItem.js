import React, { Component } from 'react';

class ChatListItem extends Component {
  constructor(props) {
    super(props);
    this.listElement = null;
  }

  render() {
    return (
    <div className="ChatListItem" onClick={event => this.props.onChatListItemClick(this.props.id)} ref={element => this.listElement = element}>
        {this.props.name}
    </div>
    );
  }
}

export default ChatListItem;
