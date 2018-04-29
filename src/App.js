import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import { Route } from 'react-router-dom';
import axios from'axios';
import axiosDefaults from 'axios/lib/defaults';
import ChatDialogGrid from './ChatDialogGrid';
import ChatDialogList from './ChatDialogList';
import Modal from './Modal';
import './App.css';

axiosDefaults.baseURL = 'http://localhost:8000';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      dialogs: [],
      participantName: "",
      participantResponse: null,
      activeParticipant: null,
      isModalOpen: false,
    };

  }

  initDialogs() {
    // const dialogs = [
    //   {
    //     messages: [
    //       {
    //         type: 1,
    //         message: "First message",
    //       },
    //       {
    //         type: 2,
    //         message: "Your message",
    //       },
    //     ],
    //     name: "Chat Dialog 1",
    //     id: 1,
    //   },
    //   {
    //     messages: [
    //       {
    //         type: 1,
    //         message: "First message",
    //       },
    //       {
    //         type: 1,
    //         message: "Second message",
    //       },
    //       {
    //         type: 2,
    //         message: "Your message",
    //       },
    //     ],
    //     name: "Chat Dialog 2",
    //     id: 2,
    //   },
    //   {
    //     messages: [
    //       {
    //         type: 2,
    //         message: "Your first message",
    //       },
    //       {
    //         type: 2,
    //         message: "Your second message",
    //       },
    //     ],
    //     name: "Chat Dialog 3",
    //     id: 3,
    //   },
    // ];
    // this.setState({dialogs: dialogs});
    axios.get("api/participants/" + this.state.activeParticipant.id + "/dialogs")
      .then(response => {
        this.setState({
          dialogs: response.data
        });
      });
  }

  onParticipantNameChange = (event) => {
    this.setState({participantName: event.target.value});
  }

  createParticipant = (event) => {
    event.preventDefault();
    axios.post("api/participants", {name: this.state.participantName})
      .then(response => {
        if (response.status === 201) {
          this.setState({
            activeParticipant: response.data,
            participantName: "",
          }, this.initDialogs);
        } else if (response.status === 200) {
          // If participant already exists, show modal
          this.setState({
            isModalOpen: true,
            participantResponse: response.data,
          });
        }
      });
  }

  onUseExistingParticipant = () => {
    this.setState((prevState) => {
      return {
        activeParticipant: prevState.participantResponse,
        participantName: "",
        participantResponse: null,
        isModalOpen: false,
      };
    }, this.initDialogs);
  }

  onCreateNewParticipant = () => {
    this.setState({
      participantResponse: null,
      isModalOpen: false,
    });
  }

  render() {
    const modalProps = {
      text: 'Participant with name "' + this.state.participantName + '" already exists. Do you want to use the existing participant or create new participant with different name?',
      actions: [
        {
          text: "Use existing",
          onClick: this.onUseExistingParticipant,
        },
        {
          text: "Create new",
          onClick: this.onCreateNewParticipant,
        }
      ]
    };

    return (
      <div className="App">
        <header className="App-header">
          <h1 className="App-title">Chat multitasking experiment</h1>
          {this.state.activeParticipant && <p className="App-intro">{"Welcome " + this.state.activeParticipant.name + "! "}Let's test how many chats you can handle</p>}
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
        {this.state.isModalOpen && <Modal {...modalProps}/>}
      </div>
    );
  }
}

export default App;
