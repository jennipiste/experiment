import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import axios from 'axios';
import axiosDefaults from 'axios/lib/defaults';
import filter from 'lodash/filter';
import ChatDialogGrid from './ChatDialogGrid';
import ChatDialogList from './ChatDialogList';
import Modal from './Modal';
import './App.css';

axiosDefaults.baseURL = 'http://localhost:8000';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      participantNumber: "",
      dialogIndex: 1,
      participant: null,
      experimentConditions: [],  // Based on participant's group, the order of 4 different conditions
      experimentPart: 1,
      experimentLayout: null,  // Layout 1 or 2
      dialogCount: null,  // 3 or 4 dialogs
      dialogs: [],
      isPartOver: false,
      showPDF: false,
      subject: null,
      usedSubjects: [],
    };

    this.subjects = [
      'Arkkupakastin',
      'Jalkapallosäännöt',
      'Kamiina',
      'Kiuas',
      'Lämpöpumppu',
      'Nelikopteri',
      'Taekwondon kilpailusäännöt',
      'Televisio',
      'Liesituuletin',
      'Astianpesukone',
      'Cheerleadingin kilpailusäännöt',
      'Jääkaappi',
      'Langattomat Bluetooth-kuulokkeet',
      'Uuni',
      'Miekkailu',
      'Mikroaaltouuni',
      'Pöytätenniksen säännöt',
      'Pyykinpesukone',
      'Tenniksen kilpailumääräykset',
      'Kuivausrumpu',
      'Agility',
      // 'Kouluratsastuksen kilpailusäännöt',
      // 'Suunnistuksen lajisäännöt',
      // 'Puhelin',
      // 'Stereot',
    ];
    this.inputElement = null;
    this.timeouts = [];
  }

  componentDidMount() {
    this.setState({subjects: this.subjects});
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

  createParticipant = (event) => {
    event.preventDefault();
    axios.post("api/participants", {number: this.state.participantNumber})
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
      // End first part after 8 minutes
      this.expTimeout = setTimeout(() => this.changeExperiment(), 480000);
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
        dialogCount: dialogCount,
        dialogs: dialogs,
        isPartOver: false,
        showPDF: false,
      };
    }, () => {
      this.createInitialDialogs();
      // End the part after 8 minutes
      this.expTimeout = setTimeout(() => this.changeExperiment(), 480000);
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
      participant: null,
      experimentConditions: [],
      experimentPart: 1,
      experimentLayout: null,
      dialogCount: null,
      dialogs: [],
      isPartOver: false,
      showPDF: false,
      subject: null,
      usedSubjects: [],
    });
  }

  endChatDialog = (dialog, dialogIndex) => {
    axios.patch("api/dialogs/" + dialog.id, {is_ended: true});
    // If the part is not over, set timeout for new dialog
    if (!this.state.isPartOver) {
      this.timeouts.push(setTimeout(() => this.createNewDialog(dialogIndex), 5000));
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
    this.timeouts.push(setTimeout(() => this.createNewDialog(1), 10000));
    this.timeouts.push(setTimeout(() => this.createNewDialog(2), 20000));
    if (this.state.dialogCount === 4) {
      this.timeouts.push(setTimeout(() => this.createNewDialog(3), 30000));
    }
  }

  createNewDialog = (oldDialogListID) => {
    let dialogs = this.state.dialogs;
    let dialogIndex = this.state.dialogIndex;

    let subject;
    let unusedSubjects = filter(this.subjects, (subject) => {
      return this.state.usedSubjects.indexOf(subject) === -1;
    });
    if (unusedSubjects.length === 0) {
      alert("Aiheet loppu, jatketaan samoilla tässä testissä ja korjataan myöhemmin");
      this.setState({
        usedSubjects: []
      }, () => {
        subject = this.subjects[Math.floor(Math.random() * this.subjects.length)];
        this.setState((prevState) => {
          let usedSubjects = prevState.usedSubjects;
          usedSubjects.push(subject);
          return {
            usedSubjects: usedSubjects,
          };
        });
      });
    } else {
      // Take random subject from array and remove it from state
      subject = unusedSubjects[Math.floor(Math.random() * unusedSubjects.length)];
      this.setState((prevState) => {
        let usedSubjects = prevState.usedSubjects;
        usedSubjects.push(subject);
        return {
          usedSubjects: usedSubjects,
        };
      });
    }
    axios.post('api/participants/' + this.state.participant.id + '/dialogs',
      {
        name: "Dialog " + dialogIndex,
        subject: subject,
        experiment_part: this.state.experimentPart,
        experiment_condition: this.state.experimentConditions[this.state.experimentPart-1],
      }
    ).then(response => {
      // Replace old dialog with the new one
      dialogs.splice(oldDialogListID, 1, response.data);
      dialogIndex++;
      this.setState({
        dialogs: dialogs,
        dialogIndex: dialogIndex,
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

  onParticipantNumberChange = (event) => {
    this.setState({participantNumber: event.target.value});
  }

  submitQuestionnaire = (q1, q2, q3, q4, q5) => {
    axios.post('api/participants/' + this.state.participant.id + '/questionnaires',
      {
        q1: q1,
        q2: q2,
        q3: q3,
        q4: q4,
        q5: q5,
        experiment_part: this.state.experimentPart,
        experiment_condition: this.state.experimentConditions[this.state.experimentPart-1],
      }
    );
  }

  render() {
    const afterFirstPartModalProps = {
      text1: 'Kokeen ensimmäinen osuus on ohi. Täytä seuraavaksi kysely ensimmäisen osuuden käyttöliittymästä.',
      text2: 'Kiitos! Voit nousta hetkeksi seisomaan ja pyöräyttää hartioitasi. Aloita sen jälkeen toinen osuus.',
      actions: [
        {
          text: "Aloita toinen osuus",
          onClick: this.startNextPart,
        }
      ],
      submitQuestionnaire: this.submitQuestionnaire,
    };

    const afterSecondPartModalProps = {
      text1: 'Kokeen toinen osuus on ohi. Täytä seuraavaksi kysely toisen osuuden käyttöliittymästä.',
      text2: 'Kiitos! Voit nousta hetkeksi seisomaan ja pyöräyttää hartioitasi. Aloita sen jälkeen kolmas osuus.',
      actions: [
        {
          text: "Aloita kolmas osuus",
          onClick: this.startNextPart,
        }
      ],
      submitQuestionnaire: this.submitQuestionnaire,
    };

    const afterThirdPartModalProps = {
      text1: 'Kokeen kolmas osuus on ohi. Täytä seuraavaksi kysely kolmannen osuuden käyttöliittymästä.',
      text2: 'Kiitos! Voit nousta hetkeksi seisomaan ja pyöräyttää hartioitasi. Aloita sen jälkeen viimeinen osuus.',
      actions: [
        {
          text: "Aloita viimeinen osuus",
          onClick: this.startNextPart,
        }
      ],
      submitQuestionnaire: this.submitQuestionnaire,
    };

    const afterFourthPartModalProps = {
      text1: 'Viimeinen osuus on nyt ohi. Täytä vielä kysely viimeisen osuuden käyttöliittymästä.',
      text2: 'Kiitos osallistumisesta!',
      actions: [
        {
          text: "OK",
          onClick: this.closeExperiment,
        }
      ],
      submitQuestionnaire: this.submitQuestionnaire,
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
          <form className="ParticipantForm" onSubmit={this.createParticipant}>
            <label>Osallistujanumero:
              <input className="ParticipantInput" type="text" value={this.state.participantNumber} onChange={this.onParticipantNumberChange} />
            </label>
            <input className="StartButton" type="submit" value="Aloita koe" />
          </form>
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
