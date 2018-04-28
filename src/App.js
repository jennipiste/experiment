import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import { Route } from 'react-router-dom';
import axios from'axios';
import axiosDefaults from 'axios/lib/defaults';
import ChatDialogGrid from './ChatDialogGrid';
import ChatDialogList from './ChatDialogList';
import './App.css';

axiosDefaults.baseURL = 'http://localhost:8000';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      dialogs: [],
      participantName: "",
      activeParticipant: null,
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
    ];
    this.setState({dialogs: dialogs});
  }

  onParticipantNameChange = (event) => {
    this.setState({participantName: event.target.value});
  }

  createParticipant = (event) => {
    event.preventDefault();
    axios.post('api/participants', {name: this.state.participantName})
      .then(response => {
        this.setState({
          activeParticipant: response.data,
        });
      });
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <h1 className="App-title">Chat multitasking experiment</h1>
          <p className="App-intro">{this.state.activeParticipant && "Welcome " + this.state.activeParticipant.name + "! "}Let's test how many chats you can handle</p>
        </header>
        {this.state.activeParticipant ? (
          <div>
            <Route path="/exp1" render={() => <ChatDialogGrid dialogs={this.state.dialogs}/>} />
            <Route path="/exp2" render={() => <ChatDialogList dialogs={this.state.dialogs}/>}/>
          </div>
        ) : (
          <div className="CreateParticipant">
            <form onSubmit={this.createParticipant}>
              <label>Name:
                <input type="text" value={this.state.participantName} onChange={this.onParticipantNameChange} />
              </label>
              <input type="submit" value="Start" />
            </form>
          </div>
        )}
      </div>
    );
  }
}

export default App;
