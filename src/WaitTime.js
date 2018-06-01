import React, { Component } from 'react'; // eslint-disable-line no-unused-vars


class WaitTime extends Component {
  constructor(props) {
    super(props);
    this.state = {
      waitTime: null,
    };

    this.timer = null;
  }

  componentWillMount() {
    this.timer = setInterval(() => this.increaseWaitTime(), 50);
  }

  componentWillUnmount() {
    clearInterval(this.timer);
  }

  increaseWaitTime = () => {
    const start = new Date(this.props.waitingStartedAt);
    this.setState({waitTime: new Date() - start});
  }

  render() {
    let waitTime = (this.state.waitTime / 1000).toFixed(0);
    return(
      <div>
        {waitTime}
      </div>
    );
  }
}

export default WaitTime;
