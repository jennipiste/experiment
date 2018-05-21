import React from 'react';
import ReactDOM from 'react-dom';
import { Document, Page } from 'react-pdf';


class PDFPortal extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      numPages: null,
      pageNumber: 1,
    };
    // STEP 1: create a container <div>
    // this.Document = React.createClass({
    //   displayName: 'Document',
    //   onLoadSuccess: (numPages) => {
    //     this.setState({ numPages });
    //   }

    // });
    // this.containerEl = React.createElement(this.Document, {file: this.subject + ".pdf"});

    this.html = '<Document file="' + this.props.subject + '.pdf" onLoadSuccess={this.onDocumentLoad}><Page pageNumber={this.state.pageNumber} /></Document><p>Page {this.state.pageNumber} of {this.state.numPages}</p>';
    this.containerEl = document.createElement('div', {dangerouslySetInnerHTML: {__html: this.html}});
    console.log(this.containerEl);
    this.PDFWindow = null;
  }

  onDocumentLoad = ({ numPages }) => {
    this.setState({ numPages });
  }

  componentDidMount() {
    // STEP 3: open a new browser window and store a reference to it
    // this.externalWindow = window.open('', '', 'width=600,height=400,left=200,top=200');
    this.PDFWindow = window.open('', '', 'fullscreen=yes, left=' + this.props.left + '');
    this.PDFWindow.addEventListener("keydown", this.handleSearch, false);

    // STEP 4: append the container <div> (that has props.children appended to it) to the body of the new window
    this.PDFWindow.document.body.appendChild(this.containerEl);
  }

  componentWillUnmount() {
    // STEP 5: This will fire when this.state.showWindowPortal in the parent component becomes false
    // So we tidy up by closing the window
    this.externalWindow.close();
  }

  handleSearch = (event) => {
    if (event.which === 70 && (event.ctrlKey || event.metaKey)) {
      event.preventDefault();
    }
  }

  render() {
    // STEP 2: append props.children to the container <div> that isn't mounted anywhere yet
    return ReactDOM.createPortal(this.props.children, this.containerEl);
  }
}

export default PDFPortal;
