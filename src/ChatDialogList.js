import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatDialog from './ChatDialog';
import ChatListItem from './ChatListItem';
import map from 'lodash/map';


class ChatDialogList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      activeDialogIndex: null,
      dialogs: [],
      waitingDialogs: [false, false, false, false],
      lastMessages: [null, null, null, null],
    };
  }

  componentDidMount() {
    if (!this.props.dialogs.lenght) {
      this.setState({
        dialogs: this.props.dialogs,
      });
    }
    this.setState({activeDialogIndex: 0});
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.dialogs.lenght) {
      this.setState({
        dialogs: nextProps.dialogs,
      });
    }
    if (this.props.dialogs !== nextProps.dialogs || !this.state.activeDialogIndex) {
      this.setState({activeDialogIndex: 0});
    }
  }

  onChatListItemClick = (event, index) => {
    this.setState({activeDialogIndex: index});
  }

  markDialogWaiting = (dialogIndex, waitingStartedAt) => {
    let waitingDialogs = this.state.waitingDialogs;
    waitingDialogs[dialogIndex] = waitingStartedAt;
    this.setState({waitingDialogs: waitingDialogs});
  }

  markDialogNotWaiting = (dialogIndex) => {
    let waitingDialogs = this.state.waitingDialogs;
    waitingDialogs[dialogIndex] = null;
    this.setState({waitingDialogs: waitingDialogs});
  }

  setLastMessage = (dialogIndex, message) => {
    let lastMessages = this.state.lastMessages;
    lastMessages[dialogIndex] = message;
    this.setState({lastMessages: lastMessages});
  }

  render() {
    let chats = map(this.props.dialogs, (dialog, index) => {
      return <ChatListItem
        key={index}
        dialog={dialog}
        dialogIndex={index}
        isActive={this.state.activeDialogIndex === index}
        waitingStartedAt={dialog && this.state.waitingDialogs[index]}
        isEnded={dialog && dialog.is_ended}
        onChatListItemClick={this.onChatListItemClick}
        notification={this.props.participant.notification}
        lastMessage={this.state.lastMessages[index]}
      />;
    });
    let dialogs = map(this.props.dialogs, (dialog, index) => {
      return <ChatDialog
        participant={this.props.participant}
        layout={2}
        key={index}
        dialog={dialog}
        dialogIndex={index}
        isActive={this.state.activeDialogIndex === index}
        markDialogEnded={this.props.markDialogEnded}
        markDialogWaiting={this.markDialogWaiting}
        markDialogNotWaiting={this.markDialogNotWaiting}
        setLastMessage={this.setLastMessage}
        onSubjectClick={this.props.onSubjectClick}
        endChatDialog={this.props.endChatDialog}
        experimentPartStartedAt={this.props.experimentPartStartedAt}
      />;
    });

    return (
      <div className="ChatDialogList">
        <div className="ChatList">
          {chats}
        </div>
        <div className="Dialogs">
          {dialogs}
        </div>
      </div>
    );
  }
}

export default ChatDialogList;
