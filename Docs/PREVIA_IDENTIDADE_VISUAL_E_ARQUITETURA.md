# MotoCash Pro — Prévia da Identidade Visual, Arquitetura e Regras de Negócio

> **Documento Oficial de Especificação e Identidade Visual**  
> **Repositório GitHub:** [https://github.com/LeoLemosDevs/Projeto_MotoCash](https://github.com/LeoLemosDevs/Projeto_MotoCash)  
> **Hospedagem:** Vercel  
> **Banco de Dados Cloud Opcional:** Turso (libSQL Edge SQLite)  
> **Arquitetura:** Progressive Web App (PWA) Offline-First Responsivo (Mobile & Desktop)

---

## 1. Identidade Visual e Experiência do Usuário (UI/UX)

O **MotoCash Pro** foi concebido como um instrumento de alta precisão para o motoboy na rua ("Canivete Suíço Financeiro"). A interface visual respeita as condições reais de trabalho de quem roda o dia todo de moto:

### 1.1 Paleta de Cores e Contraste AMOLED
* **Fundo Primário (Preto AMOLED Puro):** `#030508` e `#070A0E` — Garante consumo mínimo de bateria em telas OLED/AMOLED de smartphones e zero reflexo durante entregas noturnas.
* **Superfícies de Cards:** `#11161F` com bordas sutis em `#1F2937` — Separação visual nítida sob luz ambiente.
* **Verde Neon Principal:** `#00E676` (com brilho *glow* `rgba(0, 230, 118, 0.45)`) — Usado no odômetro digital, velocímetro, lucro líquido real e indicadores de peças em perfeito estado.
* **Âmbar / Laranja de Atenção:** `#F59E0B` — Usado para o valor acumulado em reais (gasto do dia), alertas de peças que atingiram entre 15% e 30% da vida útil e para a **Caixinha da Moto**.
* **Azul de Ação:** `#3B82F6` — Usado para gastos extras (lanche, remendo, pedágio) e dados de autonomia do tanque.
* **Vermelho de Alerta Crítico:** `#EF4444` — Para peças com menos de 15% de vida útil (troca imediata), botão de finalizar dia e despesas emergenciais.

### 1.2 Tipografia Cockpit
* **Display do Painel Digital:** Fonte `Orbitron` e `JetBrains Mono` — Dígitos numéricos tabulares de largura fixa inspirados nos velocímetros digitais de motos esportivas modernas (Yamaha MT, Honda CB).
* **Interface Geral:** Fonte `Inter` — Tipografia humanista, limpa e legível mesmo em tamanhos reduzidos ou com o celular vibrando no suporte do guidão.

### 1.3 Modos de Visualização Responsiva
1. **Celular Vertical (Retrato):**
   * Topo: Visor digital AMOLED gigante exibindo KM rodados e R$ gastos em tempo real.
   * Meio: Três botões de toque largo (mínimo 56px de altura para uso fácil com luvas): *Iniciar/Pausar*, *+ Gasto Extra* e *Finalizar Dia*.
   * Base: Gráfico de rosca dinâmico dividindo Gasolina, Caixinha da Moto e Extras + Cards de saúde das peças críticas.
2. **Celular Horizontal (Modo Guidão / Paisagem):**
   * Metade Esquerda: Cluster digital ampliado de alta visibilidade com odômetro, velocímetro ao vivo e cronômetro de turno.
   * Metade Direita: Resumo financeiro imediato com botão rápido de atalho para lançar gastos sem tirar o foco da pilotagem.
3. **Computador (Desktop):**
   * Sidebar fixa à esquerda com acesso rápido às 4 visões centrais.
   * Grade ampla em 3 colunas com DRE detalhado, calendário de turnos, radar de manutenção preventiva em dias e gráficos de metas financeiras.

---

## 2. Detalhamento dos Gastos Calculados por Quilômetro

O motoboy gasta dinheiro a cada metro que a roda gira. O aplicativo calcula em tempo real o **Custo por Quilômetro (R$/km)** somando:

$$\text{Custo Total por KM} = \text{Custo Combustível/KM} + \sum \left(\frac{\text{Valor da Peça}}{\text{Vida Útil em KM}}\right)$$

### 2.1 Tabela Padrão de Desgaste (Editável pelo Usuário)
*Exemplo com base em uma moto popular (CG 160 / Factor 150), gasolina no Ceará a R$ 7,00/L com consumo médio de 40 km/L:*

| Item / Equipamento | Valor Médio (R$) | Vida Útil Estimada | Custo por KM (R$) | Indicador no Painel |
| :--- | :--- | :--- | :--- | :--- |
| **Gasolina (Combustível)** | R$ 7,00 / Litro | 40 km por Litro | **R$ 0,1750 / km** | Gasto em tempo real |
| **Óleo do Motor** | R$ 40,00 | 1.000 km | **R$ 0,0400 / km** | Contagem regressiva (km) |
| **Pneu Traseiro** | R$ 220,00 | 12.000 km | **R$ 0,0183 / km** | Barra de saúde % |
| **Pneu Dianteiro** | R$ 180,00 | 18.000 km | **R$ 0,0100 / km** | Barra de saúde % |
| **Kit Relação (Coroa/Pinhão/Corrente)** | R$ 150,00 | 15.000 km | **R$ 0,0100 / km** | Barra de saúde % |
| **Pastilha / Lona de Freio Traseira** | R$ 45,00 | 8.000 km | **R$ 0,0056 / km** | Barra de saúde % |
| **Pastilha de Freio Dianteira** | R$ 50,00 | 10.000 km | **R$ 0,0050 / km** | Barra de saúde % |
| **Filtro de Ar** | R$ 35,00 | 10.000 km | **R$ 0,0035 / km** | Barra de saúde % |
| **Vela de Ignição** | R$ 30,00 | 15.000 km | **R$ 0,0020 / km** | Barra de saúde % |
| **Cabos (Embreagem e Acelerador)** | R$ 80,00 | 15.000 km | **R$ 0,0053 / km** | Barra de saúde % |
| **Reserva de Manutenção Geral** | R$ 200,00 | 10.000 km | **R$ 0,0200 / km** | Fundo emergencial |
| **CUSTO TOTAL ESTIMADO** | — | — | **~ R$ 0,295 / km** | — |

> **Nota:** Todos os valores de peças e vida útil podem ser personalizados na aba **"Minha Moto"**, e novas peças personalizadas (ex: amortecedor, retentor, bateria) podem ser adicionadas livremente.

---

## 3. Funcionamento do Rastreamento GPS ao Vivo na Moto

1. **Ativação da Corrida ("Ligar o Dia"):**
   * O motoboy toca em **"Iniciar Dia"**. O aplicativo solicita permissão de GPS e aciona a `Screen Wake Lock API` para manter a tela acesa no suporte.
2. **Leitura Contínua via `watchPosition`:**
   * Utiliza coordenadas geográficas (`lat`, `lng`) com `enableHighAccuracy: true`.
3. **Filtro Anti-Ruído Inteligente:**
   * **Parado no Semáforo:** Se a velocidade for menor que 5,4 km/h (1,5 m/s) ou o deslocamento entre pontos for menor que 10 metros, a distância **NÃO** é somada, evitando que o GPS oscile parado e gere quilometragem fantasma.
   * **Margem de Erro de Satélite:** Pontos com `accuracy` pior que 25 metros são descartados.
   * **Cálculo da Distância:** Aplica a fórmula matemática de Haversine para precisão centimétrica.
4. **Atualização Dinâmica do Custo:**
   * Conforme os quilômetros sobem (ex: 12.4 km), o custo total do dia é recalculado na hora ($12.4 \times \text{R\$} 0,295 = \text{R\$} 3,65$).
5. **Opção de Odômetro Manual:**
   * Caso o motoboy prefira rodar com o celular no bolso para economizar bateria, ele pode abrir o app no fim do dia, digitar o KM do painel da moto e o app faz exatamente os mesmos cálculos.

---

## 4. Fechamento do Turno e Lucro Líquido Real

No fim do dia, o motoboy clica em **"Finalizar Dia"** e preenche quanto faturou nos aplicativos (iFood, 99Moto, Uber Moto, Entregas Particulares e Gorjetas).

O sistema gera o **Extrato Transparente**:
1. **Faturamento Bruto:** Ex: R$ 220,00
2. **(-) Gasolina Estimada:** Ex: R$ 35,00
3. **(-) Caixinha da Moto (Desgaste de Peças):** Ex: R$ 24,00 *(dinheiro que o motoboy DEVE guardar em uma conta separada para quando o pneu furar ou o óleo vencer)*
4. **(-) Gastos Extras do Dia (Lanche, Água):** Ex: R$ 15,00
5. **(=) Lucro Líquido Real:** R$ 146,00 livres no bolso!
6. **Métricas de Performance:** Ganho Real por KM (ex: R$ 1,22/km livre) e Ganho por Hora (ex: R$ 18,25/h livre).

---

## 5. Arquitetura PWA e Banco de Dados Turso

* **PWA Instalável:** Manifest e Service Worker configurados para instalação nativa no Android via Chrome, no iOS via Safari ("Adicionar à Tela de Início") e no Windows via Edge/Chrome.
* **Armazenamento Local-First:** Funciona 100% sem conexão com a internet através do armazenamento local seguro no navegador.
* **Sincronização em Nuvem via Turso:** Suporte nativo à API do Turso (libSQL) para envio e backup dos turnos em nuvem de baixa latência.
