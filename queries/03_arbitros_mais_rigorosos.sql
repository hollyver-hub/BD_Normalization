SELECT 
    r.Referee_Name AS [Árbitro],
    r.Country AS [País Origem],
    COUNT(DISTINCT m.MatchID) AS [Total Jogos],
    COUNT(CASE WHEN e.Event_Type IN ('Y', 'R', 'SY') THEN 1 END) AS [Total Cartões],
    ROUND(
        COUNT(CASE WHEN e.Event_Type IN ('Y', 'R', 'SY') THEN 1 END) * 1.0 / COUNT(DISTINCT m.MatchID), 
        2
    ) AS [Média por Jogo]
FROM tb_referees as r
INNER JOIN tb_matches as m 
    ON r.id_referee = m.id_main_referee
INNER JOIN tb_match_players as p 
    ON m.MatchID = p.MatchID
INNER JOIN tb_events as e 
    ON p.id_match_player = e.id_match_player
WHERE e.Event_Type IN ('Y', 'R', 'SY')
GROUP BY r.id_referee, r.Referee_Name, r.Country
HAVING [Total Jogos] >= 5
ORDER BY [Média por Jogo] DESC
LIMIT 5;