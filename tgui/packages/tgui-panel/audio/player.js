/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createLogger } from "tgui/logging";

const logger = createLogger("AudioPlayer");

export class AudioPlayer {
  constructor() {
    this.element = null;

    this.onPlaySubscribers = [];
    this.onStopSubscribers = [];
  }

  destroy() {
    this.element = null;
  }

  play(url, options = {}) {
    if (this.element) {
      this.stop();
    }

    this.options = options;

    const audio = (this.element = new Audio(url));
    audio.volume = this.volume;
    audio.playbackRate = this.options.pitch || 1;

    logger.log("playing", url, options);

    audio.addEventListener("ended", () => {
      logger.log("ended");
      this.stop();
    });

    audio.addEventListener("error", error => {
      logger.log("playback error", error);
    });

    if (this.options.end) {
      audio.addEventListener("timeupdate", () => {
        if (
          this.options.end
          && this.options.end > 0
          && audio.currentTime >= this.options.end
        ) {
          this.stop();
        }
      });
    }

    audio.play().catch(error => logger.log("playback error", error));

    this.onPlaySubscribers.forEach(subscriber => subscriber());
  }

  stop() {
    if (!this.element) return;

    logger.log("stopping");

    this.element.pause();
    this.element = null;

    this.onStopSubscribers.forEach(subscriber => subscriber());
  }

  setVolume(volume) {
    this.volume = volume;

    if (!this.element) return;

    this.element.volume = volume;
  }

  onPlay(subscriber) {
    this.onPlaySubscribers.push(subscriber);
  }

  onStop(subscriber) {
    this.onStopSubscribers.push(subscriber);
  }
}
