import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatDialog from './ChatDialog';
import ChatListItem from './ChatListItem';
import map from 'lodash/map';
import find from 'lodash/find';
import filter from 'lodash/filter';


class ChatDialogList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      activeDialog: null,
      dialogs: [],
      dialogsWithUnreadMessages: [],
    };
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.dialogs.lenght) {
      this.setState({
        dialogs: nextProps.dialogs,
      });
    }
    if (!this.state.activeDialog) {
      let activeDialog = find(nextProps.dialogs, (dialog) => !dialog.is_closed);
      this.setState({activeDialog: activeDialog});
    }
  }

  onChatListItemClick = (event, chat_id) => {
    const dialog = find(this.state.dialogs, (dialog) => { return dialog.id === chat_id; });
    this.setState({activeDialog: dialog});
  }

  markDialogUnread = (dialogID) => {
    let dialogsWithUnreadMessages = this.state.dialogsWithUnreadMessages;
    dialogsWithUnreadMessages.push(dialogID);
    this.setState({dialogsWithUnreadMessages: dialogsWithUnreadMessages});
  }

  markDialogRead = (dialogID) => {
    let dialogsWithUnreadMessages = this.state.dialogsWithUnreadMessages;
    let index = dialogsWithUnreadMessages.indexOf(dialogID);
    dialogsWithUnreadMessages.splice(index, 1);
    this.setState({dialogsWithUnreadMessages: dialogsWithUnreadMessages});
  }

  render() {
    let chats = map(filter(this.props.dialogs, (dialog) => !dialog.is_closed), (dialog, index) => {
      return <ChatListItem {...dialog} key={index} onChatListItemClick={this.onChatListItemClick} isActive={this.state.activeDialog && this.state.activeDialog.id === dialog.id} isUnread={this.state.dialogsWithUnreadMessages.includes(dialog.id)}/>;
    });
    let dialogs = map(this.props.dialogs, (dialog, index) => {
      return <ChatDialog {...dialog} key={index} onCreateNewChatDialog={this.props.onCreateNewChatDialog} isActive={this.state.activeDialog && this.state.activeDialog.id === dialog.id} markDialogUnread={this.markDialogUnread} markDialogRead={this.markDialogRead} exp={2} />;
    });

    return (
      <div className="ChatDialogList">
        <div className="ChatList">
          {chats}
        </div>
        <div>
          {dialogs}
        </div>
      </div>
    );
  }
}

export default ChatDialogList;
