import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import { Route } from 'react-router-dom';
import axios from'axios';
import axiosDefaults from 'axios/lib/defaults';
import nth from 'lodash/nth';
import ChatDialogGrid from './ChatDialogGrid';
import ChatDialogList from './ChatDialogList';
import Modal from './Modal';
import './App.css';

axiosDefaults.baseURL = 'http://localhost:8000';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      dialogIndex: 1,
      dialogs: [],
      subjectIndex: 0,
      participantName: "",
      participantResponse: null,
      activeParticipant: null,
      isModalOpen: false,
    };

    this.subjects = [
      'astianpesukone',
      'cheerleading',
      'jääkaappi',
      'kamera',
      'kouluratsastus',
      'kuulokkeet',
      'lattialiesi',
      'liesituuletin',
      'miekkailu',
      'mikroaaltouuni',
      'pöytätennis',
      'puhelin',
      'pyykinpesukone',
      'stereot',
      'suunnistus',
      'tabletti',
      'televisio',
      'tennis',
    ];
  }

  initDialogs() {
    axios.get("api/participants/" + this.state.activeParticipant.id + "/dialogs")
      .then(response => {
        const dialogs = response.data;
        if (dialogs.length) {
          this.setState({
            dialogs: dialogs
          });
        } else {
          this.createInitialDialogs();
        }
      });
  }

  createInitialDialogs = () => {
    let dialogs = [];
    let dialogIndex = this.state.dialogIndex;
    let subjectIndex = this.state.subjectIndex;
    axios.post('api/participants/' + this.state.activeParticipant.id + '/dialogs',
      {
        name: "Dialog " + dialogIndex,
        subject: nth(this.onCreateNewParticipantsubjects, subjectIndex),
      }
    ).then(response => {
      dialogs.push(response.data);
      dialogIndex++;
      subjectIndex++;
      axios.post('api/participants/' + this.state.activeParticipant.id + '/dialogs',
        {
          name: "Dialog " + dialogIndex,
          subject: nth(this.subjects, subjectIndex),
        }
      ).then(response => {
        dialogs.push(response.data);
        dialogIndex++;
        subjectIndex++;
        axios.post('api/participants/' + this.state.activeParticipant.id + '/dialogs',
          {
            name: "Dialog " + dialogIndex,
            subject: nth(this.subjects, subjectIndex),
          }
        ).then(response => {
          dialogs.push(response.data);
          dialogIndex++;
          subjectIndex++;
          axios.post('api/participants/' + this.state.activeParticipant.id + '/dialogs',
            {
              name: "Dialog " + dialogIndex,
              subject: nth(this.subjects, subjectIndex),
            }).then(response => {
            dialogs.push(response.data);
            dialogIndex++;
            subjectIndex++;
            this.setState({
              dialogs: dialogs,
              dialogIndex: dialogIndex,
              subjectIndex: subjectIndex,
            });
          });
        });
      });
    });
  }

  createNewDialog = () => {
    let dialogs = this.state.dialogs;
    let dialogIndex = this.state.dialogIndex;
    let subjectIndex = this.state.subjectIndex;
    axios.post('api/participants/' + this.state.activeParticipant.id + '/dialogs',
      {
        name: "Dialog " + dialogIndex,
        subject: nth(this.subjects, subjectIndex),
      }
    ).then(response => {
      dialogs.push(response.data);
      dialogIndex++;
      this.setState({
        dialogs: dialogs,
        dialogIndex: dialogIndex,
        subjectIndex: subjectIndex,
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
      text: 'Participant with name "' + this.state.participantName + '" already exists. Do you want to use the existing participant or create a new participant with different name?',
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
            <button onClick={this.createNewDialog}>Get new dialog</button>
            <Route path="/exp1" render={() => <ChatDialogGrid dialogs={this.state.dialogs} />} />
            <Route path="/exp2" render={() => <ChatDialogList dialogs={this.state.dialogs} />} />
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
