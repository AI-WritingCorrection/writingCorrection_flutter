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
    ),
    Practice(
      missionText: '밑의 단어를 정확히 써보자',
      imageAddress: 'assets/character/rabbitTeacher.png',
      missionType: 'word',
      practiceText: '감자',
    ),
    Practice(
      missionText: '밑의 문장을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'sentence',
      practiceText: '내일도 잘부탁해요요',
    ),
    Practice(
      missionText: '밑의 글자을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'letter',
      practiceText: '환',
    ),
    Practice(
      missionText: '밑의 한글을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'phoneme',
      practiceText: 'ㄱ',
    ),
    Practice(
      missionText: '60초 안에 밑의 한글을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'phoneme',
      practiceText: 'ㅎ',
      time: 60,
    ),
    Practice(
      missionText: '60초 안에 밑의 한글을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'phoneme',
      practiceText: 'ㅎ',
      time: 60,
    ),
  ];
  @override
  Future<List<Practice>> getAllPractices() async {
    return _practiceList;
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
