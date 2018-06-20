import React from 'react';
import map from 'lodash/map';


class Modal extends React.Component {
  render() {
    const modalActions = map(this.props.actions, (action, index) => {
      return <button onClick={action.onClick} key={index}>{action.text}</button>;
    });

    return (
      <div className="Backdrop">
        <div className="Modal">
          <div className="ModalContent">
            {!this.props.isQuestionnaireSubmitted ? (
              <div>
                <p>{this.props.text1}</p>
                {this.props.children}
              </div>
            ) : (
              <p>{this.props.text2}</p>
            )}
          </div>
          {this.props.isQuestionnaireSubmitted &&
            <div className="ModalFooter">{modalActions}</div>
          }
        </div>
      </div>
    );
  }
}

export default Modal;