import React, { Component } from 'react';
import ChatDialog from './ChatDialog';
import map from 'lodash/map';

class ChatDialogList extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    let dialogs = map(this.props.dialogs, (dialog, index) => {
      return <ChatDialog {...dialog} key={index} />
    });

    return (
    <div className="ChatDialogList">
      {dialogs}
    </div>
    );
  }
}

export default ChatDialogList;
