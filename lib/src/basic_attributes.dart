/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/start-stop/
enum StartStop {
  start,
  stop,
}

StartStop parseStartStop(String str) =>
    StartStop.values.firstWhere((e) => e.toString() == 'StartStop.' + str);

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/yes-no/
bool parseYesNo(String str) => str == 'yes' ? true : false;

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/right-left-middle/
enum RightLeftMiddle {
  right,
  left,
  middle,
}

RightLeftMiddle parseRightLeftMiddle(String str) => RightLeftMiddle.values
    .firstWhere((e) => e.toString() == 'RightLeftMiddle.' + str);

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/root-step/
enum Step {
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  undefined,
}

Step parseStep(String str) =>
    Step.values.firstWhere((e) => e.toString() == 'Step.' + str.toLowerCase());

String writeStep(Step step) {
  String result = '';
  switch (step) {
    case Step.a:
      result = 'A';
      break;
    case Step.b:
      result = 'B';
      break;
    case Step.c:
      result = 'C';
      break;
    case Step.d:
      result = 'D';
      break;
    case Step.e:
      result = 'E';
      break;
    case Step.f:
      result = 'F';
      break;
    case Step.g:
      result = 'G';
      break;
    case Step.undefined:
      break;
  }

  return result;
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/degree-type-value/

enum DegreeType {
  add,
  alter,
  subtract,
}

DegreeType parseDegreeType(String str) =>
    DegreeType.values.firstWhere((e) => e.toString() == 'DegreeType.' + str);

String writeDegreeType(DegreeType degreeType) =>
    degreeType.toString().split('.').last;
