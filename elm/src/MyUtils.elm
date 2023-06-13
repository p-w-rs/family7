module MyUtils exposing (..)

import Element exposing (el, rgba, text, transparent)


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


red =
    rgba (255 / 255) (87 / 255) (51 / 255) 1.0


hide n =
    el [ transparent True ] (text <| String.repeat n " ")


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
