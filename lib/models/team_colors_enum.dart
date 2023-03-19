enum TeamColors { blueTeam, redTeam, none }

Map<String, TeamColors> teamColorsToEnum = {
  "redTeam": TeamColors.redTeam,
  "blueTeam": TeamColors.blueTeam,
  "none": TeamColors.none
};

Map<TeamColors, String> teamColorsToString = {
  TeamColors.redTeam: "redTeam",
  TeamColors.blueTeam: "blueTeam",
  TeamColors.none: "none"
};
