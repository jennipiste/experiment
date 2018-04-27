import React, { Component } from 'react';
import { Route } from 'react-router-dom'
import './App.css';
import ChatDialogGrid from './ChatDialogGrid';
import ChatDialogList from './ChatDialogList';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      dialogs: [],
    };

  }

  componentDidMount() {
    this.initDialogs();
  }

  initDialogs() {
    let dialogs = [
      {
        messages: [
          {
            type: 1,
            message: "First message",
          },
          {
            type: 2,
            message: "Your message",
          },
        ],
        name: "Chat Dialog 1",
        id: 1,
      },
      {
        messages: [
          {
            type: 1,
            message: "First message",
          },
          {
            type: 1,
            message: "Second message",
          },
          {
            type: 2,
            message: "Your message",
          },
        ],
        name: "Chat Dialog 2",
        id: 2,
      },
      {
        messages: [
          {
            type: 2,
            message: "Your first message",
          },
          {
            type: 2,
            message: "Your second message",
          },
        ],
        name: "Chat Dialog 3",
        id: 3,
      },
    ]
    this.setState({dialogs: dialogs});
  }

  render() {
    return (
    <div className="App">
      <header className="App-header">
        <h1 className="App-title">Chat multitasking experiment</h1>
        <p className="App-intro">Let's test how many chats you can handle</p>
      </header>
      <Route path="/exp1" render={() => <ChatDialogGrid dialogs={this.state.dialogs}/>} />
      <Route path="/exp2" render={() => <ChatDialogList dialogs={this.state.dialogs}/>}/>
    </div>
    );
  }
}

export default App;
