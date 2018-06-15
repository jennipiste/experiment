import React from 'react';
import map from 'lodash/map';


class Modal extends React.Component {
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

  render() {
    const modalActions = map(this.props.actions, (action, index) => {
      return <button onClick={action.onClick} key={index}>{action.text}</button>;
    });

    return (
      <div className="Backdrop">
        <div className="Modal">
          <div className="ModalContent">
            {!this.state.isQuestionnaireSubmitted ? (
              <div>
                <p>{this.props.text1}</p>
                <form onSubmit={this.submitQuestionnaire}>
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
                      <div>1. Käyttöliittymän käyttö oli yksinkertaista.</div>
                      <div className="RadioButtons">
                        <input type="radio" value="1" name="q1" onChange={this.onQ1changed} />
                        <input type="radio" value="2" name="q1" onChange={this.onQ1changed} />
                        <input type="radio" value="3" name="q1" onChange={this.onQ1changed} />
                        <input type="radio" value="4" name="q1" onChange={this.onQ1changed} />
                        <input type="radio" value="5" name="q1" onChange={this.onQ1changed} />
                      </div>
                    </div>
                    <div className="Question">
                      <div>2. Sain tehtävät tehokkaasti suoritettua tällä käyttöliittymällä.</div>
                      <div className="RadioButtons">
                        <input type="radio" value="1" name="q2" onChange={this.onQ2changed} />
                        <input type="radio" value="2" name="q2" onChange={this.onQ2changed} />
                        <input type="radio" value="3" name="q2" onChange={this.onQ2changed} />
                        <input type="radio" value="4" name="q2" onChange={this.onQ2changed} />
                        <input type="radio" value="5" name="q2" onChange={this.onQ2changed} />
                      </div>
                    </div>
                    <div className="Question">
                      <div>3. Oli helppo oppia käyttämään käyttöliittymää.</div>
                      <div className="RadioButtons">
                        <input type="radio" value="1" name="q3" onChange={this.onQ3changed} />
                        <input type="radio" value="2" name="q3" onChange={this.onQ3changed} />
                        <input type="radio" value="3" name="q3" onChange={this.onQ3changed} />
                        <input type="radio" value="4" name="q3" onChange={this.onQ3changed} />
                        <input type="radio" value="5" name="q3" onChange={this.onQ3changed} />
                      </div>
                    </div>
                    <div className="Question">
                      <div>4. Näytöllä näkyvä informaatio oli järjestelty selkeästi.</div>
                      <div className="RadioButtons">
                        <input type="radio" value="1" name="q4" onChange={this.onQ4changed} />
                        <input type="radio" value="2" name="q4" onChange={this.onQ4changed} />
                        <input type="radio" value="3" name="q4" onChange={this.onQ4changed} />
                        <input type="radio" value="4" name="q4" onChange={this.onQ4changed} />
                        <input type="radio" value="5" name="q4" onChange={this.onQ4changed} />
                      </div>
                    </div>
                    <div className="Question">
                      <div>5. Käyttöliittymän käyttäminen oli miellyttävää.</div>
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
              </div>
            ) : (
              <p>{this.props.text2}</p>
            )}
          </div>
          {this.state.isQuestionnaireSubmitted &&
            <div className="ModalFooter">{modalActions}</div>
          }
        </div>
      </div>
    );
  }
}

export default Modal;