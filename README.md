#  Projeto: Organização e Análise dos Dados da Copa do Mundo

##  Contexto Inicial

Este projeto foi desenvolvido para a disciplina de Banco de Dados com o objetivo de aplicar engenharia reversa em um dataset denormalizado da Copa do Mundo da FIFA (1930-2014), originalmente em formato CSV. 

O grande desafio do arquivo original era a alta redundância e a mistura de informações na mesma tabela (como nomes de estádios, cidades, árbitros e gols repetidos textualmente em milhares de linhas). Para resolver isso, os dados brutos foram limpos, divididos e estruturados em um banco de dados relacional SQLite, aplicando rigorosamente as Três Formas Normais (1FN, 2FN e 3FN).

### Dataset
Os dados utilizados neste projeto foram extraídos do [Kaggle](https://www.kaggle.com/datasets/abecklas/fifa-world-cup/data?select=WorldCupPlayers.csv). 
O conjunto de dados contém registros detalhados das Copas do Mundo da FIFA, incluindo:
* Informações de partidas e resultados.
* Registro de eventos (gols, cartões, substituições).
* Dados demográficos de jogadores e times.
---

##  O Antes e o Depois: Como os dados foram organizados

Abaixo está a explicação de como cada estrutura problemática do dataset original foi corrigida e organizada no novo banco de dados:

###  Tabela Comparativa de Estruturas

| O que estava desorganizado (Antes no CSV) | Como foi estruturado (Depois no Banco SQL) | Justificativa Técnica (Normalização) |
| :--- | :--- | :--- |
| **Nomes e Países juntos:** Os árbitros vinham com a sigla do país colada no nome em uma única string (ex: `LOMBARDI Domingo (URU)`). | **Tabelas Separadas:** Criamos a tabela `tb_referees` onde o nome do árbitro e a sigla da sua nacionalidade ficam em colunas atômicas separadas. | **1ª Forma Normal (Atomicidade):** Garante que cada coluna armazene apenas um valor lógico indivisível por registro. |
| **Eventos amontoados:** Todos os gols e eventos de um jogador ficavam aglomerados em um único texto na mesma linha (ex: `G40' G87'`). | **Linha por Gol:** Criamos a tabela fato de eventos `tb_events`. Agora, cada gol do campeonato gera uma linha exclusiva no banco. | **1ª Forma Normal (Eliminação de Grupos Repetidos):** Permite realizar contagens e agregações matemáticas diretamente via SQL (como `COUNT` e `SUM`). |
| **Estádios e Cidades repetidos:** O nome do estádio e a sua cidade se repetiam textualmente em cada nova partida armazenada. | **Dimensão de Estádios:** Criamos a tabela `tb_stadiums`. A tabela de partidas agora apenas referencia o código `id_stadium`. | **2ª Forma Normal (Dependência Parcial):** Os dados do estádio e da cidade dependem do local em si, e não da partida diretamente. |
| **Identificação dos Confrontos:** Os jogos registravam apenas os nomes textuais dos times (ex: "Brazil"), propício a erros de digitação. | **Chaves Estrangeiras Duplas:** Criamos a tabela `tb_teams` e inserimos duas chaves estrangeiras distintas na tabela de jogos: `id_home_team` e `id_away_team`. | **2ª e 3ª Forma Normal (Integridade Referencial):** Centraliza o cadastro das seleções, padroniza a escrita e economiza espaço de armazenamento. |
| **Fases e Anos duplicados:** O nome da fase (ex: "Final") e o ano da copa se repetiam em todas as linhas de partidas daquela etapa. | **Tabela de Rodadas:** Criamos a tabela `tb_rounds`. A partida agora aponta apenas para o `RoundID`, que por sua vez se conecta ao ano da Copa. | **3ª Forma Normal (Dependência Transitiva):** Uma partida pertence a uma rodada, e a rodada pertence a um ano. Isolar essa relação elimina a redundância na tabela fato. |

---

##  Visualização do Modelo
Abaixo podes comparar a evolução da modelagem do projeto, desde os dados brutos até ao banco de dados final otimizado:

### Cenário Original (Denormalizado - Kaggle)
![Estrutura Original - Denormalizada](design/FIFA_Brute.png)

### Esquema Relacional Otimizado (3ª Forma Normal)
![Esquema Relacional Otimizado - 3FN](design/FIFA_Normalizado.png)

| Imagem | Descrição |
| :---: | :--- |
| <img src="design/Ponto_Primary_Key.png" width="200"> | **Chaves Primárias (PKs):** As chaves primárias garantem a integridade e unicidade de cada registro no banco de dados. Elas foram estrategicamente definidas para identificar inequivocamente cada entidade (como `MatchID`, `id_team`), evitando duplicidade de dados e permitindo uma indexação eficiente para consultas rápidas. |
| <img src="design/Ponto_Foreign_Key.png" width="200"> | **Chaves Estrangeiras (FKs):** As chaves estrangeiras estabelecem o relacionamento relacional entre as tabelas. Elas permitem que dados de entidades distintas se comuniquem, como a associação de um jogador ao seu time ou de uma partida a um estádio específico, mantendo a integridade referencial em todo o ecossistema das Copas. |
## Tecnologias e Ferramentas Utilizadas

Todo o processo de engenharia de dados — desde a carga dos arquivos brutos até a modelagem, limpeza, formatação e população do banco de dados relacional — foi desenvolvido em ambiente em nuvem utilizando:

* **Ambiente de Desenvolvimento:** [![Google Colab](https://img.shields.io/badge/Google%20Colab-F9AB00?style=for-the-badge&logo=googlecolab&logoColor=white)](https://colab.research.google.com/)
    *Utilizado para a execução dos scripts Python, análise exploratória dos dados brutos e validação contínua em blocos de código.*
* **Linguagem de Programação:** [![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
    *Linguagem base de todo o ecossistema, garantindo automação e manipulação eficiente dos tipos de dados.*
* **Manipulação e Tratamento de Dados:** [![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org/)
    *Biblioteca core usada para a limpeza de strings via Expressões Regulares (Regex), tratamento de valores ausentes (NaN/Null), junções (`merge`), filtros de integridade e conversão de tipos.*
* **Banco de Dados Relacional:** [![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)](https://www.sqlite.org/)
    *Engine de banco de dados utilizada para armazenar e normalizar o esquema físico final (`.db`), garantindo consistência por meio de chaves primárias, estrangeiras e restrições de unicidade (`UNIQUE`).*

---

## Arquitetura do Processo ETL 

[![Abrir no Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1Bn9XqCrcuF9zfP1jOgl5IKWR4N-ObGkq?usp=sharing)

O pipeline executado dentro do notebook do **Google Colab** seguiu rigorosamente as três etapas clássicas de engenharia de dados:

1.  **Extraction (Extração):** Leitura dos arquivos brutos em formato `.csv` (`WorldCups`, `WorldCupMatches` e `WorldCupPlayers`) utilizando o Pandas.
2.  **Transformation (Transformação):** * Limpeza profunda de dados textuais (como o tratamento de strings complexas com Regex para separar nomes de árbitros e países de origem).
    * Expansão de colunas compostas por múltiplos lances (transformando strings agregadas na linha do jogador em registros individuais para a tabela de eventos).
    * Mapeamento e correspondência lógica de IDs numéricos para servirem de chaves estrangeiras.
3.  **Loading (Carga):** Criação das tabelas relacionais com verificação de chaves (`PRAGMA foreign_keys = ON`) e inserção otimizada dos DataFrames tratados diretamente no arquivo `ATV_FINAL.db` por meio da função `.to_sql()`.
4.  **Consultas das queries**: Etapa responsável por organizar todas as queries abaixo citadas de forma simples e fácil de serem consultadas e atestadas.

---

## Dossiê das Consultas SQL 

Para validar a robustez do banco de dados e extrair inteligência sobre o histórico das Copas do Mundo, foram desenvolvidas **15 consultas analíticas**. A tabela abaixo detalha o objetivo de negócio de cada query e a justificativa técnica de sua relevância e inovação:

| Nº | Pergunta de Negócio / Objetivo da Análise | O que torna essa query inovadora/complexa? |
| :---: | :--- | :--- |
| **01** | Quais seleções saíram perdendo no primeiro tempo (com base nos gols parciais de mandante/visitante) mas conseguiram virar o jogo e vencer a partida no tempo regulamentar? | Aplica lógica condicional bidirecional com `CASE WHEN` e operadores booleanos cruzados para isolar cenários alternados de viradas (*comebacks*) entre mandantes e visitantes. |
| **02** | Quais partidas finais de Copa do Mundo tiveram os maiores públicos da história, qual foi o vencedor e onde o jogo ocorreu? | Realiza um `INNER JOIN` quádruplo interligando partidas, estádios, rounds e o histórico de campeões para criar um relatório de infraestrutura e apelo comercial. |
| **03** | Qual árbitro é considerado o mais "pavio curto" da história das Copas do Mundo com base na maior média de cartões por jogo? | Utiliza agregação condicional (`COUNT(CASE WHEN...)`) em tabelas de eventos de jogadores, aplicando um filtro de consistência estatística no escopo agregado por meio da cláusula `HAVING`. |
| **04** | Quais foram as maiores goleadas registradas na história das Copas do Mundo com base na diferença absoluta de gols? | Emprega a função matemática `ABS()` para calcular de forma unificada o diferencial de gols, independentemente de a dominância do placar ter sido do time mandante ou visitante. |
| **05** | Qual é o impacto do "Fator Casa" no apelo do público, comparando a média de espectadores dos jogos do país sede contra a média geral da mesma edição? | Trata inconsistências textuais históricas de nomes de países (como fusões e sedes duplas) utilizando `CASE WHEN` combinado com operadores `LIKE` e cálculo relacional de proporção entre médias. |
| **06** | Qual é o número de camisa mais artilheiro da história das Copas do Mundo e qual o total acumulado de gols por numeração? | Executa agrupamento baseado em atributos dinâmicos dos atletas, realizando a conversão de tipos com `CAST AS VARCHAR` para tratar e padronizar registros nulos ou ignorados. |
| **07** | Quem são os maiores artilheiros da história que usaram estritamente a mística camisa 10 em Copas do Mundo? | Cruza os registros detalhados da tabela de fatos de eventos com metadados de escalação, filtrando o tipo de evento 'G' estringindo o escopo ao identificador fixo da numeração. |
| **08** | Quais jogadores raros conseguiram a façanha de defender e disputar partidas por duas seleções diferentes na história do torneio? | Constrói um *Self-Join* (autojunção) em cima de uma Common Table Expression (CTE) utilizando uma restrição de desigualdade (`a.Seleção < b.Seleção`) para eliminar linhas espelhadas e duplicidades. |
| **09** | Quais seleções possuem o maior histórico de edições consecutivas sem sofrer nenhum cartão vermelho (*Fair Play*)? | Utiliza a lógica de "Gaps and Islands" (`Year - ROW_NUMBER()`) para identificar sequências temporais ininterruptas e aplica `MAX()` para encontrar a maior série histórica de cada time. |
| **10** | Se agruparamos as Copas do Mundo por décadas históricas, qual foi o período mais ofensivo e como a produtividade de gols se comportou com a evolução tática do esporte? | Constrói uma análise de série temporal (*trend analysis*) complexa, convertendo anos em blocos cronológicos via CTE e calculando médias móveis agregadas com ordenação personalizada para provar teses de evolução tática. |
| **11** | Qual é a distribuição de frequência dos placares originais das partidas e qual o peso percentual de cada resultado sobre o todo? | Combina a concatenação de dados convertidos para texto com a Window Function `SUM(COUNT(*)) OVER ()` para calcular o percentual de representatividade diretamente na projeção, evitando subqueries. |
| **12** | Qual a média de gols por partida em diferentes faixas de público (densidade de torcedores nos estádios)? | Segmenta variáveis contínuas de público em faixas categóricas, demonstrando habilidade em tratar *outliers* de público e extrair correlações estatísticas que revelam padrões de comportamento tático em diferentes escalas de arena. |
| **13** | Quais seleções possuem a maior eficiência defensiva da história das Copas do Mundo medida pelo percentual de jogos sem sofrer gols (*Clean Sheets*)? | Desenvolve CTEs paralelas para isolar o histórico defensivo ponderado de mandante e visitante, unificando os dados através de `COALESCE` e aplicando um filtro de corte de amostragem relevante. |
| **14** | Quais seleções consideradas "zebras" (que nunca venceram uma Copa) derrotaram campeões mundiais em tempo de execução? | Substitui subconsultas complexas por um mapeamento prévio de `LEFT JOIN` com sinalizadores binários (`0` ou `1`), consolidando os registros de forma limpa por meio da função de agregação de texto `GROUP_CONCAT`. |
| **15** | **Quais confrontos diretos e rivalidades históricas acumularam o maior volume total de cartões amarelos e vermelhos?** | **Implementa uma normalização de paridade de confrontos via `CASE WHEN` alfabético, garantindo que o embate entre Seleção A e B seja consolidado como uma entidade única, independentemente da condição de mando de campo.** |

> *Nota: Os scripts `.sql` com os códigos prontos de cada uma das 15 consultas acima encontram-se organizados dentro do arquivo/pasta `/queries` deste repositório.*

---

## Vídeo de Demonstração

Confira abaixo o vídeo demonstrativo do projeto, apresentando o banco de dados `ATV_FINAL.db` rodando em tempo real e a explicação detalhada da lógica por trás da nossa consulta SQL mais complexa (Query 15):

https://github.com/user-attachments/assets/bacfb092-221e-4568-bb4e-c8a5b951e788

---

## Certificados DataCamp

Como parte dos requisitos de nivelamento em SQL exigidos para a disciplina, abaixo estão os certificados que comprovam a conclusão dos módulos da trilha de dados, armazenados localmente na pasta `DataCamp_Certificates`:

* **Curso 1: Introduction to SQL** (Carga Horária: 2h | Concluído em: 09/04/2026) 
  — [Abrir Certificado](DataCamp_Certificates/Introduction%20to%20SQL.pdf)
* **Curso 2: Intermediate SQL** (Carga Horária: 4h | Concluído em: 14/04/2026) 
  — [Abrir Certificado](DataCamp_Certificates/Intermediate%20SQL.pdf)
* **Curso 3: Joining Data in SQL** (Carga Horária: 4h | Concluído em: 08/05/2026) 
  — [Abrir Certificado](DataCamp_Certificates/Joining%20Data%20in%20SQL.pdf)
* **Curso 4: Introduction to Relational Databases in SQL** (Carga Horária: 4h | Concluído em: 30/05/2026) 
  — [Abrir Certificado](DataCamp_Certificates/Introduction%20to%20Relational%20Databases%20in%20SQL.pdf)


