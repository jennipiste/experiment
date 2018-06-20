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
      q4: null,
      q5: null,
    };
  }

  submitQuestionnaire = (event) => {
    event.preventDefault();
    this.setState({isQuestionnaireSubmitted: true});
    this.props.submitQuestionnaire(this.state.q1, this.state.q2, this.state.q3, this.state.q4, this.state.q5);
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

  onQ4changed = (event) => {
    this.setState({q4: event.target.value});
  }

  onQ5changed = (event) => {
    this.setState({q5: event.target.value});
  }

  render () {
    return (
      <Modal text1={this.props.text1} text2={this.props.text2} actions={this.props.actions} isQuestionnaireSubmitted={this.state.isQuestionnaireSubmitted}>
        <form onSubmit={this.submitQuestionnaire} className="Questionnaire">
          <div className="Labels">
            <label>Täysin eri mieltä</label>
            <label>1</label>
            <label>2</label>
            <label>3</label>
            <label>4</label>
            <label>5</label>
            <label>Täysin samaa mieltä</label>
          </div>
          <div className="Questions">
            <div className="Question">
              <div>1. Sain tehtävät tehokkaasti suoritettua tässä osiossa.</div>
              <div className="RadioButtons">
                <input type="radio" value="1" name="q1" onChange={this.onQ1changed} />
                <input type="radio" value="2" name="q1" onChange={this.onQ1changed} />
                <input type="radio" value="3" name="q1" onChange={this.onQ1changed} />
                <input type="radio" value="4" name="q1" onChange={this.onQ1changed} />
                <input type="radio" value="5" name="q1" onChange={this.onQ1changed} />
              </div>
            </div>
            <div className="Question">
              <div>2. Tämän osio oli stressaava.</div>
              <div className="RadioButtons">
                <input type="radio" value="1" name="q2" onChange={this.onQ2changed} />
                <input type="radio" value="2" name="q2" onChange={this.onQ2changed} />
                <input type="radio" value="3" name="q2" onChange={this.onQ2changed} />
                <input type="radio" value="4" name="q2" onChange={this.onQ2changed} />
                <input type="radio" value="5" name="q2" onChange={this.onQ2changed} />
              </div>
            </div>
            <div className="Question">
              <div>3. Tunsin hallitsevani tilanteen hyvin tässä osiossa.</div>
              <div className="RadioButtons">
                <input type="radio" value="1" name="q3" onChange={this.onQ3changed} />
                <input type="radio" value="2" name="q3" onChange={this.onQ3changed} />
                <input type="radio" value="3" name="q3" onChange={this.onQ3changed} />
                <input type="radio" value="4" name="q3" onChange={this.onQ3changed} />
                <input type="radio" value="5" name="q3" onChange={this.onQ3changed} />
              </div>
            </div>
            <div className="Question">
              <div>4. Tunsin itseni turhautuneeksi tässä osiossa.</div>
              <div className="RadioButtons">
                <input type="radio" value="1" name="q4" onChange={this.onQ4changed} />
                <input type="radio" value="2" name="q4" onChange={this.onQ4changed} />
                <input type="radio" value="3" name="q4" onChange={this.onQ4changed} />
                <input type="radio" value="4" name="q4" onChange={this.onQ4changed} />
                <input type="radio" value="5" name="q4" onChange={this.onQ4changed} />
              </div>
            </div>
            <div className="Question">
              <div>5. Tässä osiossa oli helppo muistaa keskusteluiden aiheet/sisällöt.</div>
              <div className="RadioButtons">
                <input type="radio" value="1" name="q5" onChange={this.onQ5changed} />
                <input type="radio" value="2" name="q5" onChange={this.onQ5changed} />
                <input type="radio" value="3" name="q5" onChange={this.onQ5changed} />
                <input type="radio" value="4" name="q5" onChange={this.onQ5changed} />
                <input type="radio" value="5" name="q5" onChange={this.onQ5changed} />
              </div>
            </div>
          </div>
          <input className="QuestionnaireSubmitButton" type="submit" value="Lähetä" disabled={!this.state.q1 || !this.state.q2 || !this.state.q3 || !this.state.q4 || !this.state.q5}/>
        </form>
      </Modal>
    );
  }
}

export default Questionnaire;
