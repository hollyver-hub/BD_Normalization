WITH EstatisticasJogador AS (
    SELECT 
        mp.Player_Name AS [Jogador],
        t.Team_Name AS [Seleção],
        COUNT(DISTINCT mp.MatchID) AS [Total Partidas],
        COUNT(CASE WHEN e.Event_Type = 'G' THEN 1 END) AS [Total Gols],
        
        ROUND(
            CAST(COUNT(CASE WHEN e.Event_Type = 'G' THEN 1 END) AS REAL) / COUNT(DISTINCT mp.MatchID), 2
        ) AS [Média de Gols]

    FROM tb_match_players AS mp
    INNER JOIN tb_teams AS t 
        ON mp.id_team = t.id_team
    LEFT JOIN tb_events AS e 
        ON mp.id_match_player = e.id_match_player AND e.Event_Type = 'G'
        
    GROUP BY mp.Player_Name, t.Team_Name
)

SELECT 
    a.[Jogador],
    
    a.[Seleção] AS [Seleção A],
    a.[Total Partidas] AS [Partidas Sel. A],
    a.[Total Gols] AS [Gols Sel. A],
    a.[Média de Gols] AS [Média Gols Sel. A],
    
    b.[Seleção] AS [Seleção B],
    b.[Total Partidas] AS [Partidas Sel. B],
    b.[Total Gols] AS [Gols Sel. B],
    b.[Média de Gols] AS [Média Gols Sel. B]

FROM EstatisticasJogador AS a
INNER JOIN EstatisticasJogador AS b 
    ON a.[Jogador] = b.[Jogador] 
   AND a.[Seleção] < b.[Seleção]

ORDER BY (a.[Total Gols] + b.[Total Gols]) DESC;