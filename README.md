# 📊 Dashboard de Dados em Elm

Um dashboard interativo moderno que exibe dados em tempo real de clima, criptomoedas e GitHub, construído com Elm e design glassmorphism.

## 🌐 Demo Online

**🔗 [Ver Demo ao Vivo](https://rodriguesLevi.github.io/ProjetoDashboard/)**

## ✨ Features

### 🌤️ **Card de Clima**
- Temperatura atual de São Paulo
- Condições climáticas em tempo real
- Umidade e descrição do tempo
- Integração com OpenWeather API

### ₿ **Card de Criptomoedas**
- Preços atuais das top 5 criptomoedas
- Variação percentual 24h
- Indicadores visuais de alta/baixa
- Dados da CoinGecko API

### 🐙 **Card do GitHub**
- Estatísticas de repositórios públicos
- Número de seguidores
- Dados da GitHub API

### 🎨 **Design e UX**
- **Tema escuro moderno** com gradientes
- **Glassmorphism effects** nos cards
- **Animações suaves** e hover effects
- **Design totalmente responsivo**
- **Auto-refresh** a cada 5 minutos
- **Loading states** e tratamento de erros

## 🛠️ Tecnologias Utilizadas

### **Frontend**
- **[Elm 0.19.1](https://elm-lang.org/)** - Linguagem funcional para frontend
- **CSS3** - Estilização com glassmorphism e animações
- **HTML5** - Estrutura semântica

### **APIs Integradas**
- **[OpenWeather API](https://openweathermap.org/api)** - Dados meteorológicos
- **[CoinGecko API](https://coingecko.com/api)** - Preços de criptomoedas
- **[GitHub API](https://docs.github.com/en/rest)** - Estatísticas de usuários

### **Deploy**
- **GitHub Pages** - Hospedagem gratuita
- **Live Server** - Desenvolvimento local

## 🚀 Como Executar Localmente

### **Pré-requisitos**
```bash
# Instalar Elm
npm install -g elm

# Verificar instalação
elm --version
```

### **Instalação**
```bash
# 1. Clonar repositório
git clone https://github.com/RodriguesLevi/ProjetoDashboard.git
cd ProjetoDashboard

# 2. Compilar Elm
elm make src/Main.elm --output=main.js

# 3. Servir arquivos
python -m http.server 8000
# OU
npx http-server -p 8000

# 4. Acessar no navegador
# http://localhost:8000
```

### **Configuração da API Key (Opcional)**
```elm
-- No arquivo src/Main.elm, linha 137:
-- Substitua por sua chave da OpenWeather API
url = "https://api.openweathermap.org/data/2.5/weather?q=São%20Paulo,BR&appid=SUA_CHAVE_AQUI&units=metric"
```

## 📁 Estrutura do Projeto

```
ProjetoDashboard/
├── 📄 index.html          # HTML principal
├── 🎨 styles.css          # Estilos CSS (glassmorphism)
├── ⚙️  main.js            # Elm compilado para JavaScript
├── 📂 src/
│   └── 📄 Main.elm        # Código fonte Elm principal
├── 📋 elm.json            # Configurações e dependências
└── 📖 README.md           # Este arquivo
```

## 🏗️ Arquitetura Elm

### **Model (Estado da Aplicação)**
```elm
type alias Model =
    { weatherData : WebData WeatherInfo
    , cryptoData : WebData (List CryptoPrice)
    , githubData : WebData GithubStats
    , currentTime : Time.Posix
    , timeZone : Time.Zone
    }
```

### **Update (Lógica de Negócio)**
```elm
type Msg
    = WeatherReceived (Result Http.Error WeatherInfo)
    | CryptoReceived (Result Http.Error (List CryptoPrice))
    | GithubReceived (Result Http.Error GithubStats)
    | RefreshAllData
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone
```

### **View (Interface do Usuário)**
- Composição funcional de componentes
- Estado reativo - UI atualiza automaticamente
- Tratamento completo de loading/error states

## 📊 Dados Exibidos

### **Clima**
- 🌡️ Temperatura atual (°C)
- 🌤️ Condições climáticas
- 💧 Percentual de umidade
- 📍 Localização (São Paulo, BR)

### **Criptomoedas**
- 💰 Preço atual em USD
- 📈 Variação 24h (%)
- 🏆 Top 5 por market cap
- 🎨 Indicadores visuais de alta/baixa

### **GitHub**
- 📚 Repositórios públicos
- 👥 Número de seguidores
- 📊 Estatísticas em tempo real

## 🎨 Design System

### **Cores Principais**
- `#0c0c0c` - Background base
- `#1a1a2e` - Background gradiente
- `#00d4ff` - Accent azul
- `#5a67d8` - Accent roxo
- `#ed64a6` - Accent rosa

### **Efeitos Visuais**
- **Glassmorphism**: `backdrop-filter: blur(10px)`
- **Gradientes**: Múltiplos gradientes lineares
- **Animações**: Transitions suaves de 0.3s
- **Shadows**: Box-shadows com blur

## 🔧 Scripts Disponíveis

```bash
# Desenvolvimento
elm make src/Main.elm --output=main.js

# Produção (otimizado)
elm make src/Main.elm --output=main.js --optimize

# Servidor local
python -m http.server 8000

# Linter (opcional)
elm-format src/ --yes
```

## 📱 Responsividade

### **Desktop (> 768px)**
- Layout em grid 3 colunas
- Cards lado a lado
- Hover effects completos

### **Tablet (768px - 480px)**
- Layout adaptativo
- Cards empilhados
- Espaçamentos ajustados

### **Mobile (< 480px)**
- Layout single column
- Typography otimizada
- Touch-friendly interactions

## 🌟 Destaques Técnicos

### **Por que Elm?**
- ✅ **Zero Runtime Errors** - Sistema de tipos robusto
- ✅ **Functional Programming** - Código previsível e testável
- ✅ **The Elm Architecture** - Padrão arquitetural sólido
- ✅ **Excellent Error Messages** - Debug facilitado

### **Padrões Implementados**
- **State Management** - Centralizado no Model
- **HTTP Handling** - Tratamento completo de erros
- **JSON Decoding** - Type-safe API parsing
- **Subscriptions** - Auto-refresh reativo
- **Component Architecture** - Funções de view modulares

## 🚀 Deploy e CI/CD

### **GitHub Pages**
- **Auto-deploy** em push para main
- **Custom domain** configurável
- **HTTPS** habilitado por padrão

### **Build Process**
```yaml
# Exemplo de GitHub Actions (futuro)
- name: Build Elm
  run: elm make src/Main.elm --output=main.js --optimize
```

## 🔮 Roadmap Futuro

- [ ] **Gráficos interativos** com elm-charts
- [ ] **PWA** com service worker
- [ ] **Dark/Light theme toggle**
- [ ] **Mais APIs** (Stock prices, News)
- [ ] **WebSocket** para dados real-time
- [ ] **Testes unitários** com elm-test
- [ ] **Docker** containerization

## 🤝 Contribuições

Contribuições são bem-vindas! Por favor:

1. **Fork** o projeto
2. **Crie** uma feature branch (`git checkout -b feature/nova-feature`)
3. **Commit** suas mudanças (`git commit -am 'Add nova feature'`)
4. **Push** para a branch (`git push origin feature/nova-feature`)
5. **Abra** um Pull Request


## 🏆 Sobre o Desenvolvedor

Criado por **[Rodrigues Levi](https://github.com/RodriguesLevi)** como projeto de estudo em **Elm** e **Functional Programming**.

### **Conecte-se:**
- 💼 **LinkedIn**: [Seu LinkedIn](https://linkedin.com/in/seu-perfil)
- 🐙 **GitHub**: [@RodriguesLevi](https://github.com/RodriguesLevi)
- 📧 **Email**: rodrigues101112@gmail.com

---
