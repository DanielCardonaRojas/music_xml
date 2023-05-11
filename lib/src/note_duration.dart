import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';
import 'to_music_xml.dart';

/// Standard pulses per quarter.
/// https://en.wikipedia.org/wiki/Pulses_per_quarter_note
const standardPpq = 220;

class NoteDuration implements ToMusicXml {
  /// MusicXML duration
  int duration;

  /// Duration in MIDI ticks
  double midiTicks;

  /// Duration in seconds
  double seconds;

  /// Onset time in seconds
  double timePosition;

  /// Number of augmentation dots
  int dots = 0;

  /// MusicXML duration type
  String type;

  /// Ratio for tuplets (default to 1)
  double tupletRatio;

  bool isGraceNote;

  NoteDuration(
    this.duration,
    this.midiTicks,
    this.seconds,
    this.timePosition,
    this.dots,
    this.type,
    this.tupletRatio,
    this.isGraceNote,
  );

  factory NoteDuration.sixteenth({bool dotted = false}) {
    return NoteDuration(1, 0, 0, 0, dotted ? 1 : 0, 'sixteenth', 1, false);
  }

  factory NoteDuration.eighth({bool dotted = false}) {
    return NoteDuration(1, 0, 0, 0, dotted ? 1 : 0, 'eighth', 1, false);
  }

  factory NoteDuration.quarter({bool dotted = false}) {
    return NoteDuration(1, 0, 0, 0, dotted ? 1 : 0, 'quarter', 1, false);
  }

  factory NoteDuration.half({bool dotted = false}) {
    return NoteDuration(2, 0, 0, 0, dotted ? 1 : 0, 'half', 1, false);
  }

  factory NoteDuration.whole({bool dotted = false}) {
    return NoteDuration(4, 0, 0, 0, dotted ? 1 : 0, 'whole', 1, false);
  }

  /// Parse the duration of a note and compute timings.
  factory NoteDuration.parse(
    bool isInChord,
    bool isGraceNote,
    String? durationText,
    int dots,
    String? type,
    double? tupletRatio,
    MusicXMLParserState state,
  ) {
    durationText ??= '0';
    int duration = int.parse(durationText);
    double? midiTicks;
    double seconds;
    double timePosition;
    bool? _isGraceNote;

    // Due to an error in Sibelius' export, force this note to have the
    // duration of the previous note if it is in a chord
    if (isInChord) {
      duration = state.previousNote?.noteDuration.duration ?? 1;
    }

    midiTicks = duration.toDouble();
    midiTicks = midiTicks * (standardPpq / state.divisions);

    seconds = midiTicks / standardPpq;
    seconds = seconds * state.secondsPerQuarter;

    timePosition = state.timePosition;

    // Not sure how to handle durations of grace notes yet as they
    // steal time from subsequent notes and they do not have a
    // <duration> tag in the MusicXML
    _isGraceNote = isGraceNote;

    if (isInChord) {
      // If this is a chord, set the time position to the time position
      // of the previous note (i.e. all the notes in the chord will have
      // the same time position)
      timePosition =
          state.previousNote?.noteDuration.timePosition ?? timePosition;
    } else {
      // Only increment time positions once in chord
      state.timePosition += seconds;
    }

    return NoteDuration(
      duration,
      midiTicks,
      seconds,
      timePosition,
      dots,
      type ?? 'quarter',
      tupletRatio ?? 1.0,
      _isGraceNote,
    );
  }

  @override
  XmlNode node() {
    return XmlElement(XmlName('duration'), [], [XmlText('$duration')]);
  }
}
