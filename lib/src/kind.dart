// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/kind-value/
import 'package:music_xml/src/camel_case.dart';
import 'snake_case.dart';
import 'package:xml/xml.dart';

enum SimpleKind {
  major,
  minor,
  augmented,
  diminished,
  sus,
  other,
}

enum Kind {
  undefined,
  augmented,
  augmentedSeventh,
  diminished,
  diminishedSeventh,
  dominant,
  dominant11th,
  dominant13th,
  dominantNinth,
  trench,
  german,
  halfDiminished,
  italian,
  major,
  major11th,
  major13th,
  majorMinor,
  majorNinth,
  majorSeventh,
  majorSixth,
  minor,
  minor11th,
  minor13th,
  minorNinth,
  minorSeventh,
  minorSixth,
  neapolitan,
  none,
  other,
  pedal,
  power,
  suspendedFourth,
  suspendedSecond,
  tristan,
}

extension SimpleKindExtension on Kind {
  SimpleKind get simple => this == Kind.major ||
          this == Kind.major ||
          this == Kind.major11th ||
          this == Kind.major13th ||
          this == Kind.majorMinor ||
          this == Kind.majorNinth ||
          this == Kind.majorSeventh ||
          this == Kind.majorSixth ||
          this == Kind.dominant ||
          this == Kind.dominant11th ||
          this == Kind.dominant13th ||
          this == Kind.dominantNinth ||
          this == Kind.neapolitan
      ? SimpleKind.major
      : this == Kind.minor ||
              this == Kind.minor11th ||
              this == Kind.minor13th ||
              this == Kind.minorNinth ||
              this == Kind.minorSeventh ||
              this == Kind.minorSixth
          ? SimpleKind.minor
          : this == Kind.suspendedFourth || this == Kind.suspendedSecond
              ? SimpleKind.sus
              : this == Kind.diminished ||
                      this == Kind.diminishedSeventh ||
                      this == Kind.halfDiminished
                  ? SimpleKind.diminished
                  : this == Kind.augmented || this == Kind.augmentedSeventh
                      ? SimpleKind.augmented
                      : SimpleKind.other;
}

extension KindToMusicXml on Kind {
  XmlNode node() {
    final kindDescription = toString().split('.').last;
    final kindSnakeCase = kindDescription.toSnakeCase('-');
    final kindAbbreviation = chordKindAbbreviations[kindSnakeCase];
    return XmlElement(XmlName('kind'), [
      XmlAttribute(XmlName('text'), '$kindAbbreviation')
    ], [
      XmlText(kindSnakeCase),
    ]);
  }
}

Kind parseKind(String str) => Kind.values
    .firstWhere((e) => e.toString() == 'Kind.' + lowerCamelCase(str));

/// The below dictionary maps chord kinds to an abbreviated string as would
/// appear in a chord symbol in a standard lead sheet. There are often multiple
/// standard abbreviations for the same chord type, e.g. "+" and "aug" both
/// refer to an augmented chord, and "maj7", "M7", and a Delta character all
/// refer to a major-seventh chord; this dictionary attempts to be consistent
/// but the choice of abbreviation is somewhat arbitrary.
///
/// The MusicXML-defined chord kinds are listed here:
/// http://usermanuals.musicxml.com/MusicXML/Content/ST-MusicXML-kind-value.htm
const chordKindAbbreviations = <String, String>{
// These chord kinds are in the MusicXML spec.
  'major': '',
  'minor': 'm',
  'augmented': 'aug',
  'diminished': 'dim',
  'dominant': '7',
  'major-seventh': 'maj7',
  'minor-seventh': 'm7',
  'diminished-seventh': 'dim7',
  'augmented-seventh': 'aug7',
  'half-diminished': 'm7b5',
  'major-minor': 'm(maj7)',
  'major-sixth': '6',
  'minor-sixth': 'm6',
  'dominant-ninth': '9',
  'major-ninth': 'maj9',
  'minor-ninth': 'm9',
  'dominant-11th': '11',
  'major-11th': 'maj11',
  'minor-11th': 'm11',
  'dominant-13th': '13',
  'major-13th': 'maj13',
  'minor-13th': 'm13',
  'suspended-second': 'sus2',
  'suspended-fourth': 'sus',
  'pedal': 'ped',
  'power': '5',
  'none': 'N.C.',

// These are not in the spec, but show up frequently in the wild.
  'dominant-seventh': '7',
  'augmented-ninth': 'aug9',
  'minor-major': 'm(maj7)',

// Some abbreviated kinds also show up frequently in the wild.
  '': '',
  'min': 'm',
  'aug': 'aug',
  'dim': 'dim',
  '7': '7',
  'maj7': 'maj7',
  'min7': 'm7',
  'dim7': 'dim7',
  'm7b5': 'm7b5',
  'minMaj7': 'm(maj7)',
  '6': '6',
  'min6': 'm6',
  'maj69': '6(add9)',
  '9': '9',
  'maj9': 'maj9',
  'min9': 'm9',
  'sus47': 'sus7'
};
