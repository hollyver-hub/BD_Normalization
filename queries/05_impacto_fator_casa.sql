SELECT 
    r.Year AS [Ano da Copa],
    w.Country AS [País Sede],
    
    ROUND(AVG(CASE 
        WHEN w.Country = 'Korea/Japan' AND (t_home.Team_Name IN ('Korea Republic', 'Japan') OR t_away.Team_Name IN ('Korea Republic', 'Japan')) THEN m.Attendance
        WHEN w.Country = 'Germany' AND (t_home.Team_Name LIKE '%Germany%' OR t_away.Team_Name LIKE '%Germany%') THEN m.Attendance
        WHEN t_home.Team_Name = w.Country OR t_away.Team_Name = w.Country THEN m.Attendance 
    END), 0) AS [Média Público Sede],
    
    ROUND(AVG(m.Attendance), 0) AS [Média Público Geral],
    
    ROUND(AVG(CASE 
        WHEN w.Country = 'Korea/Japan' AND (t_home.Team_Name IN ('Korea Republic', 'Japan') OR t_away.Team_Name IN ('Korea Republic', 'Japan')) THEN m.Attendance
        WHEN w.Country = 'Germany' AND (t_home.Team_Name LIKE '%Germany%' OR t_away.Team_Name LIKE '%Germany%') THEN m.Attendance
        WHEN t_home.Team_Name = w.Country OR t_away.Team_Name = w.Country THEN m.Attendance 
    END) - AVG(m.Attendance), 0) AS [Diferença (Sede - Geral)]

FROM tb_matches AS m
INNER JOIN tb_rounds AS r 
    ON m.RoundID = r.RoundID
LEFT JOIN tb_world_cups AS w 
    ON r.Year = w.Year
LEFT JOIN tb_teams AS t_home 
    ON m.id_home_team = t_home.id_team
LEFT JOIN tb_teams AS t_away 
    ON m.id_away_team = t_away.id_team

GROUP BY r.Year, w.Country
ORDER BY r.Year DESC;