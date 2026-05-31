WITH PlacerFormatado AS (
    SELECT 
        MatchID,
        CONCAT(CAST(Home_Team_Goals AS VARCHAR), ' x ', CAST(Away_Team_Goals AS VARCHAR)) AS [Placar_Original]
        
    FROM tb_matches
)

SELECT 
    [Placar_Original] AS [Placar],
    COUNT(*) AS [Quantidade de Repetições],
    
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2
    ) AS [Percentual (%)]

FROM PlacerFormatado
GROUP BY [Placar_Original]
ORDER BY [Quantidade de Repetições] DESC;