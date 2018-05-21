import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatDialog from './ChatDialog';
import map from 'lodash/map';

class ChatDialogGrid extends Component {
  render() {
    let dialogs = map(this.props.dialogs, (dialog, index) => {
      return <ChatDialog {...dialog} key={index} onCreateNewChatDialog={this.props.onCreateNewChatDialog} isActive={true} exp={1} />;
    });

    return (
      <div className="ChatDialogGrid">
        {dialogs}
      </div>
    );
  }
}

export default ChatDialogGrid;
