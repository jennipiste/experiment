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
      unreadDialogs: [false, false, false, false],
      showPDF: false,
      subject: null,
    };
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.dialogs.lenght) {
      this.setState({
        dialogs: nextProps.dialogs,
      });
    }
    if (!this.state.activeDialogIndex) {
      const activeDialogIndex = 0;
      this.setState({activeDialogIndex: activeDialogIndex});
    }
  }

  onChatListItemClick = (event, index) => {
    this.setState({activeDialogIndex: index});
  }

  onSubjectClick = (event, subject) => {
    event.preventDefault();
    this.pdf = require("./manuals/" + subject + ".pdf");
    this.setState({
      showPDF: false,
    }, () => {
      this.setState({
        showPDF: true,
        subject: subject,
      });
    });
  }

  markDialogUnread = (dialogIndex) => {
    let unreadDialogs = this.state.unreadDialogs;
    unreadDialogs[dialogIndex] = true;
    this.setState({unreadDialogs: unreadDialogs});
  }

  markDialogRead = (dialogIndex) => {
    let unreadDialogs = this.state.unreadDialogs;
    unreadDialogs[dialogIndex] = false;
    this.setState({unreadDialogs: unreadDialogs});
  }

  render() {
    let chats = map(this.props.dialogs, (dialog, index) => {
      return <ChatListItem dialog={dialog} key={index} dialogIndex={index} onChatListItemClick={this.onChatListItemClick} isActive={this.state.activeDialogIndex === index} isUnread={dialog && this.state.unreadDialogs[index]}/>;
    });
    let dialogs = map(this.props.dialogs, (dialog, index) => {
      return <ChatDialog dialog={dialog} key={index} dialogIndex={index} onEndedOKClick={this.props.onEndedOKClick} isActive={this.state.activeDialogIndex === index} markDialogEnded={this.props.markDialogEnded} markDialogUnread={this.markDialogUnread} markDialogRead={this.markDialogRead} onSubjectClick={this.onSubjectClick} exp={2} />;
    });

    return (
      <div className="ChatDialogList">
        <div className="ChatList">
          {chats}
        </div>
        <div className="Dialogs">
          {dialogs}
        </div>
        {this.state.showPDF &&
          <iframe src={this.pdf} width="100%" frameBorder="0"></iframe>
        }
      </div>
    );
  }
}

export default ChatDialogList;
