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
      showPDF: false,
      subject: null,
    };
  }

  componentDidMount() {
    if (!this.props.dialogs.lenght) {
      this.setState({
        dialogs: this.props.dialogs,
      });
    }
    const activeDialogIndex = 0;
    this.setState({activeDialogIndex: activeDialogIndex});
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
      />;
    });
    let dialogs = map(this.props.dialogs, (dialog, index) => {
      return <ChatDialog
        participant={this.props.participant}
        exp={2}
        key={index}
        dialog={dialog}
        dialogIndex={index}
        isActive={this.state.activeDialogIndex === index}
        markDialogEnded={this.props.markDialogEnded}
        markDialogWaiting={this.markDialogWaiting}
        markDialogNotWaiting={this.markDialogNotWaiting}
        onSubjectClick={this.onSubjectClick}
        onCloseButtonClick={this.props.onCloseButtonClick}
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
        {this.state.showPDF &&
          <iframe src={this.pdf} width="100%" frameBorder="0" title="PDF"></iframe>
        }
      </div>
    );
  }
}

export default ChatDialogList;
