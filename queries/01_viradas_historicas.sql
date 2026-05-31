SELECT 
    m.MatchID AS [ID Partida],
    r.Year AS [Ano],
    r.Stage AS [Fase],
    t_home.Team_Name AS [Time Casa],
    m.Half_Time_Home_Goals AS [Gols Casa 1ºT],
    m.Half_Time_Away_Goals AS [Gols Vis. 1ºT],
    t_away.Team_Name AS [Time Visitante],
    m.Home_Team_Goals AS [Placar Final Casa],
    m.Away_Team_Goals AS [Placar Final Visitante],
    CASE 
        WHEN m.Half_Time_Home_Goals < m.Half_Time_Away_Goals THEN t_home.Team_Name
        ELSE t_away.Team_Name
    END AS [Seleção que Virou]
FROM tb_matches AS m
INNER JOIN tb_rounds AS r ON m.RoundID = r.RoundID
INNER JOIN tb_teams AS t_home ON m.id_home_team = t_home.id_team
INNER JOIN tb_teams AS t_away ON m.id_away_team = t_away.id_team
WHERE 
    (m.Half_Time_Home_Goals < m.Half_Time_Away_Goals AND m.Home_Team_Goals > m.Away_Team_Goals)
    OR
    (m.Half_Time_Away_Goals < m.Half_Time_Home_Goals AND m.Away_Team_Goals > m.Home_Team_Goals)
ORDER BY r.Year DESC;