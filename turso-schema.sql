-- ============================================================================
-- MotoCash Pro — Turso / libSQL Database Schema
-- Banco de Dados Edge SQLite para Gestão Financeira de Motoboys
-- ============================================================================

-- 1. Tabela de Perfil do Piloto e Dados da Moto
CREATE TABLE IF NOT EXISTS perfil_moto (
    id TEXT PRIMARY KEY,
    nome_motorista TEXT NOT NULL DEFAULT 'Piloto MotoCash',
    apelido TEXT DEFAULT '',
    whatsapp TEXT DEFAULT '',
    cidade TEXT DEFAULT '',
    foto_url TEXT DEFAULT '',
    modelo_moto TEXT NOT NULL DEFAULT 'Honda CG 160 Fan',
    ano INTEGER DEFAULT 2022,
    placa TEXT DEFAULT '',
    odometro_atual REAL NOT NULL DEFAULT 0.0,
    km_por_litro REAL NOT NULL DEFAULT 40.0,
    preco_combustivel REAL NOT NULL DEFAULT 7.00,
    capacidade_tanque REAL NOT NULL DEFAULT 14.0,
    modo_contagem_padrao TEXT NOT NULL DEFAULT 'gps', -- 'gps' ou 'manual'
    apps_ativos TEXT DEFAULT '["iFood", "99Moto", "Uber Moto"]', -- JSON Array
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela de Peças e Itens de Desgaste por Quilômetro
CREATE TABLE IF NOT EXISTS pecas_desgaste (
    id TEXT PRIMARY KEY,
    nome_peca TEXT NOT NULL,
    valor_peca REAL NOT NULL,
    vida_util_km REAL NOT NULL,
    saude_pct REAL NOT NULL DEFAULT 100.0,
    km_restante REAL NOT NULL,
    ativo INTEGER NOT NULL DEFAULT 1, -- 1=true, 0=false
    personalizada INTEGER NOT NULL DEFAULT 0, -- 1=custom, 0=padrao
    data_ultima_troca TEXT,
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. Histórico de Trocas e Manutenções Realizadas
CREATE TABLE IF NOT EXISTS historico_trocas (
    id TEXT PRIMARY KEY,
    peca_id TEXT,
    nome_peca TEXT NOT NULL,
    data_troca TEXT NOT NULL,
    odometro_na_troca REAL NOT NULL,
    valor_pago_real REAL NOT NULL,
    observacao TEXT DEFAULT '',
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (peca_id) REFERENCES pecas_desgaste(id) ON DELETE SET NULL
);

-- 4. Turnos Diários (Fichas de Trabalho e Fechamentos)
CREATE TABLE IF NOT EXISTS turnos_diarios (
    id TEXT PRIMARY KEY,
    data TEXT NOT NULL, -- Formato YYYY-MM-DD
    hora_inicio TEXT NOT NULL,
    hora_fim TEXT,
    tempo_trabalhado_segundos INTEGER NOT NULL DEFAULT 0,
    km_rodados REAL NOT NULL DEFAULT 0.0,
    modo_km TEXT NOT NULL DEFAULT 'gps', -- 'gps' ou 'manual'
    km_inicial_manual REAL,
    km_final_manual REAL,
    ganho_ifood REAL NOT NULL DEFAULT 0.0,
    ganho_99 REAL NOT NULL DEFAULT 0.0,
    ganho_uber REAL NOT NULL DEFAULT 0.0,
    ganho_particular REAL NOT NULL DEFAULT 0.0,
    gorjetas REAL NOT NULL DEFAULT 0.0,
    faturamento_bruto REAL NOT NULL DEFAULT 0.0,
    custo_combustivel REAL NOT NULL DEFAULT 0.0,
    custo_desgaste REAL NOT NULL DEFAULT 0.0, -- Caixinha da Moto
    custo_extras REAL NOT NULL DEFAULT 0.0,
    lucro_liquido REAL NOT NULL DEFAULT 0.0,
    lucro_por_km REAL NOT NULL DEFAULT 0.0,
    lucro_por_hora REAL NOT NULL DEFAULT 0.0,
    status TEXT NOT NULL DEFAULT 'finalizado', -- 'em_andamento', 'pausado', 'finalizado'
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 5. Lançamentos de Gastos Extras na Rua e Custos Fixos
CREATE TABLE IF NOT EXISTS lancamentos_gastos (
    id TEXT PRIMARY KEY,
    turno_id TEXT,
    data TEXT NOT NULL,
    tipo TEXT NOT NULL DEFAULT 'extra_diario', -- 'extra_diario', 'custo_fixo', 'emergencial'
    categoria TEXT NOT NULL, -- 'Lanche', 'Água', 'Remendo', 'Estacionamento', 'Pedágio', 'Outros'
    descricao TEXT DEFAULT '',
    valor REAL NOT NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (turno_id) REFERENCES turnos_diarios(id) ON DELETE CASCADE
);

-- 6. Metas Mensais e Planejamento Financeiro
CREATE TABLE IF NOT EXISTS metas_mensais (
    id TEXT PRIMARY KEY,
    mes_ano TEXT NOT NULL UNIQUE, -- Formato YYYY-MM
    meta_liquida REAL NOT NULL DEFAULT 3500.0,
    custos_fixos REAL NOT NULL DEFAULT 500.0,
    dias_semana_ativos TEXT NOT NULL DEFAULT '[0,1,2,3,4,5]', -- Seg(0) a Sáb(5)
    meta_diaria_calculada REAL NOT NULL DEFAULT 153.84,
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 7. Objetivos Financeiros (Metas de Compra ou Reserva)
CREATE TABLE IF NOT EXISTS objetivos_financeiros (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    valor_alvo REAL NOT NULL,
    periodo TEXT NOT NULL DEFAULT 'semanal', -- 'semanal' ou 'mensal'
    categoria TEXT NOT NULL DEFAULT 'Manutenção',
    concluido INTEGER NOT NULL DEFAULT 0,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Índices para alta performance de consulta no Turso / SQLite
CREATE INDEX IF NOT EXISTS idx_turnos_data ON turnos_diarios(data);
CREATE INDEX IF NOT EXISTS idx_gastos_turno ON lancamentos_gastos(turno_id);
CREATE INDEX IF NOT EXISTS idx_trocas_data ON historico_trocas(data_troca);
