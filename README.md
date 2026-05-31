#  Projeto: Organização e Análise dos Dados da Copa do Mundo

##  Contexto Inicial

Este projeto foi desenvolvido para a disciplina de Banco de Dados com o objetivo de aplicar engenharia reversa em um dataset denormalizado da Copa do Mundo da FIFA (1930-2014), originalmente em formato CSV. 

O grande desafio do arquivo original era a alta redundância e a mistura de informações na mesma tabela (como nomes de estádios, cidades, árbitros e gols repetidos textualmente em milhares de linhas). Para resolver isso, os dados brutos foram limpos, divididos e estruturados em um banco de dados relacional SQLite, aplicando rigorosamente as Três Formas Normais (1FN, 2FN e 3FN).

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

## Arquitetura do Processo ETL (Pipeline de Dados)

[![Abrir no Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1Bn9XqCrcuF9zfP1jOgl5IKWR4N-ObGkq?usp=sharing)

O pipeline executado dentro do notebook do **Google Colab** seguiu rigorosamente as três etapas clássicas de engenharia de dados:

1.  **Extraction (Extração):** Leitura dos arquivos brutos em formato `.csv` (`WorldCups`, `WorldCupMatches` e `WorldCupPlayers`) utilizando o Pandas.
2.  **Transformation (Transformação):** * Limpeza profunda de dados textuais (como o tratamento de strings complexas com Regex para separar nomes de árbitros e países de origem).
    * Expansão de colunas compostas por múltiplos lances (transformando strings agregadas na linha do jogador em registros individuais para a tabela de eventos).
    * Mapeamento e correspondência lógica de IDs numéricos para servirem de chaves estrangeiras.
3.  **Loading (Carga):** Criação das tabelas relacionais com verificação de chaves (`PRAGMA foreign_keys = ON`) e inserção otimizada dos DataFrames tratados diretamente no arquivo `ATV_FINAL.db` por meio da função `.to_sql()`.

---

## 3. Dossiê das Consultas SQL (15 Perguntas de Negócio)

Para validar a robustez do banco de dados e extrair inteligência sobre o histórico das Copas do Mundo, foram desenvolvidas **15 consultas analíticas**. A tabela abaixo detalha o objetivo de negócio de cada query e a justificativa técnica de sua relevância e inovação:

| Nº | Pergunta de Negócio / Objetivo da Análise | O que torna essa query inovadora/complexa? |
| :---: | :--- | :--- |
| **01** | *Ex: Ranking de árbitros que mais aplicaram cartões vermelhos em finais.* | *Usa agregações (`COUNT`) filtrando lances específicos na `tb_events` com junção na `tb_rounds`.* |
| **02** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **03** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **04** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **05** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **06** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **07** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **08** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **09** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **10** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **11** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **12** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **13** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **14** | *Sua pergunta de negócio aqui...* | *Justificativa técnica aqui...* |
| **15** | *(Query Principal) Sua consulta mais complexa e inovadora do projeto.* | *Usa múltiplas subqueries, CTEs ou Window Functions cruzando eventos, partidas e elencos.* |

>  *Nota: Os scripts `.sql` com os códigos prontos de cada uma das 15 consultas acima encontram-se organizados dentro do arquivo/pasta `/queries` deste repositório.*

---

##  4. Vídeo de Demonstração (Pitch de 1 Minuto)

Confira abaixo o vídeo demonstrativo do projeto, apresentando o banco de dados `ATV_FINAL.db` rodando em tempo real e a explicação detalhada da lógica por trás da nossa consulta SQL mais complexa (Query 15):

[![Assista ao Pitch de Demonstração](https://img.shields.io/badge/Vídeo_Demonstração-Clique_Para_Assistir-red?style=for-the-badge&logo=youtube&logoColor=white)](LINK_DO_SEU_VIDEO_AQUI)

* **Duração:** [Inserir ex: 0min58s] *(Respeitando o limite estrito de 1min10s da disciplina)*
* **O que é mostrado:** Execução da query via terminal/SGBD, comprovação da integridade das chaves estrangeiras e o retorno correto dos dados normalizados.

---

## 5. Certificados DataCamp (Nivelamento)

Como parte dos requisitos de nivelamento em SQL exigidos para a disciplina, abaixo estão os certificados que comprovam a conclusão dos módulos da trilha de dados, armazenados localmente na pasta `DataCamp_Certificates`:

* **Curso 1: Introduction to SQL** (Carga Horária: 2h | Concluído em: 09/04/2026) 
  — [Abrir Certificado](DataCamp_Certificates/Introduction%20to%20SQL.pdf)
* **Curso 2: Intermediate SQL** (Carga Horária: 4h | Concluído em: 14/04/2026) 
  — [Abrir Certificado](DataCamp_Certificates/Intermediate%20SQL.pdf)
* **Curso 3: Joining Data in SQL** (Carga Horária: 4h | Concluído em: 08/05/2026) 
  — [Abrir Certificado](DataCamp_Certificates/Joining%20Data%20in%20SQL.pdf)
* **Curso 4: Introduction to Relational Databases in SQL** (Carga Horária: 4h | Concluído em: 30/05/2026) 
  — [Abrir Certificado](DataCamp_Certificates/Introduction%20to%20Relational%20Databases%20in%20SQL.pdf)


