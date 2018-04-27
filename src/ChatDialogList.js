import React, { Component } from 'react';
import ChatDialog from './ChatDialog';
import ChatListItem from './ChatListItem';
import map from 'lodash/map';
import find from 'lodash/find';

class ChatDialogList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      activeDialog: this.props.dialogs[0],
    }
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.dialogs.lenght) {
      this.setState({activeDialog: nextProps.dialogs[0]});
    }
  }

  onChatListItemClick = (chat_id) => {
    const dialog = find(this.props.dialogs, (dialog) => { return dialog.id === chat_id; });
    this.setState({activeDialog: dialog});
  }

  render() {
    let dialogs = map(this.props.dialogs, (dialog, index) => {
      return <ChatListItem {...dialog} key={index} onChatListItemClick={this.onChatListItemClick}/>
    });

    return (
    <div className="ChatDialogList">
      <div className="ChatList">
        {dialogs}
      </div>
      {this.state.activeDialog && <ChatDialog {...this.state.activeDialog} />}
    </div>
    );
  }
}

export default ChatDialogList;
