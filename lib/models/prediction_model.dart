class PredictionModel {
  final String crowdLevel;
  final double finalScore;
  final double feedbackScore;
  final double timeScore;
  final double weatherScore;
  final double historyScore;

  PredictionModel({
    required this.crowdLevel,
    required this.finalScore,
    required this.feedbackScore,
    required this.timeScore,
    required this.weatherScore,
    required this.historyScore,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    final explanation = json['explanation'] ?? {};
    return PredictionModel(
      crowdLevel: json['crowdLevel'] ?? 'Unknown',
      finalScore: (explanation['finalScore'] ?? 0).toDouble(),
      feedbackScore: (explanation['feedbackScore'] ?? 0).toDouble(),
      timeScore: (explanation['timeScore'] ?? 0).toDouble(),
      weatherScore: (explanation['weatherScore'] ?? 0).toDouble(),
      historyScore: (explanation['historyScore'] ?? 0).toDouble(),
    );
  }
}
