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
            <p>{this.props.text1}</p>
            <p>{this.props.text2}</p>
          </div>
          <div className="ModalFooter">{modalActions}</div>
        </div>
      </div>
    );
  }
}

export default Modal;