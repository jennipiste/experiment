import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatDialog from './ChatDialog';
import ChatListItem from './ChatListItem';
import map from 'lodash/map';
import find from 'lodash/find';
import filter from 'lodash/filter';
import remove from 'lodash/remove';

class ChatDialogList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      activeDialog: null,
      dialogs: [],
    };
  }

  componentWillReceiveProps(nextProps) {
    let activeDialog = find(nextProps.dialogs, (dialog) => !dialog.is_closed);
    if (!this.props.dialogs.lenght) {
      this.setState({
        activeDialog: activeDialog,
        dialogs: nextProps.dialogs,
      });
    }
  }

  onChatListItemClick = (event, chat_id) => {
    const dialog = find(this.state.dialogs, (dialog) => { return dialog.id === chat_id; });
    this.setState({activeDialog: dialog});
  }

  onChatDialogClose = () => {
    let dialogs = this.state.dialogs;
    remove(dialogs, (dialog) => dialog.id === this.state.activeDialog.id);
    let nextActive = find(this.props.dialogs, (dialog) => !dialog.is_closed);
    this.setState({
      dialogs: dialogs,
      activeDialog: nextActive,
    });
    this.props.onChatDialogClose();
  }

  render() {
    let dialogs = map(filter(this.props.dialogs, (dialog) => !dialog.is_closed), (dialog, index) => {
      return <ChatListItem {...dialog} key={index} onChatListItemClick={this.onChatListItemClick} isActive={this.state.activeDialog && this.state.activeDialog.id === dialog.id} />;
    });

    return (
      <div className="ChatDialogList">
        <div className="ChatList">
          {dialogs}
        </div>
        {this.state.activeDialog && <ChatDialog {...this.state.activeDialog} onChatDialogClose={this.onChatDialogClose} exp={2} />}
      </div>
    );
  }
}

export default ChatDialogList;
