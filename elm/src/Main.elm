module Main exposing (main)

import Array
import Browser
import Browser.Navigation as Nav
import Bytes exposing (Bytes)
import Element exposing (..)
import Element.Background as Back
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import File exposing (File)
import File.Select as Select
import Task
import Url


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


lorem n =
    List.foldr (++) "" (List.repeat n lorem25)



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
    , active_story : Int
    , name : String
    , email : String
    , other : String
    , resName : String
    , resume : Maybe Bytes
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url 0 "" "" "" "" Nothing
    , Cmd.none
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Select Int
    | SetName String
    | SetEmail String
    | SetOther String
    | ResumeRequested
    | ResumeSelected File
    | ResumeLoaded Bytes


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

        Select idx ->
            ( { model | active_story = idx }
            , Cmd.none
            )

        SetName str ->
            ( { model | name = str }
            , Cmd.none
            )

        SetEmail str ->
            ( { model | email = str }
            , Cmd.none
            )

        SetOther str ->
            ( { model | other = str }
            , Cmd.none
            )

        ResumeRequested ->
            ( model
            , Select.file [ "application/pdf" ] ResumeSelected
            )

        ResumeSelected file ->
            ( model
            , Task.perform ResumeLoaded (File.toBytes file)
            )

        ResumeLoaded content ->
            ( { model | resume = Just content }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


inv =
    rgba 0.0 0.0 0.0 0.0


offWhite =
    rgba (233 / 255) (233 / 255) (228 / 255) 0.5


white =
    rgba 1.0 1.0 1.0 1.0


darkGrey =
    rgba (81 / 255) (81 / 255) (77 / 255) 0.1


darkerGrey =
    rgba (81 / 255) (81 / 255) (77 / 255) 1.0


lightGreen =
    rgba (90 / 255) (196 / 255) (136 / 255) 1.0


green =
    rgba (86 / 255) (188 / 255) (130 / 255) 1.0


darkGreen =
    rgba (51 / 255) (85 / 255) (79 / 255) 1.0


hide n =
    el [ transparent True ] (text <| String.repeat n " ")


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
    row [ width fill, paddingXY 35 35, spacing 35, Font.size 32 ]
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
    row [ width fill, paddingXY 35 35, spaceEvenly, Back.color darkGrey ]
        [ link [ alignTop, height fill ]
            { url = "/home"
            , label =
                image [ alignTop, height (px 50) ]
                    { src = "/assets/f7_logo.png"
                    , description = "Family 7 Logo and Link"
                    }
            }
        , column [ alignTop, spacing 4 ]
            [ fheader "Contact"
            , flink "Press Inquiries" "mailto:press@family7foundations.com"
            , flink "Get Family7 in Your State" "mailto:expand@family7foundations.com"
            ]
        , column [ alignTop, spacing 4 ]
            [ fheader "Data"
            , flink "Family Progression" "/data"
            ]
        , column [ alignTop, spacing 4 ]
            [ fheader "Admin"
            , flink "Teachers" "/teachers"
            , flink "Reports" "/admin"
            ]
        , column [ alignTop, spacing 4 ]
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
                    home

                "/mission" ->
                    mission

                "/stories" ->
                    stories model

                "/careers" ->
                    careers model

                _ ->
                    home
    in
    { title = "Family 7 Foundations"
    , body =
        [ layout []
            (column [ width fill, Back.color offWhite ]
                [ --el [] (Url.toString model.url |> text),
                  navbar (String.dropLeft 1 model.url.path)
                , page
                , footer
                ]
            )
        ]
    }



-- PAGES


home : Element Msg
home =
    column [ width fill, paddingXY 35 50, spacing 75 ]
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


msBack =
    image [ width fill, height fill ]
        { src = "/assets/wtrm1.jpg"
        , description = "A watercolor painting background"
        }


msBullet =
    row [ width fill, height fill, spacing 35 ]
        [ el [ alignLeft, Font.size 100, Font.light, Font.color green ] (text ">")
        , paragraph [ centerX, Font.size 30 ] [ text lorem25 ]
        ]


msFront =
    column [ width fill, paddingXY 35 50, spacing 60 ]
        [ el [ width fill ] (text "")
        , paragraph [ alignLeft, Font.size 60, Font.semiBold, width (fill |> maximum 600) ]
            [ text "At Family 7 we "
            , el [ Font.heavy, Font.color green ] (text "reunite")
            , text ", "
            , el [ Font.heavy, Font.color green ] (text "maintain")
            , text ", and "
            , el [ Font.heavy, Font.color green ] (text "build")
            , text " one family at a time"
            ]
        , hide 0
        , hide 0
        , msBullet
        , msBullet
        , msBullet
        , msBullet
        , msBullet
        , msBullet
        ]


mission : Element Msg
mission =
    image [ width fill, inFront msFront ]
        { src = "/assets/wtrm1.jpg"
        , description = "A watercolor painting background"
        }


story_imgs =
    Array.fromList [ "/assets/family_st1.jpeg", "/assets/family_st2.jpeg", "/assets/family_st3.jpg", "/assets/family_st4.jpg" ]


story_titles =
    Array.fromList [ "Family ABC", "Family DEF", "Family GHI", "Family JKL" ]


story_cont =
    Array.fromList [ lorem 16, lorem 14, lorem 12, lorem 18 ]


storyDot idx activeIdx =
    let
        color =
            if idx == activeIdx then
                lightGreen

            else
                darkerGrey
    in
    el
        [ width (px 15)
        , height (px 15)
        , Border.width 2
        , Border.rounded 15
        , Border.color darkerGrey
        , Back.color color
        , mouseOver [ Border.color darkerGrey, Back.color lightGreen ]
        , Events.onClick (Select idx)
        , pointer
        ]
        none


storyDots activeIdx =
    row [ centerX, padding 15, spacing 15 ]
        [ storyDot 0 activeIdx
        , storyDot 1 activeIdx
        , storyDot 2 activeIdx
        , storyDot 3 activeIdx
        ]


greenLine =
    el
        [ centerX
        , width (px 300)
        , height (px 4)
        , Back.color lightGreen
        , Border.color lightGreen
        , Border.width 4
        , Border.rounded 4
        , moveDown 15.0
        ]
        none


stories : Model -> Element Msg
stories model =
    let
        src =
            Maybe.withDefault "" (Array.get model.active_story story_imgs)

        title =
            Maybe.withDefault "" (Array.get model.active_story story_titles)

        content =
            Maybe.withDefault "" (Array.get model.active_story story_cont)
    in
    column [ width fill, paddingEach { bottom = 50, top = 0, left = 0, right = 0 }, spacing 50 ]
        [ image [ width fill, height (px 350), below (storyDots model.active_story) ]
            { src = src
            , description = "A picture of a family"
            }
        , el [ centerX, Font.size 60, Font.semiBold, below greenLine ] (text title)
        , paragraph [ centerX, paddingXY 300 0 ] [ text content ]
        ]


input_name model =
    Input.text []
        { onChange = SetName
        , text = model.name
        , placeholder = Just <| Input.placeholder [ Font.italic ] (text "Enter your name")
        , label = Input.labelBelow [] (text "Name")
        }


input_form msg typedtext holdertext labeltext =
    Input.text []
        { onChange = msg
        , text = typedtext
        , placeholder = Just <| Input.placeholder [ Font.italic ] (text holdertext)
        , label = Input.labelAbove [] (text labeltext)
        }


input_multi msg typedtext holdertext labeltext =
    Input.multiline []
        { onChange = msg
        , text = typedtext
        , placeholder = Just <| Input.placeholder [ Font.italic ] (text holdertext)
        , label = Input.labelAbove [] (text labeltext)
        , spellcheck = True
        }


careers : Model -> Element Msg
careers model =
    column [ width fill, spacing 50, paddingXY 35 50 ]
        [ paragraph [ centerX, Font.size 60, Font.semiBold ]
            [ text "Join our team of committed teachers, and help save our families" ]
        , row [ width fill, spaceEvenly ]
            [ column [ width (fill |> maximum 600), padding 35, spacing 25, Back.color darkGrey, Border.width 5, Border.rounded 10, Border.color darkerGrey ]
                [ input_form SetName model.name "Enter your name..." "Name"
                , input_form SetEmail model.email "Enter your email..." "Email"
                , input_multi SetOther model.other "Any other information you'd like..." "Extra Info"
                , Input.button
                    [ padding 15, Border.width 5, Border.rounded 10, Border.color darkerGrey ]
                    { onPress = Just ResumeRequested
                    , label = text "Upload Resume"
                    }
                ]
            ]
        ]
