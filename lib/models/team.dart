class Team {
  int wordsRemaining;
  bool isTeamTurn;
  bool hasWon;

  Team(this.hasWon, this.isTeamTurn, this.wordsRemaining);

  factory Team.fromMap(Map<String, dynamic>? json) => Team(
        json!["HasWon"],
        json["TeamTurn"],
        json["WordsRemaining"],
      );

  Map<String, dynamic> toMap() {
    return {
      "WordsRemaining": wordsRemaining,
      "TeamTurn": isTeamTurn,
      "HasWon": hasWon
    };
  }
}
