import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
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
      dialogs: [null, null, null, null],
      dialogIndex: 1,
      subjectIndex: 0,
      participantName: "",
      participantResponse: null,
      activeParticipant: null,
      experimentPart: 1,
      experimentUI: null,
      isParticipantModalOpen: false,
      isChangeExpModalOpen: false,
      isFinishExpModalOpen: false,
    };

    this.firstSubjects = [
      'Astianpesukone',
      'Cheerleadingin kilpailusäännöt',
      'Jääkaappi',
      'Kouluratsastuksen kilpailusäännöt',
      'Langattomat Bluetooth-kuulokkeet',
      'Liesi',
    ];
    this.secondSubjects = [
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
    this.timeouts = [];
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

  clearTimeouts = () => {
    this.timeouts.forEach(timeout => {
      clearTimeout(timeout);
    });
    this.timeouts = [];
  }

  changeExperiment = () => {
    this.setState({isChangeExpModalOpen: true});
    this.clearTimeouts();
    this.endChatDialogs();
  }

  finishExperiment = () => {
    this.setState({isFinishExpModalOpen: true});
    this.clearTimeouts();
    this.endChatDialogs();
  }

  closeExperiment = () => {
    this.setState({
      dialogs: [null, null, null, null],
      dialogIndex: 1,
      subjectIndex: 0,
      participantName: "",
      participantResponse: null,
      activeParticipant: null,
      experimentPart: 1,
      experimentUI: null,
      isParticipantModalOpen: false,
      isChangeExpModalOpen: false,
      isFinishExpModalOpen: false,
    });
  }

  endChatDialog = (dialog) => {
    axios.patch("api/dialogs/" + dialog.id, {is_ended: true});
  }

  endChatDialogs = () => {
    this.state.dialogs.forEach((dialog, index) => {
      if (dialog) {
        this.endChatDialog(dialog);
        this.markDialogEnded(index);
      }
    });
  }

  startFirstPart = () => {
    this.setState({
      experimentUI: this.state.activeParticipant.first_ui,
    }, () => {
      // End first part after 10 minutes
      this.expTimeout = setTimeout(() => this.changeExperiment(), 600000);
      this.createInitialDialogs();
    });
  }

  startSecondPart = () => {
    this.setState((prevState) => {
      return {
        dialogs: [null, null, null, null],
        isChangeExpModalOpen: false,
        experimentPart: 2,
        experimentUI: prevState.experimentUI === 1 ? 2 : 1,
      };
    }, () => {
      this.createInitialDialogs();
      this.expTimeout = setTimeout(() => this.finishExperiment(), 20000);
    });
  }

  createInitialDialogs = () => {
    // Create 4 dialogs, first dialog right away, others with timeouts
    this.createNewDialog(0);
    this.timeouts.push(setTimeout(() => this.createNewDialog(1), 11579.39));
    this.timeouts.push(setTimeout(() => this.createNewDialog(2), 35353.783));
    this.timeouts.push(setTimeout(() => this.createNewDialog(3), 74118.54));
  }

  createNewDialog = (oldDialogListID) => {
    const subjects = this.state.experimentPart === 1 ? this.firstSubjects : this.secondSubjects;
    let dialogs = this.state.dialogs;
    let dialogIndex = this.state.dialogIndex;
    let subjectIndex = this.state.subjectIndex;
    if (subjects[subjectIndex]) {
      axios.post('api/participants/' + this.state.activeParticipant.id + '/dialogs',
        {
          name: "Dialog " + dialogIndex,
          subject: nth(subjects, subjectIndex),
        }
      ).then(response => {
        // Replace old dialog with the new one
        dialogs.splice(oldDialogListID, 1, response.data);
        dialogIndex++;
        subjectIndex++;
        this.setState({
          dialogs: dialogs,
          dialogIndex: dialogIndex,
          subjectIndex: subjectIndex,
        });
      });
    }
  }

  markDialogEnded = (dialogListID) => {
    let dialogs = this.state.dialogs;
    let dialog = dialogs[dialogListID];
    dialog.is_ended = true;
    dialogs.splice(dialogListID, 1, dialog);
    this.setState({dialogs: dialogs});
  }

  onCloseButtonClick = (dialogListID, dialogID) => {
    if (this.state.activeParticipant.name === "testi") {
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
            this.timeouts.push(setTimeout(() => this.createNewDialog(dialogListID), 10000));
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
          }, this.startFirstPart);
        } else if (response.status === 200) {
          // If participant already exists, show modal
          this.setState({
            isParticipantModalOpen: true,
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
        isParticipantModalOpen: false,
      };
    }, this.startFirstPart);
  }

  onCreateNewParticipant = () => {
    this.setState({
      participantResponse: null,
      isParticipantModalOpen: false,
    });
    this.inputElement.focus();
  }

  createTestDialogs = () => {
    const testDialogs = [{
      subject: "Televisio",
      participant: this.state.activeParticipant,
      is_ended: false,
      is_closed: false,
      created_at: new Date(),
    }, {
      subject: "Tenniksen kilpailumääräykset",
      participant: this.state.activeParticipant,
      is_ended: false,
      is_closed: false,
      created_at: new Date(),
    }];
    // Create first dialog right away
    let dialogs = this.state.dialogs;
    dialogs.splice(0, 1, testDialogs[0]);
    this.setState({dialogs: dialogs});
    // Set timeout for the second dialog
    this.timeouts.push(setTimeout(() => {
      let dialogs = this.state.dialogs;
      dialogs.splice(1, 1, testDialogs[1]);
      this.setState({dialogs: dialogs});
    }, 10000));
  }

  onTestButtonClick = () => {
    const testParticipant = {
      name: "testi",
      group: 1,
      first_ui: 1,
    };
    this.setState({
      activeParticipant: testParticipant,
      experimentUI: 1,
    });
    this.createTestDialogs();
  }

  render() {
    const participantModalProps = {
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

    const changeExpModalProps = {
      text: 'First part of the experiment is now over! Have a 5 minutes break.',
      actions: [
        {
          text: "Start second part",
          onClick: this.startSecondPart,
        }
      ]
    };

    const finishExpModalProps = {
      text: 'Experiment over!!!!',
      actions: [
        {
          text: "OK",
          onClick: this.closeExperiment,
        }
      ]
    };

    return (
      <div className="App">
        {this.state.activeParticipant && this.state.experimentUI ? (
          <div className="AppContent">
            {this.state.experimentUI === 1 ? (
              <ChatDialogGrid dialogs={this.state.dialogs} markDialogEnded={this.markDialogEnded} onCloseButtonClick={this.onCloseButtonClick} participant={this.state.activeParticipant}/>
            ) : (
              <ChatDialogList dialogs={this.state.dialogs} markDialogEnded={this.markDialogEnded} onCloseButtonClick={this.onCloseButtonClick} participant={this.state.activeParticipant}/>
            )}
          </div>
        ) : (
          <div className="CreateParticipant">
            <p>Ennen varsinaisen kokeen aloitusta, harjoittele käyttöä suorittamalla pieni testi.</p>
            <button className="TestButton" onClick={this.onTestButtonClick}>Käynnistä testi</button>
            <p>Testin jälkeen voit siirtyä varsinaiseen kokeeseen kirjoittamalla nimesi ja painamalla 'Aloita'.</p>
            <form className="CreateParticipantForm" onSubmit={this.createParticipant}>
              <label>Nimi:</label>
              <input className="ParticipantInput" type="text" value={this.state.participantName} onChange={this.onParticipantNameChange} ref={element => this.inputElement = element} />
              <input className="SubmitButton" type="submit" value="Aloita" />
            </form>
          </div>
        )}
        {this.state.isParticipantModalOpen && <Modal {...participantModalProps}/>}
        {this.state.isChangeExpModalOpen && <Modal {...changeExpModalProps}/>}
        {this.state.isFinishExpModalOpen && <Modal {...finishExpModalProps}/>}
      </div>
    );
  }
}

export default App;
