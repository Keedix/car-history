import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onSubmit)
import Task exposing (..)
import Time
import String
-- MAIN


main =
  Browser.element { init = init, update = update, view = view, subscriptions = subscriptions}

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- MODEL


type alias Model =
  { mileage : Int
  , description : String
  , history: List History
  }

type alias History =
    {
        mileage: Int,
        description: String,
        timestamp: Int
    }

init : () -> (Model, Cmd Msg)
init _ = ({ mileage = 0, description = "", history = []}, Cmd.none)



-- UPDATE


type Msg
  = Mileage String
  | Description String
  | Add
  | Cancel
  | Timestamp Time.Posix

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mileage value ->
      case String.toInt value of
        Just number ->
          ({ model | mileage = number }, Cmd.none)
        Nothing ->
            (model, Cmd.none)
    Description desc ->
      ({ model | description = desc }, Cmd.none)
    Add ->
        (model, Task.perform Timestamp Time.now)    
    Timestamp posix ->
        let  
            history = History model.mileage model.description (Time.posixToMillis posix)
            updatedList = history :: model.history
        in
            Debug.log "Submit"
            ({model | history = updatedList, mileage = 0, description = ""}, Cmd.none)
    Cancel ->
        ({model | mileage = 0, description = ""}, Cmd.none)
-- VIEW

viewTableHeader : Html Msg
viewTableHeader = 
    tr[][
        th[][text "Date"],
        th[][text "Repairs"],
        th[][text "Mileage"]
    ]

viewHistoryRows : Model -> List (Html Msg)
viewHistoryRows model = 
    viewTableHeader :: (List.map mapHistoryRows model.history)

mapHistoryRows : History -> Html Msg
mapHistoryRows history =
    tr[][
        td[][text (String.fromInt history.timestamp)],
        td[][text history.description],
        td[][text (String.fromInt history.mileage)]
    ]

view : Model -> Html Msg
view model =
  div[][
    section[id "history"][
        div[class "title"][
            h1[][text "Car History"]
        ],
        table[] (viewHistoryRows model)
    ],
    section[id "add-history-report"][
        Html.form[onSubmit Add][
            div[][
                label[for "mileage"][text "mileage"],
                input[name "mileage", id "mileage", type_ "number", value (String.fromInt model.mileage), onInput Mileage][]
            ],
            div[][
                label[for "repair"][text "repair"],
                textarea[name "repair", id "repair", value model.description, onInput Description][]
            ],
            input[type_ "submit", name "add", id "add", value "add"][],
            input[type_ "button", name "cancel", id "cancel", value "cancel", onClick Cancel][]
        ]
    ]
  ]

