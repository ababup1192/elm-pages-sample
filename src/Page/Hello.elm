module Page.Hello exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Http
import Head
import Head.Seo as Seo
import Html
import Html.Attributes exposing (href)
import OptimizedDecoder as Decoder
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    String


data : DataSource Data
data =
    DataSource.Http.get (Secrets.succeed "http://localhost:8000/world.txt") Decoder.string


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


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "Placeholder - "
    , body = [ Html.a [ href "/" ] [ Html.text <| "SSG: Hello " ++ static.data ] ]
    }
