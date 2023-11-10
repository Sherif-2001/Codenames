enum TeamColors { blueTeam, redTeam, none }

Map<String, TeamColors> teamColorsToEnum = {
  "red": TeamColors.redTeam,
  "blue": TeamColors.blueTeam,
};

Map<TeamColors, String> teamColorsToString = {
  TeamColors.redTeam: "red",
  TeamColors.blueTeam: "blue",
};
