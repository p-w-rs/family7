module Main exposing (main)

import Array
import Browser
import Browser.Navigation as Nav
import Debug exposing (log)
import Element exposing (..)
import Element.Background as Back
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Email exposing (isValid)
import File exposing (File)
import File.Select as Select
import Http
import MyUtils exposing (..)
import Task
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
    , active_story : Int
    , name : String
    , email : String
    , other : String
    , resName : String
    , resume : Maybe File
    , error : Maybe Bool
    , stuff : Maybe String
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url 0 "" "" "" "" Nothing Nothing Nothing
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
    | ResumeLoaded File
    | Upload
    | Uploaded (Result Http.Error String)


upload : File.File -> String -> String -> String -> Cmd Msg
upload file name email other =
    let
        url =
            if other == "" then
                "http://127.0.0.1:8000/new_candidate" ++ "/" ++ name ++ "/" ++ email ++ "/" ++ "!"

            else
                "http://127.0.0.1:8000/new_candidate" ++ "/" ++ name ++ "/" ++ email ++ "/" ++ other
    in
    Http.post
        { url = url
        , body = Http.fileBody file
        , expect = Http.expectString Uploaded
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    if url.path == "/admin" || url.path == "/teachers" then
                        ( model, Nav.load (Url.toString url) )

                    else
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
            , Select.file [ "application/pdf" ] ResumeLoaded
            )

        ResumeLoaded file ->
            ( { model | resName = File.name file, resume = Just file }
            , Cmd.none
            )

        Upload ->
            let
                validForm =
                    not (model.name == "" || model.resName == "") && isValid model.email
            in
            case ( validForm, model.resume ) of
                ( True, Just resume ) ->
                    ( model, upload resume model.name model.email model.other )

                _ ->
                    ( { model | error = Just True }, Cmd.none )

        Uploaded result ->
            case result of
                Ok str ->
                    ( { model | stuff = Just str, error = Just False, name = "", email = "", other = "", resName = "", resume = Nothing }, Cmd.none )

                Err err ->
                    case err of
                        Http.BadUrl url ->
                            ( { model | stuff = Just url, error = Just True }, Cmd.none )

                        Http.Timeout ->
                            ( { model | stuff = Just "timeout", error = Just True }, Cmd.none )

                        Http.NetworkError ->
                            ( { model | stuff = Just "network error", error = Just True }, Cmd.none )

                        Http.BadStatus _ ->
                            ( { model | stuff = Just "bad status", error = Just True }, Cmd.none )

                        Http.BadBody _ ->
                            ( { model | stuff = Just "bad body", error = Just True }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


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
            , flink "Teachers" "http://127.0.0.1:8000/teachers"
            , flink "Reports" "http://127.0.0.1:8000/admin"
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
                [ -- el [] (Maybe.withDefault "nothing" model.stuff |> text)
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


email_form msg typedtext holdertext labeltext =
    Input.email []
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


selectedFile name file =
    case file of
        Nothing ->
            el [] none

        Just _ ->
            el [ moveLeft 15, padding 10 ] (text name)


submitMessage error =
    case error of
        Nothing ->
            el [] none

        Just bool ->
            case bool of
                False ->
                    el [ moveLeft 15, padding 10, Font.color lightGreen ] (text "Submission Success!")

                True ->
                    el [ moveLeft 15, padding 10, Font.color red, Font.alignLeft ] (text "Submission Error...\nCheck Form And Try Again.")


careers : Model -> Element Msg
careers model =
    column [ width fill, spacing 50, paddingXY 35 50 ]
        [ paragraph [ centerX, Font.size 60, Font.semiBold ]
            [ text "Join our team of committed teachers, and help save our families" ]
        , row [ width fill, spaceEvenly ]
            [ column [ width (fill |> maximum 600), padding 35, spacing 25, Back.color darkGrey, Border.width 5, Border.rounded 10, Border.color darkerGrey ]
                [ input_form SetName model.name "Enter your name..." "Name (Required)"
                , email_form SetEmail model.email "Enter your email..." "Email (Required)"
                , input_multi SetOther model.other "Any other information you'd like..." "Extra Info (Optional)"
                , el [ centerX, width (px 450), Border.color lightGreen, Border.width 2, Border.rounded 4 ] none
                , row [ width fill, spacing 50, centerX ]
                    [ Input.button
                        [ centerX, Font.center, width (px 200), padding 15, Border.width 5, Border.rounded 10, Border.color darkerGrey, below <| selectedFile model.resName model.resume ]
                        { onPress = Just ResumeRequested
                        , label = text "Upload Resume"
                        }
                    , Input.button
                        [ centerX, Font.center, width (px 200), padding 15, Border.width 5, Border.rounded 10, Border.color darkerGrey, below <| submitMessage model.error ]
                        { onPress = Just Upload
                        , label = text "Submit Form"
                        }
                    ]
                , hide 0
                ]
            ]
        ]
