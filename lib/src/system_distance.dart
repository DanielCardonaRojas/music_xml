import 'package:music_xml/src/music_xml_parser_state.dart';
import 'package:music_xml/src/to_music_xml.dart';
import 'package:xml/xml.dart';

class SystemDistance implements ToMusicXml {
  double tenths;
  SystemDistance({this.tenths = 0});

  factory SystemDistance.parse(
      XmlElement xmlSystemDistance, MusicXMLParserState state) {
    final fraction = double.tryParse(xmlSystemDistance.text) ?? 0;
    return SystemDistance(tenths: fraction);
  }

  @override
  XmlNode node() {
    return XmlElement(XmlName('system-distance'), [], [XmlText('$tenths')]);
  }
}
