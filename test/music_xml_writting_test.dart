import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/bass.dart';
import 'package:test/test.dart';

void main() {
  test('can write ChordSymbol', () {
    final chordSymbol = ChordSymbol(
      timePosition: 0,
      root: 'A#',
      rootTypeSafe: Root(Step.a, alter: 1),
      kind: 'm7',
      kindTypeSafe: Kind.minorSeventh,
      degrees: [],
      degreesTypeSafe: [Degree(9, 0, DegreeType.add)],
    );

    final result = chordSymbol.node().toXmlString(pretty: true);
    assert(result.contains('harmony'));
    print(result);
  });

  test('can write Root', () {
    final root = Root(Step.a, alter: 1);
    final result = root.node().toXmlString(pretty: true);
    assert(result.contains('root'));
    assert(result.contains('root-step'));
    assert(result.contains('root-alter'));
    print(result);
  });

  test('can write bass', () {
    final bass = Bass(Step.a, alter: 1);
    final result = bass.node().toXmlString(pretty: true);
    assert(result.contains('bass'));
    assert(result.contains('bass-step'));
    assert(result.contains('bass-alter'));
    print(result);
  });

  test('can write Kind', () {
    final kind = Kind.augmentedSeventh;
    final result = kind.node().toXmlString(pretty: true);
    assert(result.contains('kind'));
    assert(result.contains('augmented-seventh'));
    print(result);
  });

  test('can write degree', () {
    final degree = Degree(9, 0, DegreeType.add);
    final result = degree.node().toXmlString(pretty: true);
    print(result);
  });
}
