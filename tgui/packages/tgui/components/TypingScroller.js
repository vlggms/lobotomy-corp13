import { Component } from 'inferno';

export class TypingScroller extends Component {
  constructor(props) {
    super(props);
    this.containerEl = null;
    this.interval = null;
    this.state = {
      displayed: '',
    };
  }

  componentDidMount() {
    const { text, speed = 100 } = this.props;
    let i = 0;
    this.interval = setInterval(() => {
      if (i < text.length) {
        this.setState(prevState => ({ displayed: prevState.displayed + text[i] }));
        i++;
      } else {
        clearInterval(this.interval);
      }
    }, speed);
  }

  componentDidUpdate() {
    if (this.containerEl && this.containerEl.scrollHeight !== undefined) {
      this.containerEl.scrollTop = this.containerEl.scrollHeight;
    }
  }

  componentWillUnmount() {
    clearInterval(this.interval);
  }

  render() {
    return (
      <div
        ref={el => this.containerEl = el}
        style={{ height: "100px", overflow: "auto", border: "1px solid #ccc" }}
      >
        {this.state.displayed}
      </div>
    );
  }
}
