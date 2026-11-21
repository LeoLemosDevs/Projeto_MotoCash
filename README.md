# 🏍️ MotoCash Pro — Painel Financeiro e Odômetro Digital para Motoboys

> **Aplicativo PWA Multiplataforma (Celular e Computador) para Gestão Financeira Real, Desgaste Mecânico por KM e Planejamento de Metas.**  
> Hospedagem: **Vercel**  
> Repositório: **https://github.com/LeoLemosDevs/Projeto_MotoCash**  
> Banco de Dados em Nuvem (Opcional): **Turso (libSQL Edge SQLite)**

---

## 📱 Visão Geral

A maioria dos motoboys e entregadores de aplicativo (iFood, 99Moto, Uber Moto, Lalamove, Loggi, etc.) calcula seu ganho diário apenas subtraindo o dinheiro da gasolina do faturamento bruto. Isso cria uma ilusão de lucro e gera desespero quando o pneu fura, o óleo vence ou a relação quebra.

O **MotoCash Pro** resolve isso transformando cada peça da moto em um **custo fracionado por quilômetro rodado**. Enquanto o motoboy roda na moto com o celular no suporte do guidão, o painel digital AMOLED conta os quilômetros em tempo real via GPS e soma os reais gastos na **"Caixinha da Moto"**.

---

## 🚀 Funcionalidades Principais

### 1. 📟 Painel Digital Cockpit (Odômetro AMOLED em Tempo Real)
* **Design de Alto Contraste:** Fundo preto puro (`#030508`) com tipografia digital (`Orbitron` e `JetBrains Mono`) em Verde Neon e Âmbar, garantindo visibilidade sob sol do meio-dia e sem ofuscar à noite.
* **Contagem de KM ao Rodar na Moto:** Utiliza a Geolocation API (`navigator.geolocation.watchPosition`) com fórmula matemática de Haversine e filtros anti-ruído (velocidade mínima e margem de erro < 25m) para **NÃO** somar distância falsa enquanto a moto estiver parada no sinal.
* **Tela Sempre Ligada (Wake Lock):** Ativa automaticamente o `navigator.wakeLock` ao iniciar o dia, impedindo que o celular apague no suporte da moto.
* **Modo Simulação Embutido:** Permite testar o odômetro e os custos subindo a ~48 km/h direto no computador sem precisar sair de moto.
* **Odômetro Manual:** Botão de contingência rápida para adicionar a quilometragem do painel analógico da moto caso o motoboy precise economizar bateria.

### 2. 🔧 Cálculo Detalhado de Gastos por Quilômetro
Todos os insumos e equipamentos possuem custo calculado por quilômetro:
* **Gasolina:** Preço do Litro (ex: R$ 7,00 no Ceará) dividido pelo consumo (ex: 40 km/L) = **R$ 0,175 / km**.
* **Óleo do Motor:** R$ 40,00 / 1.000 km = **R$ 0,040 / km** (com alerta e contagem regressiva).
* **Pneu Dianteiro:** R$ 180,00 / 18.000 km = **R$ 0,010 / km**.
* **Pneu Traseiro:** R$ 220,00 / 12.000 km = **R$ 0,018 / km**.
* **Kit Relação (Corrente/Coroa/Pinhão):** R$ 150,00 / 15.000 km = **R$ 0,010 / km**.
* **Pastilhas de Freio (Dianteira e Traseira):** ~R$ 0,011 / km somadas.
* **Filtro de Ar, Vela e Cabos:** ~R$ 0,011 / km somados.
* **Reserva de Manutenção Preventiva:** R$ 200,00 / 10.000 km = **R$ 0,020 / km**.
* **Custo Total Médio:** ~ **R$ 0,295 por quilômetro rodado**.
* **Sliders de Saúde da Moto:** Permite indicar o estado de motos usadas (0% a 100%) no cadastro inicial.
* **Botão "Troquei":** Ao realizar a troca na oficina, o usuário registra o valor real pago, zera o ciclo da peça e salva no histórico de manutenções.

### 3. 🏁 Fechamento do Dia e Lucro Líquido Real
Ao clicar em **"Finalizar Dia"**, o motoboy informa quanto ganhou nos aplicativos (iFood, 99Moto, Uber, Particulares, Gorjetas). O aplicativo exibe o extrato transparente:
* **(+) Faturamento Bruto**
* **(-) Gasolina Estimada**
* **(-) Caixinha da Moto (Peças a guardar)**
* **(-) Gastos Extras (Lanches, Água, Remendo)**
* **(=) Lucro Líquido Real**
* **Métricas:** Ganho Real por KM (R$/km) e Ganho Real por Hora (R$/h).

### 4. 🎯 Metas Financeiras e Recálculo Dinâmico
* Definição de Meta Líquida Mensal e Custos Fixos (Parcela da moto, Seguro, MEI, Celular).
* Escala semanal (marcação dos dias trabalhados de Seg a Dom).
* Recálculo automático da Meta Diária.

### 5. 📊 Relatórios, Histórico & DRE
* Histórico completo de turnos salvos com filtros e indicadores.
* Exportação de relatórios para planilha **CSV**.
* **Backup e Restauração em JSON** para portabilidade total entre celular e computador.

### 6. 🌐 PWA (Instalável no Celular e PC)
* Funciona **100% offline** via Service Worker (`sw.js`).
* Pode ser instalado diretamente pelo navegador no Android (Chrome), iOS (Safari - "Adicionar à Tela de Início") ou Windows/Mac.

### 7. ☁️ Banco de Dados Turso (libSQL Edge SQLite)
* O app é **Local-First** (salva tudo instantaneamente no aparelho).
* Possui módulo nativo para conectar ao **Turso** via REST API, sincronizando os turnos na nuvem para consulta em múltiplos dispositivos.
* O arquivo `turso-schema.sql` contém a estrutura completa de tabelas e índices.

---

## 🛠️ Como Rodar Localmente

1. Clone o repositório ou acesse a pasta do projeto:
```bash
git clone https://github.com/LeoLemosDevs/Projeto_MotoCash.git
cd Projeto_MotoCash
```

2. Você pode abrir o arquivo `index.html` diretamente em qualquer navegador, ou rodar com um servidor local:
```bash
# Com Node.js / npx:
npx serve .

# Ou com Python:
python -m http.server 3000
```

3. Acesse no navegador:
```
http://localhost:3000
```

---

## 🚀 Como Publicar na Vercel

O projeto está configurado com o arquivo `vercel.json` para deploy com 1 clique:

1. Instale a CLI da Vercel (opcional) ou conecte via GitHub:
   * Acesse [vercel.com](https://vercel.com)
   * Clique em **Add New... > Project**
   * Importe o repositório `LeoLemosDevs/Projeto_MotoCash`
   * Mantenha as configurações padrão (Framework: *Other*) e clique em **Deploy**.
2. Ou via terminal:
```bash
npx vercel
```

---

## 🗄️ Estrutura do Projeto

```
Projeto_Motoboy_Financeiro/
├── index.html                   # Aplicação PWA completa e unificada (SPA)
├── manifest.webmanifest         # Configuração de instalação PWA (ícones, cores, display)
├── sw.js                        # Service Worker para funcionamento 100% offline
├── vercel.json                  # Configurações de headers e cache para hospedagem Vercel
├── turso-schema.sql             # Schema SQL completo para o banco Turso / SQLite
├── package.json                 # Metadados do projeto e scripts
├── .gitignore                   # Arquivos ignorados pelo Git
├── README.md                    # Documentação oficial
├── assets/
│   ├── icons/
│   │   ├── icon.svg             # Ícone vetorial esportivo
│   │   ├── icon-192.png         # Ícone PWA 192x192
│   │   ├── icon-512.png         # Ícone PWA 512x512
│   │   └── icon-maskable.png    # Ícone adaptativo para Android
└── Docs/
    ├── PREVIA_IDENTIDADE_VISUAL_E_ARQUITETURA.md  # Especificação técnica completa
    ├── documenta_o_do_projeto_app_financeiro_para_motoboys.md
    ├── motocash_pro_painel_de_quilometragem.html   # Prévia individual do painel
    ├── motocash_pro_perfil_e_minha_moto.html       # Prévia individual da moto
    └── motocash_pro_planejamento_financeiro_metas.html # Prévia individual de metas
```

---

## 📄 Licença

Desenvolvido por **Leo Lemos** sob a licença [MIT](LICENSE).
