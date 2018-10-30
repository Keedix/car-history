import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
  { mileage : Int
  , description : String
  }


init : Model
init = { mileage = 0, description = ""}



-- UPDATE


type Msg
  = Mileage Int
  | Description String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Mileage number ->
      { model | mileage = number }

    Description desc ->
      { model | description = desc }

-- VIEW


view : Model -> Html Msg
view model =
  div[][
    section[id "history"][
        div[class "title"][
            h1[][text "Car History"]
        ],
        table[][
            tr[][
                th[][text "Date"],
                th[][text "Repairs"],
                th[][text "Mileage"]
            ],
            tr[][
                td[][text "21.02.2005"],
                td[][text "Clutch removal and replacement"],
                td[][text "178 895"]
            ]
        ]
    ],
    section[id "add-history-report"][
        Html.form[][
            div[][
                label[for "mileage"][text "mileage"],
                input[name "mileage", id "mileage", type_ "number"][]
            ],
            div[][
                label[for "repair"][text "repair"],
                textarea[name "repair", id "repair"][]
            ],
            input[type_ "submit", name "add", id "add", value "add"][],
            input[type_ "submit", name "cancel", id "cancel", value "cancel"][]
        ]
    ]
  ]

