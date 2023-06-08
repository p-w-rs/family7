module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Back
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


inv =
    rgba 0.0 0.0 0.0 0.0


grey =
    rgba (233 / 255) (233 / 255) (228 / 255) 0.5


darkGrey =
    rgba (81 / 255) (81 / 255) (77 / 255) 0.1


lightGreen =
    rgba (90 / 255) (196 / 255) (136 / 255) 1.0


green =
    rgba (86 / 255) (188 / 255) (130 / 255) 1.0


darkGreen =
    rgba (51 / 255) (85 / 255) (79 / 255) 1.0


navlink : String -> String -> Element Msg
navlink name path =
    let
        color =
            if String.toLower name == path then
                lightGreen

            else
                inv
    in
    link
        [ alignRight
        , Border.widthEach { bottom = 2, left = 0, right = 0, top = 0 }
        , Border.color color
        , mouseOver [ Border.color lightGreen ]
        ]
        { url = "/" ++ String.toLower name
        , label = text name
        }


navbar : String -> Element Msg
navbar path =
    row [ width fill, padding 10, spacing 35, Font.size 32 ]
        [ link [ alignLeft ]
            { url = "/home"
            , label =
                image [ height (px 100) ]
                    { src = "/assets/f7_logo.png"
                    , description = "Family 7 Logo and Link"
                    }
            }
        , navlink "Mission" path
        , navlink "Stories" path
        , navlink "Careers" path
        , el [] (text "  ")
        ]


fheader : String -> Element Msg
fheader str =
    el [ alignTop, Font.heavy, Font.size 16, Font.color darkGreen ] (text str)


flink : String -> String -> Element Msg
flink str ln =
    link
        [ alignTop, Font.size 14, Font.color darkGreen, mouseOver [ Font.color lightGreen ] ]
        { url = ln
        , label = text str
        }


footer : Element Msg
footer =
    row [ width fill, padding 35, spaceEvenly, Back.color darkGrey ]
        [ link [ height fill ]
            { url = "/home"
            , label =
                image [ height (px 50) ]
                    { src = "/assets/f7_logo.png"
                    , description = "Family 7 Logo and Link"
                    }
            }
        , column [ height fill, padding 3, spacing 3 ]
            [ fheader "Contact"
            , flink "Press Inquiries" "mailto:press@family7foundations.com"
            , flink "Get Family7 in Your State" "mailto:expand@family7foundations.com"
            ]
        , column [ height fill, padding 3, spacing 3 ]
            [ --fheader "Data",
              flink "Family Progression" "/data"
            ]
        , column [ height fill, padding 3, spacing 3 ]
            [ fheader "Admin"
            , flink "Teachers" "/teachers"
            , flink "Views" "/admin"
            ]
        , column [ height fill, padding 3, spacing 3 ]
            [ fheader "Legal"
            , flink "Site Terms of Use" "/terms"
            , flink "Privacy Policy" "/policy"
            , flink "Security" "/security"
            ]
        ]


view : Model -> Browser.Document Msg
view model =
    let
        page =
            case model.url.path of
                "/" ->
                    home model

                "/mission" ->
                    mission model

                "/stories" ->
                    stories model

                "/careers" ->
                    careers model

                "/teachers" ->
                    teachers model

                "/admin" ->
                    admin model

                _ ->
                    home model
    in
    { title = "Family 7 Foundations"
    , body =
        [ layout [ width fill, height fill, Back.color grey ]
            (column [ width fill, height fill ]
                [ el [] (Url.toString model.url |> text)
                , navbar (String.dropLeft 1 model.url.path)
                , page
                , footer
                ]
            )
        ]
    }



-- PAGES


lorem100 : String
lorem100 =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris viverra elit eget lectus congue, in elementum nisl placerat. Aliquam quis felis est. Donec id quam et nibh posuere molestie. Sed tortor ante, pulvinar non sem at, pulvinar egestas felis. Mauris volutpat quam eu risus mollis finibus nec in erat. Curabitur accumsan nec augue vel interdum. Donec et interdum magna. Pellentesque rutrum lorem dui, eget posuere augue varius ut. Maecenas ac hendrerit ipsum, nec euismod massa. Integer congue dui tincidunt interdum pretium. Suspendisse eleifend est tellus, id semper dolor ultrices vel. Interdum et malesuada fames ac ante ipsum primis in faucibus"


lorem75 : String
lorem75 =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut porta libero ut sapien tempus, at finibus urna volutpat. Nunc erat libero, vulputate sed odio sed, porttitor egestas turpis. Nam efficitur auctor varius. Donec ante libero, feugiat sit amet elit ac, aliquam malesuada nibh. Proin tempor, quam ac mollis dictum, sapien eros pulvinar neque, porta feugiat velit lectus at elit. Fusce cursus purus nibh, a suscipit diam imperdiet sit amet. Integer a felis non velit convallis."


lorem50 : String
lorem50 =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eu vestibulum nisl. Aliquam nec dui sem. Vivamus sit amet purus velit. Morbi sit amet lorem non magna euismod imperdiet quis sed magna. Duis id leo pharetra, elementum libero ut, placerat nisi. Nulla in mauris laoreet, eleifend elit sit amet, porta."


lorem25 : String
lorem25 =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ut molestie risus, eu lacinia justo. Nunc elit nunc, pellentesque quis vestibulum vel, volutpat nec elit."


home : Model -> Element Msg
home model =
    column [ width fill, spacing 75, padding 35 ]
        [ row [ width fill, spacing 50 ]
            [ paragraph [ width fill ]
                [ text lorem25
                , el [ Font.bold ] (text lorem25)
                , text lorem25
                ]
            , image [ width fill, Border.width 10, Border.color darkGreen, Border.rounded 15 ]
                { src = "/assets/family1.jpg"
                , description = "A picture of a happy family"
                }
            ]
        , paragraph [ width fill, Font.size 25 ]
            [ text lorem25 ]
        ]


msBullet =
    row [ width fill, spacing 35 ]
        [ el [ alignLeft, Font.size 100, Font.light, Font.color green ] (text ">")
        , paragraph [ centerX, Font.size 30 ] [ text lorem25 ]
        ]


mission : Model -> Element Msg
mission model =
    column [ width fill, spacing 60, padding 35 ]
        [ paragraph [ alignLeft, Font.size 60, Font.semiBold, width (fill |> maximum 450) ]
            [ text "At Family 7 we "
            , el [ Font.heavy, Font.color green ] (text "reunite")
            , text ", "
            , el [ Font.heavy, Font.color green ] (text "maintain")
            , text ", and "
            , el [ Font.heavy, Font.color green ] (text "build")
            , text " one family at a time"
            ]
        , msBullet
        , msBullet
        , msBullet
        , msBullet
        , msBullet
        , msBullet
        ]


stories : Model -> Element Msg
stories model =
    column [ width fill, padding 35 ]
        [ el [] (text "stories panel")
        ]


careers : Model -> Element Msg
careers model =
    column [ width fill, padding 35 ]
        [ el [] (text "careers panel")
        ]


teachers : Model -> Element Msg
teachers model =
    column [ width fill, padding 35 ]
        [ el [] (text "teacher panel")
        ]


admin : Model -> Element Msg
admin model =
    column [ width fill, padding 35 ]
        [ el [] (text "admin panel")
        ]
