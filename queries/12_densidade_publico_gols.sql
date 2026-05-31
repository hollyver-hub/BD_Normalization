WITH MetricasPartidas AS (
    SELECT 
        MatchID,
        Attendance,
        (Home_Team_Goals + Away_Team_Goals) AS [Total_Gols],
        CASE 
            WHEN Attendance < 20000 THEN 'A: Menos de 20k'
            WHEN Attendance BETWEEN 20000 AND 45000 THEN 'B: 20k a 45k'
            WHEN Attendance BETWEEN 45001 AND 70000 THEN 'C: 45k a 70k'
            ELSE 'D: Mais de 70k'
        END AS [Faixa_Publico]
    FROM tb_matches
    WHERE Attendance IS NOT NULL 
      AND Attendance > 0
)

SELECT 
    [Faixa_Publico] AS [Faixa de Público],
    COUNT(*) AS [Quantidade de Jogos],
    MIN([Total_Gols]) AS [Mínimo de Gols],
    MAX([Total_Gols]) AS [Máximo de Gols],
    ROUND(AVG(CAST([Total_Gols] AS DECIMAL(10,2))), 2) AS [Média de Gols por Jogo]
FROM MetricasPartidas
GROUP BY [Faixa_Publico]
ORDER BY [Faixa_Publico] ASC;