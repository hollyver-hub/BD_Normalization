SELECT 
    m.MatchID AS [ID Partida],
    r.Year AS [Ano da Copa],
    w.Winner AS [Campeão do Ano],
    t_home.Team_Name AS [Time Casa],
    t_away.Team_Name AS [Time Visitante],
    s.Stadium AS [Estádio],
    s.City AS [Cidade],
    m.Attendance AS [Público na Final]
FROM tb_matches AS m
INNER JOIN tb_rounds AS r ON m.RoundID = r.RoundID
INNER JOIN tb_world_cups AS w ON r.Year = w.Year
INNER JOIN tb_stadiums AS s ON m.id_stadium = s.id_stadium
INNER JOIN tb_teams AS t_home ON m.id_home_team = t_home.id_team
INNER JOIN tb_teams AS t_away ON m.id_away_team = t_away.id_team
WHERE r.Stage = 'Final'
ORDER BY m.Attendance DESC
LIMIT 5;