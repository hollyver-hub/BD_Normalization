WITH PartidasComoMandante AS (
    SELECT 
        id_home_team AS [id_team],
        COUNT(*) AS [Jogos_Mandante],
        SUM(CASE WHEN Away_Team_Goals = 0 THEN 1 ELSE 0 END) AS [Clean_Sheets_Mandante]
    FROM tb_matches
    GROUP BY id_home_team
),

PartidasComoVisitante AS (
    SELECT 
        id_away_team AS [id_team],
        COUNT(*) AS [Jogos_Visitante],
        SUM(CASE WHEN Home_Team_Goals = 0 THEN 1 ELSE 0 END) AS [Clean_Sheets_Visitante]
    FROM tb_matches
    GROUP BY id_away_team
),

ConsolidadoSelecoes AS (
    SELECT 
        t.Team_Name AS [Selecao],
        COALESCE(m.[Jogos_Mandante], 0) + COALESCE(v.[Jogos_Visitante], 0) AS [Total_Jogos],
        COALESCE(m.[Clean_Sheets_Mandante], 0) + COALESCE(v.[Clean_Sheets_Visitante], 0) AS [Total_Clean_Sheets]
    FROM tb_teams AS t
    LEFT JOIN PartidasComoMandante AS m 
        ON t.id_team = m.id_team
    LEFT JOIN PartidasComoVisitante AS v 
        ON t.id_team = v.id_team
)

SELECT 
    [Selecao] AS [Seleção],
    [Total_Jogos] AS [Total de Jogos Disputados],
    [Total_Clean_Sheets] AS [Total de Clean Sheets],
    ROUND(
        (CAST([Total_Clean_Sheets] AS DECIMAL(10,2)) * 100.0) / [Total_Jogos], 2
    ) AS [Eficiência Defensiva (%)]
FROM ConsolidadoSelecoes
WHERE [Total_Jogos] >= 20
ORDER BY [Eficiência Defensiva (%)] DESC;