WITH EdicoesComCartaoVermelho AS (
    SELECT DISTINCT 
        r.Year, 
        t.Team_Name
    FROM tb_events AS e
    JOIN tb_match_players AS mp ON e.id_match_player = mp.id_match_player
    JOIN tb_teams AS t ON mp.id_team = t.id_team
    JOIN tb_matches AS m ON mp.MatchID = m.MatchID
    JOIN tb_rounds AS r ON m.RoundID = r.RoundID
    WHERE e.Event_Type = 'R'
),
TodasParticipacoes AS (
    SELECT DISTINCT r.Year, t.Team_Name
    FROM tb_matches AS m
    JOIN tb_rounds AS r ON m.RoundID = r.RoundID
    JOIN tb_teams AS t ON m.id_home_team = t.id_team
    UNION
    SELECT DISTINCT r.Year, t.Team_Name
    FROM tb_matches AS m
    JOIN tb_rounds AS r ON m.RoundID = r.RoundID
    JOIN tb_teams AS t ON m.id_away_team = t.id_team
),
EdicoesSemVermelho AS (
    SELECT p.Year, p.Team_Name
    FROM TodasParticipacoes p
    LEFT JOIN EdicoesComCartaoVermelho cv ON p.Year = cv.Year AND p.Team_Name = cv.Team_Name
    WHERE cv.Team_Name IS NULL
),
AgrupamentoSequencia AS (
    SELECT 
        Year, 
        Team_Name,
        Year - ROW_NUMBER() OVER (PARTITION BY Team_Name ORDER BY Year) AS Grupo
    FROM EdicoesSemVermelho
),
ContagemPorGrupo AS (
    SELECT 
        Team_Name, 
        COUNT(*) AS Sequencia_Consecutiva
    FROM AgrupamentoSequencia
    GROUP BY Team_Name, Grupo
)
SELECT 
    Team_Name, 
    MAX(Sequencia_Consecutiva) AS Maior_Sequencia_Sem_Vermelho
FROM ContagemPorGrupo
GROUP BY Team_Name
ORDER BY Maior_Sequencia_Sem_Vermelho DESC;