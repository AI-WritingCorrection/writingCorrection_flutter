/// Request Body (Input)**:
/// - `form (str)`: 생성할 텍스트의 형식 ('단어' 또는 '문장')
/// - `length (int)`: 최대 글자 수
/// - `con (str)`: 텍스트가 만족해야 할 조건 (단계 별로 구체적으로 기술)
library;


List<Map<String, dynamic>> generatedRequestList = [
  {'form': 'WORD', 'length': 1, 'con': '기본 자음과 모음으로 이루어진, 받침이 없으며 그 자체로 뜻을 가진 한 글자 단어'}, 
  {'form': 'WORD', 'length': 1, 'con': '쌍자음이나 복합 모음을 포함한, 받침이 없는 한 글자 단어'},
  {'form': 'WORD', 'length': 1, 'con': '기본 자음과 모음, 그리고 받침으로 이루어진 한 글자 단어'},
  {'form': 'WORD', 'length': 1, 'con': '쌍자음, 복합 모음, 겹받침 등을 포함하여 이루어진 한 글자 단어'},
  {'form': 'WORD', 'length': 1, 'con': '쌍자음, 복합 모음, 겹받침 등을 포함하여 이루어진 한 글자 단어'},
  {'form': 'WORD', 'length': 2, 'con': '모든 글자에 받침이 없는 2~3글자 단어'},
  {'form': 'WORD', 'length': 2, 'con': '모든 글자에 받침이 포함된 2~3글자 단어'},
  {'form': 'WORD', 'length': 2, 'con': '받침이 있는 글자와 없는 글자가 섞인 일상적인 단어'},
  {'form': 'WORD', 'length': 3, 'con': '받침이 있는 글자와 없는 글자가 섞인 일상적인 단어'},
  {'form': 'SENTENCE', 'length': 10, 'con': '비교적 짧고 간단한 구조의 문장'},
  {'form': 'SENTENCE', 'length': 20, 'con': '조금 더 길고 구체적인 정보를 포함하는 문장'},
];
  