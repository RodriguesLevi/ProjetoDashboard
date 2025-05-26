# ProjetoDashboard

# 📊 Dashboard de Dados em Elm

Um dashboard interativo que exibe dados em tempo real de clima, criptomoedas e GitHub, construído com Elm e design moderno.

## 🚀 Demo e Screenshots

O dashboard apresenta três cards principais:
- **Clima**: Temperatura, umidade e condições climáticas
- **Criptomoedas**: Preços e variações das top 5 moedas
- **GitHub**: Estatísticas de repositórios e seguidores

## 🛠️ Tecnologias Utilizadas

- **Elm 0.19.1** - Linguagem funcional para frontend
- **APIs REST** - OpenWeather, CoinGecko, GitHub
- **CSS3** - Design responsivo com glassmorphism
- **HTML5** - Estrutura semântica

## 📋 Pré-requisitos

```bash
# Instalar Elm
npm install -g elm

# Verificar instalação
elm --version
```

## ⚙️ Configuração das APIs

### 1. OpenWeather API (Clima)
```bash
# 1. Registre-se em: https://openweathermap.org/api
# 2. Obtenha sua API key gratuita
# 3. Substitua "your_api_key" no arquivo Main.elm linha 87
```

### 2. CoinGecko API (Crypto)
```bash
# ✅ Não requer API key
# A API pública é gratuita com rate limit de 50 calls/min
```

### 3. GitHub API
```bash
# ✅ Não requer API key para dados públicos
# Rate limit: 60 requests/hora sem autenticação
# Para mais requests, adicione token de acesso pessoal
```

## 🚀 Instalação e Execução

### Passo 1: Clone e Configure
```bash
# Clone o repositório
git clone <repo-url>
cd elm-dashboard

# Instale dependências do Elm
elm install
```

### Passo 2: Configure APIs
```elm
-- Em src/Main.elm, linha 87, substitua:
url = "https://api.openweathermap.org/data/2.5/weather?q=São%20Paulo,BR&appid=SUA_API_KEY&units=metric"
```

### Passo 3: Compile e Execute
```bash
# Compilar Elm para JavaScript
elm make src/Main.elm --output=main.js

# Servir arquivos (várias opções):

# Opção 1: Servidor Python
python -m http.server 8000

# Opção 2: Servidor Node.js
npx http-server -p 8000

# Opção 3: Live Server (VS Code)
# Instale extensão Live Server e clique "Go Live"
```

### Acesse
```
http://localhost:8000
```

## 📁 Estrutura Detalhada

```
elm-dashboard/
├── elm.json                 # Configuração e dependências
├── src/
│   └── Main.elm            # Aplicação principal (500+ linhas)
├── public/
│   ├── index.html          # HTML estrutural
│   └── styles.css          # Estilos (400+ linhas CSS)
├── main.js                 # Elm compilado (gerado)
└── README.md              # Esta documentação
```

## 🏗️ Arquitetura Elm Explicada

### Model (Estado da Aplicação)
```elm
type alias Model =
    { weatherData : WebData WeatherInfo      -- Estado do clima
    , cryptoData : WebData (List CryptoPrice) -- Estado das cryptos
    , githubData : WebData GithubStats       -- Estado do GitHub
    , currentTime : Time.Posix               -- Hora atual
    , timeZone : Time.Zone                   -- Fuso horário
    }
```

### Update (Lógica de Negócio)
```elm
type Msg
    = WeatherReceived (Result Http.Error WeatherInfo)
    | CryptoReceived (Result Http.Error (List CryptoPrice))
    | GithubReceived (Result Http.Error GithubStats)
    | RefreshAllData
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone
```

### View (Interface do Usuário)
- **Composição funcional** de componentes
- **Estado reativo** - UI atualiza automaticamente
- **Tratamento de loading/error states**

## 🎨 Features Implementadas

### ✅ Core Features
- [x] Três APIs integradas (Clima, Crypto, GitHub)
- [x] Auto-refresh a cada 5 minutos
- [x] Estados de loading e erro
- [x] Design responsivo
- [x] Tema escuro moderno

### ✅ UX/UI Features
- [x] Glassmorphism design
- [x] Animações CSS suaves
- [x] Gradientes e sombras
- [x] Hover effects
- [x] Loading spinners
- [x] Error handling visual

### ✅ Technical Features
- [x] Decoder JSON robusto
- [x] HTTP error handling
- [x] Time management
- [x] Subscription patterns
- [x] Functional composition

## 🔧 Customizações Possíveis

### Adicionar Novas APIs
```elm
-- 1. Definir novo tipo no Model
type alias NewsData = { ... }

-- 2. Adicionar Msg
type Msg = ... | NewsReceived (Result Http.Error NewsData)

-- 3. Implementar fetch e decoder
fetchNewsData : Cmd Msg
newsDecoder : Decode.Decoder NewsData

-- 4. Criar view component
newsCard : WebData NewsData -> Html Msg
```

### Modificar Styling
```css
/* Trocar para tema claro */
body {
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    color: #2d3748;
}

/* Alterar cores dos cards */
.card::before {
    background: linear-gradient(90deg, #ff6b6b, #4ecdc4, #45b7d1);
}
```

### Adicionar Persistência
```elm
-- Usar ports para localStorage
port setStorage : String -> Cmd msg
port getStorage : (String -> msg) -> Sub msg
```

## 🧪 Testes (Opcional)

```bash
# Instalar elm-test
elm install elm-explorations/test

# Criar arquivo de teste
mkdir tests
touch tests/MainTest.elm
```

Exemplo de teste:
```elm
module MainTest exposing (..)
import Test exposing (..)
import Expect

suite : Test
suite =
    describe "Dashboard Tests"
        [ test "Weather decoder works" <|
            \_ ->
                Expect.equal (Ok expectedWeather) (decodeWeather jsonString)
        ]
```

## 🚀 Deploy

### GitHub Pages
```bash
# 1. Compile Elm
elm make src/Main.elm --output=main.js --optimize

# 2. Commit e push
git add .
git commit -m "Deploy dashboard"
git push origin main

# 3. Ativar GitHub Pages nas configurações do repo
```

### Netlify
```bash
# 1. Conectar repo no Netlify
# 2. Build command: elm make src/Main.elm --output=main.js --optimize
# 3. Publish directory: ./
```

### Vercel
```json
// vercel.json
{
  "builds": [
    {
      "src": "src/Main.elm",
      "use": "@vercel/static-build",
      "config": {
        "buildCommand": "elm make src/Main.elm --output=main.js --optimize"
      }
    }
  ]
}
```

## 🐛 Troubleshooting

### Erro: "elm make não encontrado"
```bash
# Reinstalar Elm globalmente
npm uninstall -g elm
npm install -g elm@latest-0.19.1
```

### Erro de CORS nas APIs
```javascript
// Usar proxy em desenvolvimento
// package.json (se usando npm)
{
  "proxy": "https://api.openweathermap.org"
}
```

### Performance Issues
```bash
# Compilar com otimizações
elm make src/Main.elm --output=main.js --optimize

# Minificar CSS
npx cleancss -o styles.min.css styles.css
```

## 📈 Melhorias Futuras

- [ ] **Gráficos interativos** com elm-charts
- [ ] **PWA** com service worker
- [ ] **Dark/Light theme toggle**
- [ ] **Mais APIs** (Stock prices, News)
- [ ] **WebSocket** para dados real-time
- [ ] **Testes unitários** completos
- [ ] **Storybook** para componentes
- [ ] **CI/CD** com GitHub Actions

## 🤝 Contribuições

1. Fork o projeto
2. Crie uma feature branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Add nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🏆 Por que este projeto impressiona em entrevistas?

### Demonstra Conhecimento Técnico
- **Elm Architecture** - Compreensão de arquitetura funcional
- **API Integration** - Múltiplas APIs com error handling
- **JSON Decoders** - Parsing robusto de dados
- **HTTP & Time** - Gerenciamento de requisições e tempo

### Mostra Habilidades de Design
- **UI/UX moderno** - Glassmorphism e animações
- **Responsive design** - Adaptável a todos dispositivos
- **Accessibility** - Contraste e semântica adequados
- **Performance** - Otimizações e loading states

### Evidencia Best Practices
- **Código limpo** - Bem organizado e documentado
- **Error handling** - Tratamento completo de erros
- **TypeScript-like safety** - Sistema de tipos do Elm
- **Functional programming** - Paradigma funcional puro

---

**Desenvolvido com ❤️ em Elm** | [Contato](mailto:seu-email@exemplo.com)