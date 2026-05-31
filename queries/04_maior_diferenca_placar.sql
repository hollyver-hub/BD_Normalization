SELECT 
    m.MatchID AS [ID Partida],
    r.Year AS [Ano],
    t_home.Team_Name AS [Time Casa],
    m.Home_Team_Goals AS [Gols Casa],
    m.Away_Team_Goals AS [Gols Visitante],
    t_away.Team_Name AS [Time Visitante],
    ABS(m.Home_Team_Goals - m.Away_Team_Goals) AS [Diferença de Gols]
FROM tb_matches AS m
INNER JOIN tb_rounds AS r 
    ON m.RoundID = r.RoundID
INNER JOIN tb_teams AS t_home 
    ON m.id_home_team = t_home.id_team
INNER JOIN tb_teams AS t_away 
    ON m.id_away_team = t_away.id_team
WHERE ABS(m.Home_Team_Goals - m.Away_Team_Goals) >= 5
ORDER BY [Diferença de Gols] DESC
limit 5;