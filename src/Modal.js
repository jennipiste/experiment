import React from 'react';
import map from 'lodash/map';


class Modal extends React.Component {
  render() {

    // The gray background
    // const backdropStyle = {
    //   position: 'fixed',
    //   top: 0,
    //   bottom: 0,
    //   left: 0,
    //   right: 0,
    //   backgroundColor: 'rgba(0,0,0,0.3)',
    //   padding: 50
    // };

    // // The modal "window"
    // const modalStyle = {
    //   backgroundColor: '#fff',
    //   borderRadius: 5,
    //   maxWidth: 500,
    //   minHeight: 300,
    //   margin: '0 auto',
    //   padding: 30
    // };

    const modalActions = map(this.props.actions, (action, index) => {
      return <button onClick={action.onClick} key={index}>{action.text}</button>;
    });

    return (
      <div className="Backdrop">
        <div className="Modal">
          {this.props.text}
          <div className="ModalFooter">
            {modalActions}
          </div>
        </div>
      </div>
    );
  }
}

export default Modal;