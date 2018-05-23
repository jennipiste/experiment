import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import ChatDialog from './ChatDialog';
import map from 'lodash/map';

class ChatDialogGrid extends Component {
  constructor(props) {
    super(props);
    this.state = {
      showPDF: false,
      subject: null,
    };

    this.pdf = this.state.subject ? require("./manuals/" + this.state.subject + ".pdf") : null;
  }

  onSubjectClick = (event, subject) => {
    event.preventDefault();
    this.pdf = require("./manuals/" + subject + ".pdf");
    this.setState({
      showPDF: true,
      subject: subject,
    });
  }

  render() {
    let dialogs = map(this.props.dialogs, (dialog, index) => {
      return <ChatDialog dialog={dialog} key={index} dialogIndex={index} markDialogEnded={this.props.markDialogEnded} onEndedOKClick={this.props.onEndedOKClick} isActive={true} exp={1} onSubjectClick={this.onSubjectClick} />;
    });

    return (
      <div className="ChatDialogGrid">
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

export default ChatDialogGrid;
