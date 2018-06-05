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
      dialogIndex: 1,
      subjectIndex: 0,
      participant: null,
      experimentConditions: [],  // Based on participant's group, the order of 4 different conditions
      experimentPart: 1,
      experimentLayout: null,  // Layout 1 or 2
      dialogCount: null,  // 3 or 4 dialogs
      dialogs: [],
      isPartOver: false,
      showPDF: false,
      subject: null,
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

    // TODO:
    this.thirdSubjects = [];
    this.fourthSubjects = [];

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

  createParticipant = () => {
    axios.post("api/participants")
      .then(response => {
        if (response.status === 201) {
          let group = response.data.group;
          let conditions;
          if (group === 1) {
            conditions = ["A", "B", "D", "C"];
          } else if (group === 2) {
            conditions = ["B", "C", "A", "D"];
          } else if (group === 3) {
            conditions = ["C", "D", "B", "A"];
          } else {
            conditions = ["D", "A", "C", "B"];
          }
          this.setState({
            participant: response.data,
            experimentConditions: conditions,
          }, this.startFirstPart);
        }
      });
  }

  startFirstPart = () => {
    this.setState((prevState) => {
      const currentCondition = prevState.experimentConditions[prevState.experimentPart-1];
      const experimentLayout = currentCondition === "A" || currentCondition === "C" ? 1 : 2;
      const dialogCount = currentCondition === "A" || currentCondition === "B" ? 3 : 4;
      const dialogs = new Array(dialogCount).fill(null);
      return {
        experimentLayout: experimentLayout,
        dialogCount: dialogCount,
        dialogs: dialogs,
      };
    }, () => {
      // End first part after 10 minutes
      this.expTimeout = setTimeout(() => this.changeExperiment(), 60000);
      this.createInitialDialogs();
    });
  }

  startNextPart = () => {
    this.setState((prevState) => {
      let part = prevState.experimentPart;
      part++;
      const nextCondition = prevState.experimentConditions[part-1];
      const experimentLayout = nextCondition === "A" || nextCondition === "C" ? 1 : 2;
      const dialogCount = nextCondition === "A" || nextCondition === "B" ? 3 : 4;
      const dialogs = new Array(dialogCount).fill(null);
      return {
        experimentPart: part,
        experimentLayout: experimentLayout,
        subjectIndex: 0,
        dialogCount: dialogCount,
        dialogs: dialogs,
        isPartOver: false,
      };
    }, () => {
      this.createInitialDialogs();
      // End the part after 10 minutes
      this.expTimeout = setTimeout(() => this.changeExperiment(), 20000);
    });
  }

  changeExperiment = () => {
    this.setState({isPartOver: true});
    this.clearTimeouts();
    this.endChatDialogs();
  }

  closeExperiment = () => {
    this.setState({
      dialogIndex: 1,
      subjectIndex: 0,
      participant: null,
      experimentConditions: [],
      experimentPart: 1,
      experimentLayout: null,
      dialogCount: null,
      dialogs: [],
      isPartOver: false,
      showPDF: false,
      subject: null,
    });
  }

  endChatDialog = (dialog, dialogIndex) => {
    axios.patch("api/dialogs/" + dialog.id, {is_ended: true});
    // If the part is not over, set timeout for new dialog
    if (!this.state.isPartOver) {
      this.timeouts.push(setTimeout(() => this.createNewDialog(dialogIndex), 10000));
    }
  }

  endChatDialogs = () => {
    this.state.dialogs.forEach((dialog, index) => {
      if (dialog) {
        this.endChatDialog(dialog, index);
        this.markDialogEnded(index);
      }
    });
  }

  createInitialDialogs = () => {
    // Create 3 or 4 dialogs, first dialog right away, others with timeouts
    this.createNewDialog(0);
    this.timeouts.push(setTimeout(() => this.createNewDialog(1), 11579.39));
    this.timeouts.push(setTimeout(() => this.createNewDialog(2), 35353.783));
    if (this.state.dialogCount === 4) {
      this.timeouts.push(setTimeout(() => this.createNewDialog(3), 74118.54));
    }
  }

  createNewDialog = (oldDialogListID) => {
    // TODO: Divide subjects into 4 parts
    const subjects = this.state.experimentPart === 1 ? this.firstSubjects : this.secondSubjects;
    let dialogs = this.state.dialogs;
    let dialogIndex = this.state.dialogIndex;
    let subjectIndex = this.state.subjectIndex;
    if (subjects[subjectIndex]) {
      axios.post('api/participants/' + this.state.participant.id + '/dialogs',
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

  onSubjectClick = (event, subject) => {
    event.preventDefault();
    this.pdf = require("./manuals/" + subject + ".pdf");
    this.setState({
      showPDF: false,
    }, () => {
      this.setState({
        showPDF: true,
        subject: subject,
      });
    });
  }

  render() {
    const afterFirstPartModalProps = {
      text: 'Kokeen ensimmäinen osuus on ohi. Nouse hetkeksi seisomaan ja pyöräytä hartioitasi. Seuraava osuus alkaa viimeistään viiden minuutin kuluttua, mutta voit aloittaa sen heti kun olet valmis.',
      actions: [
        {
          text: "Aloita toinen osuus",
          onClick: this.startNextPart,
        }
      ]
    };

    const afterSecondPartModalProps = {
      text: 'Kokeen toinen osuus on ohi. Nouse hetkeksi seisomaan ja pyöräytä hartioitasi. Seuraava osuus alkaa viimeistään viiden minuutin kuluttua, mutta voit aloittaa sen heti kun olet valmis.',
      actions: [
        {
          text: "Aloita kolmas osuus",
          onClick: this.startNextPart,
        }
      ]
    };

    const afterThirdPartModalProps = {
      text: 'Kokeen kolmas osuus on ohi. Nouse hetkeksi seisomaan ja pyöräytä hartioitasi. Viimeinen osuus alkaa viimeistään viiden minuutin kuluttua, mutta voit aloittaa sen heti kun olet valmis.',
      actions: [
        {
          text: "Aloita viimeinen osuus",
          onClick: this.startNextPart,
        }
      ]
    };

    const afterFourthPartModalProps = {
      text: 'Viimeinen osuus on nyt ohi. Kiitos! Seuraavaksi täytä vielä paperilla olevat kyselyt.',
      actions: [
        {
          text: "OK",
          onClick: this.closeExperiment,
        }
      ]
    };

    return (
      <div className="App">
        {this.state.participant && this.state.experimentLayout ? (
          <div className="AppContent">
            {this.state.experimentLayout === 1 ? (
              <ChatDialogGrid dialogs={this.state.dialogs} markDialogEnded={this.markDialogEnded} onSubjectClick={this.onSubjectClick} participant={this.state.participant} endChatDialog={this.endChatDialog}/>
            ) : (
              <ChatDialogList dialogs={this.state.dialogs} markDialogEnded={this.markDialogEnded} onSubjectClick={this.onSubjectClick} participant={this.state.participant} endChatDialog={this.endChatDialog}/>
            )}
            {this.state.showPDF &&
              <iframe src={this.pdf} width="50%" height="100%" frameBorder="0" title="PDF"></iframe>
            }
          </div>
        ) : (
          <button className="StartButton" onClick={this.createParticipant}>Aloita koe</button>
        )}
        {this.state.isPartOver && this.state.experimentPart === 1 && <Modal {...afterFirstPartModalProps}/>}
        {this.state.isPartOver && this.state.experimentPart === 2 && <Modal {...afterSecondPartModalProps}/>}
        {this.state.isPartOver && this.state.experimentPart === 3 && <Modal {...afterThirdPartModalProps}/>}
        {this.state.isPartOver && this.state.experimentPart === 4 && <Modal {...afterFourthPartModalProps}/>}
      </div>
    );
  }
}

export default App;
