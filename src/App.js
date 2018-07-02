import React, { Component } from 'react'; // eslint-disable-line no-unused-vars
import axios from 'axios';
import axiosDefaults from 'axios/lib/defaults';
import filter from 'lodash/filter';
import ChatDialogGrid from './ChatDialogGrid';
import ChatDialogList from './ChatDialogList';
import Questionnaire from './Questionnaire';
import FinalQuestionnaire from './FinalQuestionnaire';
import conditions from './conditions';
import subjects from './subjects';
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
      experimentPart: 0,
      experimentPartStartedAt: null,  // When the current part started
      experimentLayout: null,  // Layout 1 or 2
      dialogCount: null,  // 3 or 4 dialogs
      dialogs: [],
      isPartOver: false,
      showPDF: false,
      subject: null,
      usedSubjects: [],
      showFinalQuestionnaire: false,
    };

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

  createParticipant = (event) => {
    event.preventDefault();
    axios.post("api/participants", {number: this.state.participantNumber})
      .then(response => {
        if (response.status === 201) {
          const group = response.data.group;
          this.setState({
            participant: response.data,
            experimentConditions: conditions[group],
          }, this.startNextPart);
        }
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
        experimentPartStartedAt: new Date(),
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
    this.state.dialogs.forEach((dialog, index) => {
      if (dialog) {
        this.markDialogEnded(index);
      }
    });
  }

  closeExperiment = () => {
    this.setState({
      dialogIndex: 1,
      participant: null,
      experimentConditions: [],
      experimentPart: 0,
      experimentLayout: null,
      dialogCount: null,
      dialogs: [],
      isPartOver: false,
      showPDF: false,
      subject: null,
      usedSubjects: [],
      showFinalQuestionnaire: false,
    });
  }

  endChatDialog = (dialog, dialogIndex) => {
    axios.patch("api/dialogs/" + dialog.id, {is_ended: true});
    // If the part is not over, set timeout for new dialog
    if (!this.state.isPartOver) {
      this.timeouts.push(setTimeout(() => this.createNewDialog(dialogIndex), 5000));
    }
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
    let unusedSubjects = filter(subjects, (subject) => {
      return this.state.usedSubjects.indexOf(subject) === -1;
    });
    if (unusedSubjects.length === 0) {
      this.setState({
        usedSubjects: []
      }, () => {
        subject = subjects[Math.floor(Math.random() * subjects.length)];
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
        created_after_experiment_part_started: (new Date() - this.state.experimentPartStartedAt) / 1000,
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

  showFinalQuestionnaire = () => {
    this.setState({showFinalQuestionnaire: true});
  }

  submitFinalQuestionnaire = (q1, q2, q3) => {
    axios.post('api/participants/' + this.state.participant.id + '/final_questionnaires',
      {
        q1: q1,
        q2: q2,
        q3: q3,
      }
    );
  }

  render() {
    const afterFirstPartModalProps = {
      text1: 'Kokeen ensimmäinen osuus on ohi. Täytä seuraavaksi kysely ensimmäisen osuuden käyttöliittymästä. Kysely ei koske PDF:n käyttöä.',
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
      text1: 'Kokeen toinen osuus on ohi. Täytä seuraavaksi kysely toisen osuuden käyttöliittymästä. Kysely ei koske PDF:n käyttöä.',
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
      text1: 'Kokeen kolmas osuus on ohi. Täytä seuraavaksi kysely kolmannen osuuden käyttöliittymästä. Kysely ei koske PDF:n käyttöä.',
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
      text1: 'Viimeinen osuus on nyt ohi. Täytä vielä kysely viimeisen osuuden käyttöliittymästä. Kysely ei koske PDF:n käyttöä.',
      text2: 'Kiitos! Täytä vielä viimeinen, lyhyt kysely kokeesta kokonaisuudessaan.',
      actions: [
        {
          text: "Täytä viimeinen kysely",
          onClick: this.showFinalQuestionnaire,
        }
      ],
      submitQuestionnaire: this.submitQuestionnaire,
    };

    const finalQuestionnaireProps = {
      text1: 'Viimeisessä kyselyssä vertaa kahta kokeilemaasi käyttöliittymää. Käyttöliittymä 1 tarkoittaa sitä, jossa kaikki chat-ikkunat ovat koko ajan näkyvissä ja käyttöliittymä 2 sitä, jossa on näkyvissä vain yksi chat-ikkuna kerrallaan.',
      text2: 'Kiitos osallistumisesta!',
      actions: [
        {
          text: 'OK',
          onClick: this.closeExperiment,
        }
      ],
      submitQuestionnaire: this.submitFinalQuestionnaire,
    };

    return (
      <div className="App">
        {this.state.participant && this.state.experimentLayout ? (
          <div className="AppContent">
            {this.state.experimentLayout === 1 ? (
              <ChatDialogGrid dialogs={this.state.dialogs} markDialogEnded={this.markDialogEnded} onSubjectClick={this.onSubjectClick} participant={this.state.participant} endChatDialog={this.endChatDialog} experimentPartStartedAt={this.state.experimentPartStartedAt} />
            ) : (
              <ChatDialogList dialogs={this.state.dialogs} markDialogEnded={this.markDialogEnded} onSubjectClick={this.onSubjectClick} participant={this.state.participant} endChatDialog={this.endChatDialog} experimentPartStartedAt={this.state.experimentPartStartedAt} />
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
        {this.state.isPartOver && this.state.experimentPart === 1 && <Questionnaire {...afterFirstPartModalProps}/>}
        {this.state.isPartOver && this.state.experimentPart === 2 && <Questionnaire {...afterSecondPartModalProps}/>}
        {this.state.isPartOver && this.state.experimentPart === 3 && <Questionnaire {...afterThirdPartModalProps}/>}
        {this.state.isPartOver && this.state.experimentPart === 4 && <Questionnaire {...afterFourthPartModalProps}/>}
        {this.state.showFinalQuestionnaire && <FinalQuestionnaire {...finalQuestionnaireProps}/>}
      </div>
    );
  }
}

export default App;
