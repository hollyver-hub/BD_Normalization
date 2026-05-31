WITH EventosFiltrados AS (
    SELECT 
        id_match_player, 
        Event_Type, 
        Minute
    FROM tb_events
    WHERE Event_Type IN ('Y', 'R', 'RSY')
    GROUP BY id_match_player, Event_Type, Minute
),

CartoesPorPartida AS (
    SELECT 
        mp.MatchID AS [MatchID],
        SUM(CASE WHEN ef.Event_Type = 'Y' THEN 1 ELSE 0 END) AS [Amarelos_Jogo],
        SUM(CASE WHEN ef.Event_Type = 'R' THEN 1 ELSE 0 END) AS [Vermelhos_Diretos],
        SUM(CASE WHEN ef.Event_Type = 'RSY' THEN 1 ELSE 0 END) AS [Vermelhos_Por_Amarelo],
        COUNT(*) AS [Total_Cartoes_Jogo]
    FROM EventosFiltrados AS ef
    INNER JOIN tb_match_players AS mp ON ef.id_match_player = mp.id_match_player
    GROUP BY mp.MatchID
),

ConfrontosEstruturados AS (
    SELECT 
        cp.[MatchID],
        cp.[Amarelos_Jogo],
        cp.[Vermelhos_Diretos],
        cp.[Vermelhos_Por_Amarelo],
        cp.[Total_Cartoes_Jogo],
        r.Year AS [Ano_Copa],
        CASE WHEN t1.Team_Name < t2.Team_Name THEN t1.Team_Name ELSE t2.Team_Name END AS [Selecao_1],
        CASE WHEN t1.Team_Name > t2.Team_Name THEN t1.Team_Name ELSE t2.Team_Name END AS [Selecao_2]
    FROM CartoesPorPartida AS cp
    INNER JOIN tb_matches AS m ON cp.MatchID = m.MatchID
    INNER JOIN tb_rounds AS r ON m.RoundID = r.RoundID
    INNER JOIN tb_teams AS t1 ON m.id_home_team = t1.id_team
    INNER JOIN tb_teams AS t2 ON m.id_away_team = t2.id_team
)

SELECT 
    [Selecao_1] AS [Seleção A],
    [Selecao_2] AS [Seleção B],
    COUNT(DISTINCT [MatchID]) AS [Total de Jogos],
    GROUP_CONCAT(DISTINCT [Ano_Copa] ORDER BY [Ano_Copa] ASC) AS [Anos_Das_Copas], 
    SUM([Amarelos_Jogo]) AS [Amarelos],
    SUM([Vermelhos_Diretos]) AS [Vermelhos Diretos],
    SUM([Vermelhos_Por_Amarelo]) AS [Vermelho por Dois Amarelos],
    SUM([Total_Cartoes_Jogo]) AS [Total Acumulado de Cartões]
FROM ConfrontosEstruturados
GROUP BY [Selecao_1], [Selecao_2]
ORDER BY [Total Acumulado de Cartões] DESC;
