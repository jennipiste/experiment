import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import { Route } from 'react-router-dom';
import axios from'axios';
import axiosDefaults from 'axios/lib/defaults';
import nth from 'lodash/nth';
import filter from 'lodash/filter';
import ChatDialogGrid from './ChatDialogGrid';
import ChatDialogList from './ChatDialogList';
import Modal from './Modal';
import questions from './questions';
import './App.css';

axiosDefaults.baseURL = 'http://localhost:8000';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      dialogIndex: 1,
      dialogs: [null, null, null, null],
      openDialogsCount: 0,
      subjectIndex: 0,
      participantName: "",
      participantResponse: null,
      activeParticipant: null,
      isModalOpen: false,
    };

    this.subjects = [
      'Astianpesukone',
      'Cheerleadingin kilpailusäännöt',
      'Jääkaappi',
      'Kouluratsastuksen kilpailusäännöt',
      'Langattomat Bluetooth-kuulokkeet',
      'Liesi',
      'Liesituuletin',
      'Miekkailu',
      'Mikroaaltouuni',
      'Pöytätenniksen säännöt',
      'Pyykinpesukone',
      // 'Samsung Galaxy S9',
      // 'Stereot',
      // 'Suunnistuksen lajisäännöt',
      // 'Televisio',
      // 'Tenniksen kilpailumääräykset',
    ];

    this.inputElement = null;
  }

  componentDidMount() {
    window.addEventListener('beforeunload', (event) => this.confirmUnloadEvent(event));
    window.addEventListener('keydown', (event) => this.onKeydownEvent(event));
  }

  confirmUnloadEvent = (event) => {
    event.preventDefault();
  }

  onKeydownEvent = (event) => {
    if ((event.metaKey || event.ctrlKey) && event.keyCode === 70) {
      event.preventDefault();
    }
  }

  initParticipantDialogs = () => {
    axios.get("api/participants/" + this.state.activeParticipant.id + "/dialogs")
      .then(response => {
        const dialogs = response.data;
        if (dialogs.length) {
          this.setState({
            dialogs: dialogs,
            openDialogsCount: filter(dialogs, (dialog) => !dialog.is_ended).length,
          });
        } else {
          this.createInitialDialogs();
        }
      });
  }

  createInitialDialogs = () => {
    // Create 4 dialogs, first dialog right away, others with timeouts
    this.createNewDialog(0);
    setTimeout(() => this.createNewDialog(1), 11579.39);
    setTimeout(() => this.createNewDialog(2), 35353.783);
    setTimeout(() => this.createNewDialog(3), 74118.54);
  }

  sendSystemMessage = (dialogID, message) => {
    return axios.post("api/dialogs/" + dialogID + "/messages", {message: message});
  }

  createNewDialog = (oldDialogListID) => {
    let dialogs = this.state.dialogs;
    let dialogIndex = this.state.dialogIndex;
    let subjectIndex = this.state.subjectIndex;
    let openDialogsCount = this.state.openDialogsCount;
    axios.post('api/participants/' + this.state.activeParticipant.id + '/dialogs',
      {
        name: "Dialog " + dialogIndex,
        subject: nth(this.subjects, subjectIndex),
      }
    ).then(response => {
      // Send first message to the dialog
      let message = questions[response.data.subject][0];
      this.sendSystemMessage(response.data.id, message)
        .then(() => {
          // Replace old dialog with the new one
          dialogs.splice(oldDialogListID, 1, response.data);
          dialogIndex++;
          subjectIndex++;
          openDialogsCount++;
          this.setState({
            dialogs: dialogs,
            dialogIndex: dialogIndex,
            subjectIndex: subjectIndex,
            openDialogsCount: openDialogsCount,
          });
        });
    });
  }

  markDialogEnded = (dialogListID) => {
    let dialogs = this.state.dialogs;
    let dialog = dialogs[dialogListID];
    dialog.is_ended = true;
    dialogs.splice(dialogListID, 1, dialog);
    this.setState({dialogs: dialogs});
  }

  onCloseButtonClick = (dialogListID, dialogID) => {
    if (this.state.activeParticipant === "testi") {
      let dialogs = this.state.dialogs;
      dialogs.splice(dialogListID, 1, null);
      this.setState({dialogs: dialogs});
    } else {
      // Set close time to database
      axios.patch("api/dialogs/" + dialogID, {is_closed: true})
        .then(response => {
          if (response.status === 200) {
            // Replace old dialog with null
            let dialogs = this.state.dialogs;
            dialogs.splice(dialogListID, 1, null);
            this.setState({dialogs: dialogs});
            // Set timeout to create new dialog for that place
            // TODO: replace with real timeout
            setTimeout(() => this.createNewDialog(dialogListID), 10000);
          }
        });
    }
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
          }, this.initParticipantDialogs);
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
    }, this.initParticipantDialogs);
  }

  onCreateNewParticipant = () => {
    this.setState({
      participantResponse: null,
      isModalOpen: false,
    });
    this.inputElement.focus();
  }

  createTestDialogs = () => {
    const testDialogs = [{
      subject: "Televisio",
      participant: "testi",
      is_ended: false,
      is_closed: false,
    }, {
      subject: "Tenniksen kilpailumääräykset",
      participant: "testi",
      is_ended: false,
      is_closed: false,
    }];
    // Create first dialog right away
    let dialogs = this.state.dialogs;
    dialogs.splice(0, 1, testDialogs[0]);
    this.setState({dialogs: dialogs});
    // Set timeout for the second dialog
    setTimeout(() => {
      let dialogs = this.state.dialogs;
      dialogs.splice(1, 1, testDialogs[1]);
      this.setState({dialogs: dialogs});
    }, 10000);
  }

  onTestButtonClick = () => {
    this.setState({activeParticipant: "testi"});
    this.createTestDialogs();
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
        {/* <header className="App-header">
          <h1 className="App-title">Chat multitasking experiment</h1>
          {this.state.activeParticipant && <p className="App-intro">{"Welcome " + this.state.activeParticipant.name + "! "}Let's test how many chats you can handle</p>}
        </header> */}
        {this.state.activeParticipant ? (
          <div className="AppContent">
            <Route path="/exp1" render={() => <ChatDialogGrid dialogs={this.state.dialogs} markDialogEnded={this.markDialogEnded} onCloseButtonClick={this.onCloseButtonClick} />} />
            <Route path="/exp2" render={() => <ChatDialogList dialogs={this.state.dialogs} markDialogEnded={this.markDialogEnded} onCloseButtonClick={this.onCloseButtonClick} />} />
          </div>
        ) : (
          <div className="CreateParticipant">
            <p>Ennen varsinaisen kokeen aloitusta, harjoittele käyttöä suorittamalla pieni testi.</p>
            <button className="TestButton" onClick={this.onTestButtonClick}>Käynnistä testi</button>
            <p>Testin jälkeen voit siirtyä varsinaiseen kokeeseen kirjoittamalla nimesi ja painamalla 'Aloita'.</p>
            <form className="CreateParticipantForm" onSubmit={this.createParticipant}>
              <label>Nimi:
                <input className="ParticipantInput" type="text" value={this.state.participantName} onChange={this.onParticipantNameChange} ref={element => this.inputElement = element} />
              </label>
              <input className="SubmitButton" type="submit" value="Aloita" />
            </form>
          </div>
        )}
        {this.state.isModalOpen && <Modal {...modalProps}/>}
      </div>
    );
  }
}

export default App;
