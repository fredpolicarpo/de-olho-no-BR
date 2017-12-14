-- LEGENDAS
CREATE TABLE IF NOT EXISTS consolidacao_eleicao (
  ID                        BIGSERIAL PRIMARY KEY,
  CODIGO_MACRO              INT,
  NOME_MACRO                TEXT,
  UF                        TEXT,
  NOME_UF                   TEXT,
  ANO_ELEICAO               INT,
  NUM_TURNO                 INT,
  DESCRICAO_ELEICAO         TEXT,
  CODIGO_CARGO              INT,
  DESCRICAO_CARGO           TEXT,
  QTD_APTOS                 NUMERIC,
  QTD_COMPARECIMENTO        NUMERIC,
  QTD_ABSTENCOES            NUMERIC,
  QT_VOTOS_NOMINAIS         NUMERIC,
  QT_VOTOS_BRANCOS          NUMERIC,
  QT_VOTOS_NULOS            NUMERIC,
  QT_VOTOS_LEGENDA          NUMERIC,
  QT_VOTOS_ANULADOS_APU_SEP NUMERIC
);