import 'package:music_xml/src/basic_attributes.dart';
import 'package:music_xml/src/system_distance.dart';
import 'package:music_xml/src/system_layout.dart';
import 'package:music_xml/src/to_music_xml.dart';
import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML <print> element.
class Print implements ToMusicXml {
  final int? blankPage;
  bool newPage;
  bool newSystem;
  int? pageNumber;
  double? staffSpacing;
  SystemLayout? systemLayout;

  /// Parse the MusicXML <print> element.
  factory Print.parse(XmlElement xmlPrint, MusicXMLParserState state) {
    int? blankPage;
    bool? newPage;
    bool? newSystem;
    int? pageNumber;
    double? staffSpacing;

    for (final attribute in xmlPrint.attributes) {
      final name = attribute.name.local;
      final value = attribute.value;
      switch (name) {
        case 'blank-page':
          blankPage = int.parse(value);
          break;
        case 'new-page':
          newPage = parseYesNo(value);
          break;
        case 'new-system':
          newSystem = parseYesNo(value);
          break;
        case 'page-number':
          pageNumber = int.parse(value);
          break;
        case 'staff-spacing':
          staffSpacing = double.parse(value);
          break;
        default:
        // Add implementation above
      }
    }

    final systemLayoutNode = xmlPrint.getElement('system-layout');
    SystemLayout? systemLayout;

    if (systemLayoutNode != null)
      systemLayout = SystemLayout.parse(systemLayoutNode, state);

    return Print(
      blankPage,
      newPage ?? false,
      newSystem ?? false,
      pageNumber,
      staffSpacing,
    )..systemLayout = systemLayout;
  }

  Print(
    this.blankPage,
    this.newPage,
    this.newSystem,
    this.pageNumber,
    this.staffSpacing,
  );

  @override
  XmlNode node() {
    return XmlElement(XmlName('print'), [
      if (newSystem)
        XmlAttribute(XmlName('new-system'), newSystem ? 'yes' : 'no'),
      if (newPage) XmlAttribute(XmlName('new-page'), newPage ? 'yes' : 'no'),
      if (pageNumber != null)
        XmlAttribute(XmlName('page-number'), '${pageNumber!}'),
      if (staffSpacing != null)
        XmlAttribute(XmlName('staffSpacing'), '${staffSpacing!}'),
    ], [
      if (systemLayout != null) systemLayout!.node(),
    ]);
  }
}
