# Documentação Técnica e Funcional — Aplicativo Financeiro para Motoboys ("Canivete Suíço")

## 1. Visão Geral do Projeto

### 1.1 Conceito
Aplicativo multiplataforma (Celular Android/iOS e Computador) voltado para entregadores e motoboys, focado em gestão financeira real, controle de desgaste mecânico por quilometragem e planejamento de metas mensais.

### 1.2 Problema Resolvido
A maioria dos motoboys calcula o lucro apenas subtraindo o valor da gasolina do faturamento bruto, ignorando o desgaste progressivo da moto (pneus, óleo, kit relação, freios, etc.) e os custos fixos mensais. O aplicativo resolve isso transformando cada peça da moto em um **custo fracionado por quilômetro rodado** e separando automaticamente o dinheiro que pertence à manutenção da moto ("Caixinha da Moto") do lucro líquido real.

### 1.3 Pilares do Aplicativo
1. **Painel Digital em Tempo Real:** Interface de alto contraste (modo noturno/AMOLED) que conta a quilometragem via GPS gratuito (ou odômetro manual) e exibe o custo subindo em reais a cada quilômetro.
2. **Controle de Desgaste Real:** Cadastro inicial adaptado para motos usadas (informando a porcentagem ou KM restante de cada peça) com alertas visuais de troca.
3. **Gestão Diária por Data:** Cada dia de trabalho gera um registro salvo com ganhos por aplicativo, gastos extras na rua e fechamento do turno.
4. **Planejamento e Metas Dinâmicas:** Definição de meta líquida mensal e escala de trabalho (dias da semana e turnos), com recálculo automático da meta diária caso o motorista folgue ou fature abaixo do esperado.

---

## 2. Arquitetura e Stack Tecnológica

Para desenvolver uma única base de código que funcione tanto no **Computador** quanto no **Celular**, recomenda-se a abordagem **Web + PWA + Capacitor**:

### 2.1 Camada de Interface (Front-end)
* **Base:** HTML5, CSS3 e JavaScript (ou TypeScript).
* **Frameworks Recomendados (opcionais):** React, Vue.js ou Vanilla JS modular (Vite como empacotador).
* **Estilização:** Tailwind CSS ou CSS Grid/Flexbox puro com suporte nativo a temas escuros e responsividade (Retrato, Paisagem e Desktop).
* **Gráficos:** Chart.js ou ApexCharts (leves e responsivos para gráficos de rosca e barras).

### 2.2 Distribuição Multiplataforma
* **Computador e Celular (Fase Inicial):** **PWA (Progressive Web App)** — funciona direto no navegador, pode ser instalado na tela inicial do celular ou no Windows/Mac e opera offline via *Service Workers*.
* **Android Nativo (Fase Avançada — GPS em Segundo Plano):** **Capacitor (Ionic)** — gratuito e *open-source*, empacota o código web em um APK nativo para Android, permitindo acesso a plugins de localização em segundo plano (*Foreground Service*) sem precisar reescrever o app em outra linguagem.

### 2.3 Armazenamento e Banco de Dados (Estratégia Local-First)
* **Armazenamento Local (Obrigatório para rodar na rua sem internet):**
  * No PWA/Web: **IndexedDB** (recomenda-se a biblioteca **Dexie.js** para facilitar consultas).
  * No APK (Capacitor): **SQLite** local.
* **Backup Manual (Custo Zero):** Botão de Exportar/Importar toda a base de dados em um arquivo `.json`.
* **Sincronização em Nuvem (Opcional para Fase Futura):** **Supabase** (PostgreSQL), **Firebase** ou **Turso** (todos possuem planos gratuitos). Os dados são salvos localmente primeiro e sincronizados com a nuvem assim que houver conexão, permitindo abrir os dados da rua no computador de casa.

### 2.4 APIs Nativas Gratuitas Utilizadas
* **Geolocation API (`navigator.geolocation.watchPosition`):** Captura de coordenadas GPS em tempo real sem custo de APIs externas.
* **Screen Wake Lock API (`navigator.wakeLock`):** Impede que a tela do celular apague enquanto o painel digital estiver aberto no guidão.
* **Web Notifications / Vibration API:** Alertas de manutenção vencida ou meta diária atingida.

---

## 3. Regras de Negócio e Fórmulas de Cálculo

### 3.1 Custo Fracionado por Quilômetro (Desgaste)
Cada peça ou insumo tem seu custo convertido em reais por quilômetro rodado:

$$\text{Custo por KM} = \frac{\text{Valor da Peça} + \text{Mão de Obra}}{\text{Vida Útil Total em KM}}$$

Para o combustível:

$$\text{Custo Combustível por KM} = \frac{\text{Preço do Litro (R\$)}}{\text{Consumo Médio da Moto (km/L)}}$$

#### Tabela Padrão Sugerida (Editável pelo Usuário)
*Base de exemplo: moto 125cc/160cc, gasolina a R$ 7,00/L fazendo 40 km/L.*

| Item de Desgaste | Valor Médio (R$) | Vida Útil (km) | Custo por KM (R$) | Tipo de Alerta |
| :--- | :--- | :--- | :--- | :--- |
| **Gasolina** | R$ 7,00 (1 L) | 40 km | R$ 0,175 | Autonomia do tanque |
| **Óleo do motor** | R$ 40,00 | 1.000 km | R$ 0,040 | Contagem regressiva |
| **Pneu traseiro** | R$ 220,00 | 12.000 km | R$ 0,018 | Contagem regressiva |
| **Pneu dianteiro** | R$ 180,00 | 18.000 km | R$ 0,010 | Contagem regressiva |
| **Kit relação** | R$ 150,00 | 15.000 km | R$ 0,010 | Contagem regressiva |
| **Freio traseiro** (lona/pastilha) | R$ 45,00 | 8.000 km | R$ 0,006 | Contagem regressiva |
| **Freio dianteiro** (pastilha/lona) | R$ 50,00 | 10.000 km | R$ 0,005 | Contagem regressiva |
| **Filtro de ar** | R$ 35,00 | 10.000 km | R$ 0,004 | Contagem regressiva |
| **Vela de ignição** | R$ 30,00 | 15.000 km | R$ 0,002 | Contagem regressiva |
| **Cabos** (embreagem/acelerador/freio) | R$ 80,00 | 15.000 km | R$ 0,005 | Contagem regressiva |
| **Reserva de manutenção** (lâmpadas, câmara, rolamentos, lubrificante) | R$ 200,00 | 10.000 km | R$ 0,020 | Fundo acumulado |
| **TOTAL ESTIMADO POR KM** | — | — | **R$ 0,295 / km** | — |

*Itens opcionais ativáveis:* Filtro de óleo, filtro de combustível, fluido de freio, óleo de bengala.

### 3.2 Estado Inicial da Moto (Peças Usadas)
No primeiro acesso, o usuário pode indicar o desgaste atual de cada peça via porcentagem (ex: 80% restante) ou quilometragem restante:

$$\text{KM Restante} = \text{Vida Útil Total} \times \left(\frac{\% \text{ Atual}}{100}\right)$$

A cada encerramento de turno, o aplicativo subtrai o `km_rodados` do `km_restante` de todas as peças ativas.

### 3.3 Semáforo de Saúde das Peças
* **Verde:** mais de 25% da vida útil restante.
* **Amarelo (Atenção):** entre 1% e 25% restante (ou menos de 150 km para o óleo).
* **Vermelho (Vencido):** `km_restante` $\le 0$.

### 3.4 Fechamento Financeiro do Dia
Ao final do turno, o sistema calcula:

$$\text{Custo Combustível} = \text{KM Rodados} \times \text{Custo Combustível/KM}$$

$$\text{Caixinha da Moto (Desgaste)} = \text{KM Rodados} \times \sum \text{Custo Peças/KM}$$

$$\text{Lucro Líquido do Dia} = \text{Faturamento Bruto} - \text{Custo Combustível} - \text{Caixinha da Moto} - \text{Gastos Extras} - \text{Custo Fixo Diário}$$

### 3.5 Planejamento Financeiro e Meta Dinâmica Mensal
O usuário define:
* `Meta Líquida Mensal` ($M_{liq}$)
* `Custos Fixos Mensais` ($C_{fix}$): parcela/aluguel, seguro, internet, MEI, IPVA rateado.
* `Dias de Trabalho no Mês` ($D_{total}$): calculado automaticamente a partir dos dias da semana marcados no calendário.
* `Estimativa de Custos Variáveis Diários` ($C_{var}$): média de KM/dia $\times$ custo total por KM + média de lanche/água.

**Cálculo da Meta Bruta Diária Inicial:**

$$\text{Meta Bruta Diária} = \left(\frac{M_{liq} + C_{fix}}{D_{total}}\right) + C_{var}$$

**Recálculo Dinâmico (ao longo do mês):**
Se o motoboy faltar um dia ou faturar menos que o previsto, o sistema recalcula para os dias úteis restantes ($D_{rest}$):

$$\text{Nova Meta Líquida Diária} = \frac{(M_{liq} + C_{fix}) - \text{Lucro Líquido Acumulado no Mês}}{D_{rest}}$$

### 3.6 Radar de Manutenção (Previsão em Dias)
Usando a média de quilômetros rodados por dia trabalhado ($\text{KM}_{medio}$):

$$\text{Dias até a Troca} = \frac{\text{KM Restante da Peça}}{\text{KM}_{medio}}$$

---

## 4. Rastreamento de Quilometragem (GPS Gratuito)

### 4.1 Fórmula de Haversine
Para calcular a distância em quilômetros entre o ponto anterior $(\phi_1, \lambda_1)$ e o ponto atual $(\phi_2, \lambda_2)$ em radianos, sendo $R = 6371\text{ km}$ o raio da Terra:

$$a = \sin^2\left(\frac{\Delta\phi}{2}\right) + \cos(\phi_1)\cos(\phi_2)\sin^2\left(\frac{\Delta\lambda}{2}\right)$$

$$d = 2R \cdot \text{atan2}\left(\sqrt{a}, \sqrt{1-a}\right)$$

### 4.2 Filtros Anti-Ruído (Evitar Contagem com a Moto Parada)
Antes de somar qualquer trecho calculado ao odômetro do dia, aplicar 3 travas obrigatórias:
1. **Precisão (`accuracy`):** Descartar leituras com margem de erro superior a **25 metros**.
2. **Velocidade mínima (`speed`):** Só somar se a velocidade reportada for maior ou igual a **1,5 m/s** ($\approx 5,4\text{ km/h}$).
3. **Distância mínima:** Ignorar deslocamentos menores que **10 metros** ($0,01\text{ km}$) entre dois pontos consecutivos.
4. **Reset ao pausar:** Ao pausar o turno, limpar a variável `ultimoPonto` para evitar que o GPS trace uma linha reta somando distância caso o usuário reative o app em outro bairro.

### 4.3 Limitação de Segundo Plano e Soluções
* **No Navegador (PWA):** O Android/iOS suspende o GPS quando o app é minimizado (ex: ao abrir Uber/iFood por cima).
* **Solução 1 (Imediata no PWA):** Oferecer o modo **Odômetro Manual** (digitar KM inicial e final do painel da moto) como alternativa ao GPS contínuo.
* **Solução 2 (Definitiva no Android):** Empacotar com **Capacitor** e adicionar o plugin `@capacitor-community/background-geolocation`, que cria uma notificação fixa no Android mantendo o GPS ativo com a tela desligada ou outros apps abertos.

---

## 5. Modelagem do Banco de Dados (Schema)

Estrutura pensada para funcionar igualmente no **IndexedDB** (local) e em bancos relacionais (**SQLite / PostgreSQL**).

### 5.1 Tabela `perfil_moto`
Armazena as configurações do motorista e do veículo.
* `id` (UUID / Int, PK)
* `nome_motorista` (String)
* `modelo_moto` (String)
* `odometro_atual` (Float)
* `km_por_litro` (Float)
* `preco_combustivel` (Float)
* `capacidade_tanque` (Float)
* `modo_contagem_padrao` (Enum: `'gps'`, `'manual'`)

### 5.2 Tabela `pecas_desgaste`
Cadastro de todos os itens que sofrem desgaste por KM.
* `id` (UUID / Int, PK)
* `moto_id` (FK -> `perfil_moto.id`)
* `nome_peca` (String)
* `valor_peca` (Float)
* `valor_mao_obra` (Float)
* `vida_util_km` (Float)
* `km_restante` (Float)
* `data_ultima_troca` (Date)
* `ativo` (Boolean)

### 5.3 Tabela `historico_trocas`
Registra cada vez que o motoboy clica em "Troquei" em uma peça (gera histórico de manutenção da moto).
* `id` (UUID / Int, PK)
* `peca_id` (FK -> `pecas_desgaste.id`)
* `data_troca` (Date)
* `odometro_na_troca` (Float)
* `valor_pago_real` (Float)
* `observacao` (String)

### 5.4 Tabela `turnos_diarios`
Representa cada ficha de trabalho aberta por data/turno.
* `id` (UUID / Int, PK)
* `data` (Date — formato `YYYY-MM-DD`)
* `turno` (Enum: `'manha'`, `'tarde'`, `'noite'`, `'integral'`)
* `hora_inicio` (Timestamp)
* `hora_fim` (Timestamp)
* `tempo_trabalhado_min` (Int)
* `km_inicial_manual` (Float, nullable)
* `km_final_manual` (Float, nullable)
* `km_rodados` (Float)
* `ganho_uber` (Float)
* `ganho_99` (Float)
* `ganho_ifood` (Float)
* `ganho_particular` (Float)
* `gorjetas` (Float)
* `custo_combustivel_calc` (Float)
* `custo_desgaste_calc` (Float)
* `lucro_liquido_calc` (Float)
* `status` (Enum: `'em_andamento'`, `'pausado'`, `'finalizado'`)

### 5.5 Tabela `lancamentos_gastos`
Registra gastos extras na rua (vinculados ao turno) e custos fixos mensais.
* `id` (UUID / Int, PK)
* `turno_id` (FK -> `turnos_diarios.id`, nullable para custos fixos)
* `data` (Date)
* `tipo` (Enum: `'extra_diario'`, `'custo_fixo'`, `'manutencao_imprevista'`)
* `categoria` (String — ex: `'Lanche'`, `'Água'`, `'Remendo'`, `'Seguro'`, `'Parcela Moto'`)
* `descricao` (String)
* `valor` (Float)
* `recorrente_mensal` (Boolean)

### 5.6 Tabela `metas_mensais`
Armazena o planejamento financeiro de cada mês.
* `id` (UUID / Int, PK)
* `mes_ano` (String — formato `YYYY-MM`)
* `meta_liquida` (Float)
* `dias_semana_ativos` (Array/JSON — ex: `[1, 2, 3, 4]` para Seg a Qui)
* `turno_preferencial` (String)
* `media_km_dia_estimada` (Float)
* `media_gasto_extra_dia` (Float)

---

## 6. Interface Gráfica (UI/UX) e Responsividade

### 6.1 Identidade Visual e Tema
* **Fundo Principal:** Preto puro (`#000000`) e cinza grafite escuro (`#121614` / `#1A1F1C`) para economia de bateria em telas AMOLED e conforto visual à noite.
* **Display Digital:** Tipografia estilo painel de moto (fonte *7-segment* ou *monospace* negrito) em **Verde Neon (`#39FF14` / `#4ADE80`)** ou **Âmbar (`#FBBF24`)** com alto contraste para leitura sob luz solar forte.
* **Botões de Ação:** Grandes (mínimo 48px a 56px de altura) para facilitar o toque rápido com a moto parada ou usando luvas.

### 6.2 Adaptação de Tela (Responsividade)
* **Celular Vertical (Retrato):**
  * Topo: Painel digital (KM + R$ gasto no dia).
  * Meio: Gráfico de rosca (Gasolina vs. Desgaste vs. Extras) + Botões grandes de *Iniciar/Pausar* e *Finalizar Dia*.
  * Base: Cards de *Saúde da Moto* (barras de progresso) + Menu inferior de navegação.
* **Celular Horizontal (Paisagem — Guidão):**
  * Esquerda (55%): Painel digital ampliado (KM, Custo em R$, Velocidade/Tempo e botões de controle).
  * Direita (45%): Gráfico compacto de gastos + alertas críticos de manutenção + botão rápido de "+ Gasto".
* **Computador (Desktop):**
  * Menu lateral fixo (*Sidebar*) com acesso a todas as abas.
  * Área principal em grade (*Grid* de 2 a 3 colunas) exibindo dashboard financeiro completo, gráficos mensais, calendário de turnos e tabela detalhada de peças.

---

## 7. Detalhamento Completo das Telas

### Tela 1: Onboarding / Cadastro Inicial (Primeiro Acesso)
Fluxo em 3 passos rápidos (pode ser editado depois):
1. **Sua Moto:** Nome do usuário, modelo da moto, odômetro atual, preço da gasolina e consumo (km/L).
2. **Estado das Peças:** Lista pré-preenchida com as peças padrão. Cada item traz o valor médio, vida útil e um **controle deslizante (slider) de 0% a 100%** para o usuário indicar como a peça está hoje (ex: *"Pneu traseiro em 70%"*).
3. **Sua Primeira Meta:** Valor líquido desejado no mês e dias da semana que trabalha.

### Tela 2: Área de Trabalho Diária (Tela Principal / Painel)
* **Seletor de Data no Topo:** Permite visualizar o dia atual (padrão) ou navegar por datas anteriores no calendário.
* **Painel Digital:** Exibe `KM do Dia`, `Gasto Acumulado (R$)` e `Tempo de Turno`. Botão de alternância rápida entre **GPS** e **Odômetro Manual**.
* **Indicador de Meta do Dia:** Pequena barra no topo ou abaixo do painel mostrando quanto falta para bater a meta bruta do dia.
* **Gráfico de Gastos em Tempo Real:** Rosca dividindo Combustível, Desgaste de Peças e Gastos Extras.
* **Controles do Turno:** Botão principal (`INICIAR DIA` / `FINALIZAR DIA`), botão de `PAUSA` e botão de atalho `+ Gasto Rápido` (abre modal com ícones: Lanche, Água, Remendo, Outros).
* **Resumo "Saúde da Moto":** Exibe as 3 peças mais próximas da troca com barras coloridas (verde/amarelo/vermelho).

### Tela 3: Fechamento do Dia (Modal ou Tela Dedicada)
Aberta automaticamente ao clicar em **Finalizar Dia**:
1. Confirmação do KM total rodado (permite ajuste manual se o GPS tiver falhado).
2. Campos de **Faturamento Bruto** (Uber, 99, iFood, Particular, Gorjetas).
3. Revisão dos **Gastos Extras** lançados no dia.
4. **Extrato Final do Turno:**
   * (+) Faturamento Bruto
   * (-) Combustível estimado
   * (-) **Caixinha da Moto** (destaque visual lembrando o usuário de guardar esse valor)
   * (-) Gastos Extras e Custo Fixo do dia
   * (=) **Lucro Líquido Real** + Ganho por KM e Ganho por Hora.
5. Botão **"Salvar e Encerrar Dia"**: grava o turno, dá baixa na vida útil das peças e atualiza a meta mensal.

### Tela 4: Garagem e Saúde da Moto
* Lista completa de todas as peças cadastradas com barra de progresso, KM restante e valor estimado da próxima troca.
* **Botão "Troquei" em cada peça:** abre janela perguntando o valor pago real, registra na tabela `historico_trocas`, zera o desgaste da peça (volta para 100%) e oferece a opção de abater o valor da "Caixinha da Moto".
* **Botão "+ Nova Peça":** permite cadastrar itens personalizados.
* **Radar de Manutenção:** box no topo listando as próximas trocas previstas em dias (ex: *"Troca de óleo em ~5 dias"*).

### Tela 5: Planejamento Financeiro e Metas
* **Configuração de Meta:** Campo de Meta Líquida Mensal (ex: R$ 3.500,00).
* **Custos Fixos Mensais:** Lista editável (Parcela, Seguro, Internet, MEI, IPVA) com total mensal e valor rateado por dia trabalhado.
* **Escala de Trabalho:** Botões para marcar os dias da semana (`Seg`, `Ter`, `Qua`, `Qui`, `Sex`, `Sáb`, `Dom`) e turno preferido.
* **Painel de Resultado da Meta:** Exibe quantos dias de trabalho existem no mês, a **Meta Bruta Diária** calculada e o **Status Atual** (se está adiantado ou atrasado em relação à meta, com o valor recalculado automaticamente).

### Tela 6: Relatórios e Fechamento Mensal (Ideal para PC e Celular)
* **Filtro de Período:** Mês atual, mês anterior ou intervalo personalizado.
* **DRE do Motoboy:** Resumo completo de entradas, saídas por categoria, saldo acumulado da Caixinha da Moto e Lucro Líquido Final.
* **Indicadores de Performance:**
  * Média de ganho líquido por KM rodado.
  * Média de ganho líquido por hora trabalhada.
  * Comparativo de rentabilidade por aplicativo (Uber vs. 99 vs. iFood).
  * Gráfico de melhores dias da semana/turnos.
* **Histórico de Turnos:** Lista clicável de todos os dias trabalhados no mês para consulta ou edição.

### Tela 7: Configurações e Dados
* Edição rápida do preço da gasolina e consumo da moto.
* Configuração dos filtros de GPS (velocidade mínima e precisão) e opção de manter tela sempre ligada (*Wake Lock*).
* **Backup e Portabilidade:**
  * Botão **Exportar Dados (`.json`)** para transferir do celular para o PC.
  * Botão **Importar Dados (`.json`)** para restaurar backup.
  * Botão **Exportar Relatório Mensal (CSV/PDF)** para controle pessoal ou imposto de renda/MEI.

---

## 8. Roadmap de Desenvolvimento Sugerido

### Fase 1 — MVP Funcional (Foco em Validação Rápida)
* Criar estrutura HTML/CSS/JS (PWA) responsiva (retrato e paisagem).
* Implementar banco local com **IndexedDB (Dexie.js)**.
* Construir Tela de Cadastro Inicial, Painel Digital (GPS + Odômetro Manual), Fechamento do Dia e Tela de Peças.
* Implementar Exportar/Importar Backup em JSON.

### Fase 2 — Inteligência Financeira e Visão Desktop
* Construir módulo de Planejamento Financeiro, Escala Semanal e Meta Dinâmica.
* Construir Tela de Relatórios Mensais (DRE, gráficos e Radar de Manutenção).
* Refinar layout Desktop para visualização ampla no computador.

### Fase 3 — Aplicativo Android Nativo (GPS em Segundo Plano)
* Integrar projeto ao **Capacitor**.
* Configurar plugin de geolocalização em segundo plano (*Foreground Service*) para permitir uso simultâneo com Uber/99/iFood.
* Gerar APK de testes para instalação direta em celulares Android.

### Fase 4 — Nuvem e Sincronização Automática (Opcional)
* Criar autenticação simples (e-mail ou Google) usando **Supabase** ou **Firebase**.
* Implementar sincronização automática entre o celular na rua e o navegador no computador.