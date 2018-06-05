import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatDialog from './ChatDialog';
import map from 'lodash/map';

class ChatDialogGrid extends Component {

  render() {
    let dialogs = map(this.props.dialogs, (dialog, index) => {
      return <ChatDialog
        participant={this.props.participant}
        layout={1}
        key={index}
        dialog={dialog}
        dialogIndex={index}
        isActive={true}
        markDialogEnded={this.props.markDialogEnded}
        onSubjectClick={this.props.onSubjectClick}
        endChatDialog={this.props.endChatDialog}
      />;
    });

    return (
      <div className="ChatDialogGrid">
        <div className="Dialogs">
          {dialogs}
        </div>
      </div>
    );
  }
}

export default ChatDialogGrid;
