module Page.Index exposing (Data, Model, Msg, page)

import Browser.Navigation
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html
import Html.Attributes exposing (href)
import Http
import Page exposing (PageWithState, StaticPayload)
import Pages.Manifest exposing (DisplayMode(..))
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Shared
import View exposing (View)


type alias Model =
    { str : String }


type Msg
    = GotWorld (Result Http.Error String)


type alias RouteParams =
    {}


page : PageWithState RouteParams Data Model Msg
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState
            { init = init
            , update = update
            , view = view
            , subscriptions = subscriptions
            }


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init _ _ _ =
    ( { str = "loading" }, Http.get { url = "http://localhost:8000/world.txt", expect = Http.expectString GotWorld } )


update :
    PageUrl
    -> Maybe Browser.Navigation.Key
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> Msg
    -> Model
    -> ( Model, Cmd Msg )
update _ _ _ _ msg _ =
    case msg of
        GotWorld result ->
            case result of
                Ok fullText ->
                    ( { str = fullText }, Cmd.none )

                Err _ ->
                    ( { str = "failed" }, Cmd.none )


subscriptions : Maybe PageUrl -> RouteParams -> Path -> Model -> Sub Msg
subscriptions _ _ _ _ =
    Sub.none


data : DataSource Data
data =
    DataSource.succeed ()



-- DataSource.succeed "world"


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ m _ =
    { title = "Placeholder - " ++ m.str
    , body = [ Html.a [ href "/hello" ] [ Html.text <| "CSR: Hello " ++ m.str ] ]
    }
