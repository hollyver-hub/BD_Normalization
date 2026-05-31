WITH CartoesPorPartida AS (
    SELECT 
        mp.MatchID AS [MatchID],
        COUNT(CASE WHEN e.Event_Type = 'Y' THEN 1 END) AS [Amarelos_Jogo],
        COUNT(CASE WHEN e.Event_Type = 'R' THEN 1 END) AS [Vermelhos_Jogo],
        COUNT(e.id_event) AS [Total_Cartoes_Jogo]
    FROM tb_events AS e
    INNER JOIN tb_match_players AS mp 
        ON e.id_match_player = mp.id_match_player
    WHERE e.Event_Type IN ('Y', 'R')
    GROUP BY mp.MatchID
),

ConfrontosEstruturados AS (
    SELECT 
        cp.[MatchID],
        cp.[Amarelos_Jogo],
        cp.[Vermelhos_Jogo],
        cp.[Total_Cartoes_Jogo],
        
        CASE 
            WHEN t1.Team_Name < t2.Team_Name THEN t1.Team_Name 
            ELSE t2.Team_Name 
        END AS [Selecao_1],
        
        CASE 
            WHEN t1.Team_Name > t2.Team_Name THEN t1.Team_Name 
            ELSE t2.Team_Name 
        END AS [Selecao_2]

    FROM CartoesPorPartida AS cp
    INNER JOIN tb_matches AS m 
        ON cp.MatchID = m.MatchID
    INNER JOIN tb_teams AS t1 
        ON m.id_home_team = t1.id_team
    INNER JOIN tb_teams AS t2 
        ON m.id_away_team = t2.id_team
)

SELECT 
    [Selecao_1] AS [Seleção A],
    [Selecao_2] AS [Seleção B],
    COUNT(DISTINCT [MatchID]) AS [Total de Jogos],
    SUM([Amarelos_Jogo]) AS [Total Amarelos],
    SUM([Vermelhos_Jogo]) AS [Total Vermelhos],
    SUM([Total_Cartoes_Jogo]) AS [Total Acumulado de Cartões]
FROM ConfrontosEstruturados
GROUP BY [Selecao_1], [Selecao_2]
ORDER BY [Total Acumulado de Cartões] DESC;