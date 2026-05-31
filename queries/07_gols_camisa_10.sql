SELECT 
    mp.Player_Name AS [Jogador],
    t.Team_Name AS [Seleção],
    COUNT(e.id_event) AS [Gols com a Camisa 10]
FROM tb_events AS e
INNER JOIN tb_match_players AS mp 
    ON e.id_match_player = mp.id_match_player
INNER JOIN tb_teams AS t 
    ON mp.id_team = t.id_team
WHERE e.Event_Type = 'G'         
  AND mp.Shirt_Number = 10      
GROUP BY mp.Player_Name, t.Team_Name
ORDER BY [Gols com a Camisa 10] DESC;