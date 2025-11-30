class EvaluationResult {
  final double score;
  final String? summary;
  final Map<int, String> recognizedTexts;

  EvaluationResult({
    required this.score,
    required this.summary,
    required this.recognizedTexts,
  });

  factory EvaluationResult.fromJson(Map<String, dynamic> json) {
    return EvaluationResult(
      score: (json['score'] as num).toDouble(),
      summary: json['summary'] as String?,
      recognizedTexts: (json['recognized_texts'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value as String)),
    );
  }
}
