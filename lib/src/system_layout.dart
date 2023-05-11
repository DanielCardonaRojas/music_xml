import 'package:music_xml/src/music_xml_parser_state.dart';
import 'package:music_xml/src/to_music_xml.dart';
import 'package:xml/xml.dart';

import 'system_distance.dart';
import 'system_margins.dart';

class SystemLayout implements ToMusicXml {
  SystemMargins? margins;
  SystemDistance? distance;

  SystemLayout({this.margins, this.distance});

  factory SystemLayout.parse(
      XmlElement xmlSystemLayout, MusicXMLParserState state) {
    final marginsNode = xmlSystemLayout.getElement('system-margins');
    final distanceNode = xmlSystemLayout.getElement('system-distance');

    SystemMargins? margins;
    SystemDistance? distance;

    if (marginsNode != null) margins = SystemMargins.parse(marginsNode, state);
    if (distanceNode != null)
      distance = SystemDistance.parse(distanceNode, state);

    return SystemLayout(margins: margins, distance: distance);
  }

  @override
  XmlNode node() {
    return XmlElement(XmlName('system-layout'), [], [
      if (margins != null) margins!.node(),
      if (distance != null) distance!.node(),
    ]);
  }
}
