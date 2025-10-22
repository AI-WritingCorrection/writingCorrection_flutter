/// Request Body (Input)**:
/// - `form (str)`: 생성할 텍스트의 형식 ('단어' 또는 '문장')
/// - `length (int)`: 최대 글자 수
/// - `con (str)`: 텍스트가 만족해야 할 조건 (단계 별로 구체적으로 기술)


List<Map<String, dynamic>> generatedRequestList = [
  {'form': 'WORD', 'length': 1, 'con': '받침이 없는 단어'}, 
  {'form': 'WORD', 'length': 3, 'con': 'ㄹ을 제외한 받침이 있는 단어'},
  {'form': 'WORD', 'length': 5, 'con': 'ㄹ을 포함하고, 받침이 여러 개인 단어'},
];
  