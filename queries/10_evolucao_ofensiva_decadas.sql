WITH MetricasDecadas AS (
    SELECT 
        m.MatchID,
        (m.Home_Team_Goals + m.Away_Team_Goals) AS [Total_Gols],
        CASE 
            WHEN r.Year >= 2000 THEN 'Século XXI'
            WHEN r.Year BETWEEN 1990 AND 1999 THEN 'Anos 90'
            WHEN r.Year BETWEEN 1980 AND 1989 THEN 'Anos 80'
            WHEN r.Year BETWEEN 1970 AND 1971 THEN 'Anos 70' 
            WHEN r.Year BETWEEN 1960 AND 1969 THEN 'Anos 60'
            WHEN r.Year BETWEEN 1950 AND 1959 THEN 'Anos 50'
            ELSE 'Anos 30' 
        END AS [Decada]
    FROM tb_matches AS m
    INNER JOIN tb_rounds AS r 
        ON m.RoundID = r.RoundID
)


SELECT 
    [Decada] AS [Década Histórica],
    COUNT(*) AS [Total de Partidas],
    SUM([Total_Gols]) AS [Total de Gols Marcados],
    
    ROUND(
        AVG(CAST([Total_Gols] AS DECIMAL(10,2))), 2
    ) AS [Média de Gols por Jogo],
    
    MAX([Total_Gols]) AS [Recorde de Gols num Jogo]

FROM MetricasDecadas
GROUP BY [Decada]
ORDER BY 
    CASE [Decada]
        WHEN 'Anos 30' THEN 1
        WHEN 'Anos 50' THEN 2
        WHEN 'Anos 60' THEN 3
        WHEN 'Anos 70' THEN 4
        WHEN 'Anos 80' THEN 5
        WHEN 'Anos 90' THEN 6
        WHEN 'Século XXI' THEN 7
        ELSE 8
    END ASC;