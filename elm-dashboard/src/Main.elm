module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Time
import Task


-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


-- MODEL

type alias Model =
    { weatherData : WebData WeatherInfo
    , cryptoData : WebData (List CryptoPrice)
    , githubData : WebData GithubStats
    , currentTime : Time.Posix
    , timeZone : Time.Zone
    }

type WebData a
    = NotAsked
    | Loading
    | Success a
    | Failure String

type alias WeatherInfo =
    { city : String
    , temperature : Float
    , description : String
    , humidity : Int
    , icon : String
    }

type alias CryptoPrice =
    { id : String
    , name : String
    , symbol : String
    , currentPrice : Float
    , priceChange24h : Float
    }

type alias GithubStats =
    { publicRepos : Int
    , followers : Int
    , totalStars : Int
    , recentCommits : Int
    }


-- INIT

init : () -> ( Model, Cmd Msg )
init _ =
    ( { weatherData = NotAsked
      , cryptoData = NotAsked
      , githubData = NotAsked
      , currentTime = Time.millisToPosix 0
      , timeZone = Time.utc
      }
    , Cmd.batch
        [ fetchWeatherData
        , fetchCryptoData
        , fetchGithubData
        , Task.perform AdjustTimeZone Time.here
        , Task.perform Tick Time.now
        ]
    )


-- UPDATE

type Msg
    = WeatherReceived (Result Http.Error WeatherInfo)
    | CryptoReceived (Result Http.Error (List CryptoPrice))
    | GithubReceived (Result Http.Error GithubStats)
    | RefreshAllData
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WeatherReceived result ->
            case result of
                Ok data ->
                    ( { model | weatherData = Success data }, Cmd.none )
                
                Err error ->
                    ( { model | weatherData = Failure (httpErrorToString error) }, Cmd.none )

        CryptoReceived result ->
            case result of
                Ok data ->
                    ( { model | cryptoData = Success data }, Cmd.none )
                
                Err error ->
                    ( { model | cryptoData = Failure (httpErrorToString error) }, Cmd.none )

        GithubReceived result ->
            case result of
                Ok data ->
                    ( { model | githubData = Success data }, Cmd.none )
                
                Err error ->
                    ( { model | githubData = Failure (httpErrorToString error) }, Cmd.none )

        RefreshAllData ->
            ( { model 
                | weatherData = Loading
                , cryptoData = Loading
                , githubData = Loading
              }
            , Cmd.batch
                [ fetchWeatherData
                , fetchCryptoData
                , fetchGithubData
                ]
            )

        Tick time ->
            ( { model | currentTime = time }, Cmd.none )

        AdjustTimeZone zone ->
            ( { model | timeZone = zone }, Cmd.none )


-- HTTP

fetchWeatherData : Cmd Msg
fetchWeatherData =
    let
        url = "https://api.openweathermap.org/data/2.5/weather?q=São%20Paulo,BR&appid=3eeb17be1582281e5391c9a9c98d91b7&units=metric"
    in
    Http.get
        { url = url
        , expect = Http.expectJson WeatherReceived weatherDecoder
        }

fetchCryptoData : Cmd Msg
fetchCryptoData =
    let
        url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=5&page=1"
    in
    Http.get
        { url = url
        , expect = Http.expectJson CryptoReceived (Decode.list cryptoDecoder)
        }

fetchGithubData : Cmd Msg
fetchGithubData =
    let
        url = "https://api.github.com/users/octocat"
    in
    Http.get
        { url = url
        , expect = Http.expectJson GithubReceived githubDecoder
        }


-- DECODERS

weatherDecoder : Decode.Decoder WeatherInfo
weatherDecoder =
    Decode.map5 WeatherInfo
        (Decode.field "name" Decode.string)
        (Decode.at ["main", "temp"] Decode.float)
        (Decode.at ["weather"] (Decode.index 0 (Decode.field "description" Decode.string)))
        (Decode.at ["main", "humidity"] Decode.int)
        (Decode.at ["weather"] (Decode.index 0 (Decode.field "icon" Decode.string)))

cryptoDecoder : Decode.Decoder CryptoPrice
cryptoDecoder =
    Decode.map5 CryptoPrice
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "symbol" Decode.string)
        (Decode.field "current_price" Decode.float)
        (Decode.field "price_change_percentage_24h" Decode.float)

githubDecoder : Decode.Decoder GithubStats
githubDecoder =
    Decode.map4 GithubStats
        (Decode.field "public_repos" Decode.int)
        (Decode.field "followers" Decode.int)
        (Decode.succeed 0) -- Placeholder para stars totais
        (Decode.succeed 0) -- Placeholder para commits recentes


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (5 * 60 * 1000) Tick -- Atualiza a cada 5 minutos


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "dashboard" ]
        [ header []
            [ h1 [] [ text "Dashboard de Dados" ]
            , div [ class "last-update" ]
                [ text ("Última atualização: " ++ formatTime model.timeZone model.currentTime)
                , button [ onClick RefreshAllData, class "refresh-btn" ]
                    [ text "🔄 Atualizar" ]
                ]
            ]
        , main_ [ class "dashboard-grid" ]
            [ weatherCard model.weatherData
            , cryptoCard model.cryptoData  
            , githubCard model.githubData
            ]
        ]

weatherCard : WebData WeatherInfo -> Html Msg
weatherCard weatherData =
    div [ class "card weather-card" ]
        [ div [ class "card-header" ]
            [ h2 [] [ text "🌤️ Clima" ]
            ]
        , div [ class "card-content" ]
            [ case weatherData of
                NotAsked ->
                    text "Carregando..."
                
                Loading ->
                    div [ class "loading" ] [ text "Carregando dados do clima..." ]
                
                Success weather ->
                    div []
                        [ h3 [] [ text weather.city ]
                        , div [ class "temperature" ] 
                            [ text (String.fromFloat weather.temperature ++ "°C") ]
                        , p [] [ text weather.description ]
                        , p [] [ text ("Umidade: " ++ String.fromInt weather.humidity ++ "%") ]
                        ]
                
                Failure error ->
                    div [ class "error" ] [ text ("Erro: " ++ error) ]
            ]
        ]

cryptoCard : WebData (List CryptoPrice) -> Html Msg
cryptoCard cryptoData =
    div [ class "card crypto-card" ]
        [ div [ class "card-header" ]
            [ h2 [] [ text "₿ Criptomoedas" ]
            ]
        , div [ class "card-content" ]
            [ case cryptoData of
                NotAsked ->
                    text "Carregando..."
                
                Loading ->
                    div [ class "loading" ] [ text "Carregando preços..." ]
                
                Success cryptos ->
                    div [ class "crypto-list" ]
                        (List.map cryptoItem cryptos)
                
                Failure error ->
                    div [ class "error" ] [ text ("Erro: " ++ error) ]
            ]
        ]

cryptoItem : CryptoPrice -> Html Msg
cryptoItem crypto =
    div [ class "crypto-item" ]
        [ div [ class "crypto-info" ]
            [ strong [] [ text crypto.name ]
            , small [] [ text (" (" ++ String.toUpper crypto.symbol ++ ")") ]
            ]
        , div [ class "crypto-price" ]
            [ span [] [ text ("$" ++ formatPrice crypto.currentPrice) ]
            , span [ class (if crypto.priceChange24h >= 0 then "positive" else "negative") ]
                [ text (formatPercentage crypto.priceChange24h ++ "%") ]
            ]
        ]

githubCard : WebData GithubStats -> Html Msg
githubCard githubData =
    div [ class "card github-card" ]
        [ div [ class "card-header" ]
            [ h2 [] [ text "🐙 GitHub" ]
            ]
        , div [ class "card-content" ]
            [ case githubData of
                NotAsked ->
                    text "Carregando..."
                
                Loading ->
                    div [ class "loading" ] [ text "Carregando dados do GitHub..." ]
                
                Success github ->
                    div [ class "github-stats" ]
                        [ div [ class "stat" ]
                            [ strong [] [ text (String.fromInt github.publicRepos) ]
                            , span [] [ text "Repositórios" ]
                            ]
                        , div [ class "stat" ]
                            [ strong [] [ text (String.fromInt github.followers) ]
                            , span [] [ text "Seguidores" ]
                            ]
                        ]
                
                Failure error ->
                    div [ class "error" ] [ text ("Erro: " ++ error) ]
            ]
        ]


-- UTILITIES

httpErrorToString : Http.Error -> String
httpErrorToString error =
    case error of
        Http.BadUrl url ->
            "URL inválida: " ++ url
        
        Http.Timeout ->
            "Timeout da requisição"
        
        Http.NetworkError ->
            "Erro de rede"
        
        Http.BadStatus status ->
            "Erro HTTP: " ++ String.fromInt status
        
        Http.BadBody message ->
            "Erro ao processar resposta: " ++ message

formatTime : Time.Zone -> Time.Posix -> String
formatTime zone time =
    let
        hour = String.fromInt (Time.toHour zone time)
        minute = String.fromInt (Time.toMinute zone time)
        paddedMinute = String.padLeft 2 '0' minute
    in
    hour ++ ":" ++ paddedMinute

formatPrice : Float -> String
formatPrice price =
    String.fromFloat (toFloat (round (price * 100)) / 100)

formatPercentage : Float -> String
formatPercentage percentage =
    let
        rounded = toFloat (round (percentage * 100)) / 100
        sign = if rounded >= 0 then "+" else ""
    in
    sign ++ String.fromFloat rounded