import 'package:music_xml/src/music_xml_parser_state.dart';
import 'package:music_xml/src/to_music_xml.dart';
import 'package:xml/xml.dart';

class SystemMargins implements ToMusicXml {
  double right;
  double left;

  SystemMargins({this.right = 0, this.left = 0});

  factory SystemMargins.parse(
      XmlElement xmlSystemMargins, MusicXMLParserState state) {
    final leftMargin = xmlSystemMargins.getElement('left-margin')!.text;
    final rightMargin = xmlSystemMargins.getElement('right-margin')!.text;

    return SystemMargins(
      right: double.tryParse(rightMargin) ?? 0,
      left: double.tryParse(leftMargin) ?? 0,
    );
  }

  @override
  XmlNode node() {
    return XmlElement(XmlName('system-margins'), [], [
      XmlElement(XmlName('left-margin'), [], [XmlText('$right')]),
      XmlElement(XmlName('right-margin'), [], [XmlText('$left')]),
    ]);
  }
}
