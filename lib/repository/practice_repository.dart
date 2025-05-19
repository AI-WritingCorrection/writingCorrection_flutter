import '../model/practice.dart';

abstract class PracticeRepository {
  Future<List<Practice>> getAllPractices();
  Future<Practice> getPracticeByIndex(int id);
  int getPracticeNum();
}
