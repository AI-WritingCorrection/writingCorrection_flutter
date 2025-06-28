//stepText의 각 글자를 초성/중성/종성으로 분리한 후 각 글자의 초성,중성,종성의 필요 획수를 계산하는 함수
  //int: 글자의 인덱스, List<int>: 초성, 중성, 종성의 획수
  //"박"이라는 텍스트를 입력하면 ㅂ/ㅏ/ㄱ으로 분리후 글자인덱스 0과 필요 획수인 <0,[4,2,1]>을 반환
  Map<int, List<int>> calculateDetailedStrokeCounts(Map<int, List<int>>? detailedStrokeCounts, String text) {
    if (detailedStrokeCounts != null) {
      return detailedStrokeCounts!;
    }

    final List<String> choseongJamo = [
      'ㄱ',
      'ㄲ',
      'ㄴ',
      'ㄷ',
      'ㄸ',
      'ㄹ',
      'ㅁ',
      'ㅂ',
      'ㅃ',
      'ㅅ',
      'ㅆ',
      'ㅇ',
      'ㅈ',
      'ㅉ',
      'ㅊ',
      'ㅋ',
      'ㅌ',
      'ㅍ',
      'ㅎ',
    ];
    final List<String> jungseongJamo = [
      'ㅏ',
      'ㅐ',
      'ㅑ',
      'ㅒ',
      'ㅓ',
      'ㅔ',
      'ㅕ',
      'ㅖ',
      'ㅗ',
      'ㅘ',
      'ㅙ',
      'ㅚ',
      'ㅛ',
      'ㅜ',
      'ㅝ',
      'ㅞ',
      'ㅟ',
      'ㅠ',
      'ㅡ',
      'ㅢ',
      'ㅣ',
    ];

    final Map<int, List<int>> result = {};
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      // 자음만 있는 경우를 위해
      if (choseongJamo.contains(char)) {
        int index = choseongJamo.indexOf(char);
        int count = getChoseongStrokeCount(index);
        result[i] = [count, 0, 0];
        continue;
      }
      // 모음만 있는 경우를 위해
      if (jungseongJamo.contains(char)) {
        int index = jungseongJamo.indexOf(char);
        int count = getJungseongStrokeCount(index);
        result[i] = [0, count, 0];
        continue;
      }
      if (char.codeUnitAt(0) >= 0xAC00 && char.codeUnitAt(0) <= 0xD7A3) {
        int code = char.codeUnitAt(0) - 0xAC00;
        int jongseongIndex = code % 28;
        int jungseongIndex = (code ~/ 28) % 21;
        int choseongIndex = (code ~/ 28) ~/ 21;

        final int choseongCount = getChoseongStrokeCount(choseongIndex);
        final int jungseongCount = getJungseongStrokeCount(jungseongIndex);
        final int jongseongCount =
            jongseongIndex > 0 ? getJongseongStrokeCount(jongseongIndex) : 0;

        result[i] = [choseongCount, jungseongCount, jongseongCount];
      } else {
        // Non-Hangul character: no strokes
        result[i] = [0, 0, 0];
      }
    }
    return result;
  }

  int getChoseongStrokeCount(int index) {
    // 초성의 획수
    const choseongStrokeCounts = [
      1, // ㄱ
      2, // ㄲ
      1, // ㄴ
      2, // ㄷ
      4, // ㄸ
      3, // ㄹ
      3, // ㅁ
      4, // ㅂ
      8, // ㅃ
      2, // ㅅ
      4, // ㅆ
      1, // ㅇ
      2, // ㅈ
      4, // ㅉ
      3, // ㅊ
      2, // ㅋ
      3, // ㅌ
      4, // ㅍ
      3, // ㅎ
    ];
    return choseongStrokeCounts[index];
  }

  int getJungseongStrokeCount(int index) {
    // 중성의 획수
    const jungseongStrokeCounts = [
      2, // ㅏ
      3, // ㅐ
      3, // ㅑ
      4, // ㅒ
      2, // ㅓ
      3, // ㅔ
      3, // ㅕ
      4, // ㅖ
      2, // ㅗ
      4, // ㅘ
      5, // ㅙ
      3, // ㅚ
      3, // ㅛ
      2, // ㅜ
      4, // ㅝ
      5, // ㅞ
      3, // ㅟ
      3, // ㅠ
      1, // ㅡ
      2, // ㅢ
      1, // ㅣ
    ];
    return jungseongStrokeCounts[index];
  }

  int getJongseongStrokeCount(int index) {
    // 종성의 획수
    const jongseongStrokeCounts = [
      0, // (no final)
      1, // ㄱ
      2, // ㄲ
      3, // ㄳ (ㄱ+ㅅ = 1+2)
      1, // ㄴ
      3, // ㄵ (ㄴ+ㅈ = 1+2)
      4, // ㄶ (ㄴ+ㅎ = 1+3)
      2, // ㄷ
      3, // ㄹ
      4, // ㄺ (ㄹ+ㄱ = 3+1)
      6, // ㄻ (ㄹ+ㅁ = 3+3)
      7, // ㄼ (ㄹ+ㅂ = 3+4)
      5, // ㄽ (ㄹ+ㅅ = 3+2)
      6, // ㄾ (ㄹ+ㅌ = 3+3)
      7, // ㄿ (ㄹ+ㅍ = 3+4)
      6, // ㅀ (ㄹ+ㅎ = 3+3)
      3, // ㅁ
      4, // ㅂ
      6, // ㅄ (ㅂ+ㅅ = 4+2)
      2, // ㅅ
      4, // ㅆ
      1, // ㅇ
      2, // ㅈ
      3, // ㅊ
      2, // ㅋ
      3, // ㅌ
      4, // ㅍ
      3, // ㅎ
    ];
    return jongseongStrokeCounts[index];
  }
