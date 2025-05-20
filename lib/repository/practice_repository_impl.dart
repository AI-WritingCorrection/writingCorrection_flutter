import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/repository/practice_repository.dart';

class DummyPracticeRepository implements PracticeRepository {
  static final _practiceList = <Practice>[
    Practice(
      missionText: '30초 안에 밑의 문장을 정확히 써보자',
      imageAddress: 'assets/character/bearTeacher.png',
      missionType: 'sentence',
      practiceText: '오늘은 토요일이니까 맘껏 놀자',
      time: 30,
      essentialStrokeCounts: [3, 5, 3, 0, 5, 4, 5, 2, 2, 4, 0, 8, 6, 0, 6, 5],
    ),
    Practice(
      missionText: '밑의 단어를 정확히 써보자',
      imageAddress: 'assets/character/rabbitTeacher.png',
      missionType: 'word',
      practiceText: '감자',
      essentialStrokeCounts: [6, 5],
    ),
    Practice(
      missionText: '밑의 문장을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'sentence',
      practiceText: '내일도 잘부탁해요요',
      essentialStrokeCounts: [4, 5, 4, 0, 8, 6, 6, 6, 4, 4],
    ),
    Practice(
      missionText: '밑의 글자을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'letter',
      practiceText: '환',
      essentialStrokeCounts: [8],
    ),
    Practice(
      missionText: '밑의 한글을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'phoneme',
      practiceText: 'ㄱ',
      essentialStrokeCounts: [1],
    ),
    Practice(
      missionText: '60초 안에 밑의 한글을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'phoneme',
      practiceText: 'ㅎ',
      time: 60,
      essentialStrokeCounts: [3],
    ),
    Practice(
      missionText: '60초 안에 밑의 한글을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'phoneme',
      practiceText: 'ㅎ',
      time: 60,
      essentialStrokeCounts: [3],
    ),
  ];
  @override
  Future<List<Practice>> getAllPractices() async {
    return _practiceList;
  }

  @override
  Future<void> addPractice(Practice practice) async {
    // Simulate adding a practice
    print('Practice added: ${practice.missionText}');
    _practiceList.add(practice);
  }

  @override
  Future<void> updatePractice(Practice practice) {
    // TODO: implement updatePractice

    throw UnimplementedError();
  }

  @override
  Future<Practice> getPracticeByIndex(int id) async {
    return _practiceList[id];
  }

  @override
  int getPracticeNum() {
    return _practiceList.length;
  }
}
