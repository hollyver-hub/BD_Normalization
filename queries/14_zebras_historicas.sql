WITH FinaisDisputadas AS (
    SELECT 
        m.MatchID,
        t1.Team_Name AS [Home_Team],
        t2.Team_Name AS [Away_Team],
        m.Home_Team_Goals,
        m.Away_Team_Goals
    FROM tb_matches AS m
    INNER JOIN tb_rounds AS r 
        ON m.RoundID = r.RoundID
    INNER JOIN tb_teams AS t1 
        ON m.id_home_team = t1.id_team
    INNER JOIN tb_teams AS t2 
        ON m.id_away_team = t2.id_team
    WHERE r.Stage LIKE '%Final%'
),

CampeoesMundiaisDinamicos AS (
    SELECT DISTINCT [Campeao] FROM (
        SELECT CASE WHEN Home_Team_Goals > Away_Team_Goals THEN [Home_Team] ELSE [Away_Team] END AS [Campeao]
        FROM FinaisDisputadas
        WHERE Home_Team_Goals <> Away_Team_Goals 
    ) AS t
),

MapeamentoGeralPartidas AS (
    SELECT 
        m.MatchID,
        t1.Team_Name AS [Home_Team],
        t2.Team_Name AS [Away_Team],
        m.Home_Team_Goals,
        m.Away_Team_Goals,
        CASE WHEN c1.Campeao IS NOT NULL THEN 1 ELSE 0 END AS [Home_Is_Campeao],
        CASE WHEN c2.Campeao IS NOT NULL THEN 1 ELSE 0 END AS [Away_Is_Campeao]
    FROM tb_matches AS m
    INNER JOIN tb_teams AS t1 
        ON m.id_home_team = t1.id_team
    INNER JOIN tb_teams AS t2 
        ON m.id_away_team = t2.id_team
    LEFT JOIN CampeoesMundiaisDinamicos AS c1 
        ON t1.Team_Name = c1.Campeao
    LEFT JOIN CampeoesMundiaisDinamicos AS c2 
        ON t2.Team_Name = c2.Campeao
),

ZebrasEfetivas AS (
    SELECT 
        MatchID,
        CASE 
            WHEN [Home_Is_Campeao] = 0 AND [Away_Is_Campeao] = 1 AND [Home_Team_Goals] > [Away_Team_Goals] THEN [Home_Team]
            WHEN [Away_Is_Campeao] = 0 AND [Home_Is_Campeao] = 1 AND [Away_Team_Goals] > [Home_Team_Goals] THEN [Away_Team]
            ELSE NULL 
        END AS [Selecao_Zebra],
        
        CASE 
            WHEN [Home_Is_Campeao] = 0 AND [Away_Is_Campeao] = 1 AND [Home_Team_Goals] > [Away_Team_Goals] THEN [Away_Team]
            ELSE [Home_Team]
        END AS [Campeao_Derrotado]
    FROM MapeamentoGeralPartidas
)

SELECT 
    [Selecao_Zebra] AS [Seleção Zebra],
    COUNT(*) AS [Total de Vitórias contra Campeões],
    GROUP_CONCAT([Campeao_Derrotado]) AS [Campeões Derrotados]
FROM ZebrasEfetivas
WHERE [Selecao_Zebra] IS NOT NULL
GROUP BY [Selecao_Zebra]
ORDER BY [Total de Vitórias contra Campeões] DESC;