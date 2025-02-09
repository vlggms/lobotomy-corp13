import { Component } from "inferno";

export class TypingScroller extends Component {
  constructor(props) {
    super(props);
    this.containerEl = null;
    this.interval = null;
    this.state = { displayed: "" };
  }

  componentDidMount() {
    const { text, speed = 500, onTypingStart, onTypingEnd } = this.props;
    let i = 0;
    if (text && text.length > 0 && onTypingStart) {
      onTypingStart();
    }

    this.interval = setInterval(() => {
      if (i < text.length) {
        this.setState(prevState => ({
          displayed: prevState.displayed + text[i],
        }));
        i++;
      } else {
        clearInterval(this.interval);
        if (onTypingEnd) {
          onTypingEnd();
        }
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
        ref={el => {
          this.containerEl = el;
        }}
        style={{
          height: "192px",
          overflow: "auto",
          border: "1px solid #ccc",
          width: "100%",
        }}
      >
        {this.state.displayed}
      </div>
    );
  }
}
