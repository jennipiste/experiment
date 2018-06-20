import React from 'react';
import Modal from './Modal';

class Questionnaire extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      isQuestionnaireSubmitted: false,
      q1: null,
      q2: null,
      q3: null,
    };
  }

  submitQuestionnaire = (event) => {
    event.preventDefault();
    this.setState({isQuestionnaireSubmitted: true});
    this.props.submitQuestionnaire(this.state.q1, this.state.q2, this.state.q3);
  }

  onQ1changed = (event) => {
    this.setState({q1: event.target.value});
  }

  onQ2changed = (event) => {
    this.setState({q2: event.target.value});
  }

  onQ3changed = (event) => {
    this.setState({q3: event.target.value});
  }

  render () {
    return (
      <Modal text1={this.props.text1} text2={this.props.text2} actions={this.props.actions} isQuestionnaireSubmitted={this.state.isQuestionnaireSubmitted}>
        <form onSubmit={this.submitQuestionnaire} className="FinalQuestionnaire">
          <div className="Questions">
            <div className="Question">
              <div>1. Kumpaa käyttöliittymää oli miellyttävämpi käyttää?</div>
              <div className="RadioButtons">
                <label>1</label>
                <input type="radio" value="1" name="q1" onChange={this.onQ1changed} />
                <label>2</label>
                <input type="radio" value="2" name="q1" onChange={this.onQ1changed} />
              </div>
            </div>
            <div className="Question">
              <div>2. Kumpaa käyttöliittymää käyttäessä tunsit itsesi tehokkaammaksi?</div>
              <div className="RadioButtons">
                <label>1</label>
                <input type="radio" value="1" name="q2" onChange={this.onQ2changed} />
                <label>2</label>
                <input type="radio" value="2" name="q2" onChange={this.onQ2changed} />
              </div>
            </div>
            <div className="Question">
              <div>3. Tunsitko eroa kolmen ja neljän samanaikaisen chat-keskustelun välillä?</div>
              <div className="RadioButtons">
                <label>Kyllä</label>
                <input type="radio" value="1" name="q3" onChange={this.onQ3changed} />
                <label>En</label>
                <input type="radio" value="2" name="q3" onChange={this.onQ3changed} />
              </div>
            </div>
          </div>
          <input className="QuestionnaireSubmitButton" type="submit" value="Lähetä" disabled={!this.state.q1 || !this.state.q2 || !this.state.q3}/>
        </form>
      </Modal>
    );
  }
}

export default Questionnaire;
