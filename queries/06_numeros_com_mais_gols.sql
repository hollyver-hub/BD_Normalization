SELECT 
    CASE 
        WHEN mp.Shirt_Number = 0 THEN 'Número Ignorado'
        ELSE CAST(mp.Shirt_Number AS VARCHAR)
    END AS [Número da Camisa],
    
    COUNT(e.id_event) AS [Total de Gols]

FROM tb_events AS e
INNER JOIN tb_match_players AS mp 
    ON e.id_match_player = mp.id_match_player

WHERE e.Event_Type = 'G'
  AND mp.Shirt_Number IS NOT NULL

GROUP BY mp.Shirt_Number
ORDER BY COUNT(e.id_event) DESC;