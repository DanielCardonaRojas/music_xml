import 'dart:math';

import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';
import 'part.dart';
import 'score_part.dart';

/// Internal representation of a MusicXML Document.
/// Represents the top level object which holds the MusicXML document
/// Responsible for loading the .xml or .mxl file using the _get_score method
/// If the file is .mxl, this class uncompresses it
/// After the file is loaded, this class then parses the document into memory
/// using the parse method.
class MusicXmlDocument {
  final String title;

  /// The parsed score document
  final XmlDocument? score;

  /// ScoreParts indexed by id.
  final Map<String, ScorePart> scoreParts;

  final List<Part> parts;

  /// Total time in seconds
  final double totalTimeSecs;

  /// Parse the uncompressed MusicXML document.
  factory MusicXmlDocument.parse(String input) {
    return MusicXmlDocument.fromXml(XmlDocument.parse(input));
  }

  factory MusicXmlDocument.fromXml(XmlDocument score) {
    // Parse part-list
    final scoreParts = <String, ScorePart>{};
    score
        .findAllElements('part-list')
        .map((element) => element.findAllElements('score-part'))
        .where((element) => element.isNotEmpty)
        .map((e) => e.single)
        .map((element) => ScorePart.parse(element))
        .forEach((ScorePart element) => scoreParts[element.id] = element);

    // Parse parts
    final state = MusicXMLParserState();
    var totalTimeSecs = 0.0;
    final parts = score.findAllElements('part').map((element) {
      final part = Part.parse(element, scoreParts, state);
      totalTimeSecs = max(totalTimeSecs, state.timePosition);
      return part;
    }).toList();

    // Parse title
    var title = 'Unknown Piece';
    for (final element in score.findAllElements('movement-title')) {
      title = element.innerText;
      break;
    }

    return MusicXmlDocument(title, score, scoreParts, parts, totalTimeSecs);
  }

  XmlDocument createDocument() {
    if (score != null) return score!;
    final refParts = scoreParts.values.toList();

    return XmlDocument([
      XmlDeclaration([
        XmlAttribute(XmlName('version'), '1.0'),
        XmlAttribute(XmlName('encoding'), 'UTF-8'),
        XmlAttribute(XmlName('standalone'), 'no'),
      ]),
      XmlDoctype('score-partwise'),
      XmlElement(XmlName('score-partwise'), [
        XmlAttribute(XmlName('version'), '4.0')
      ], [
        XmlElement(XmlName('work'), [], [
          XmlElement(XmlName('work-title'), [], [XmlText(title)]),
        ]),
        XmlElement(
            XmlName('part-list'), [], [...refParts.map((e) => e.node())]),
        ...parts.map((part) => part.node()),
      ]),
    ]);
  }

  MusicXmlDocument(
    this.title,
    this.score,
    this.scoreParts,
    this.parts,
    this.totalTimeSecs,
  );
}
