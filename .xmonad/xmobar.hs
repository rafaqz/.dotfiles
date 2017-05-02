-- xmobar config

-- Solarized colors and borders, here as reference until

-- Dark
-- base0 = "#657b83ff"
-- base1 = "#586e75ff"
-- base2 = "#073642ff"
-- base3 = "#002b36ff"

-- -- Light
-- base00 = "#839496ff"
-- base01 = "#93a1a1ff"
-- base02 = "#eee8d5ff"
-- base03 = "#fdf6e3ff"

-- yellow = "#b58900ff"
-- orange = "#cb4b16ff"
-- red = "#dc322fff"
-- magenta = "#d33682ff"
-- violet = "#6c71c4ff"
-- blue = "#268bd2ff"
-- cyan = "#2aa198ff"
-- green = "#859900ff"

Config {
    font = "xft:SauceCodePro Nerd Font:pixelsize=12:antialiase=true:autohinting=true:Regular"
    -- font = "xft:Fantasque Sans Mono:pixelsize=12:antialiase=true:autohinting=true",
    -- font = "xft:Menlo for Powerline:Regular:pixelsize=13:antialiase=true:autohinting=true",
    -- font = "xft:DejaVu Sans Mono for Powerline:pixelsize=13:antialiase=true:autohinting=true",
    -- font = "xft:Inconsolata for Powerline:pixelsize=14:antialiase=true:autohinting=true",
    -- font = "xft:FuraMono-Bold Powerline:pixelsize=13",
    , bgColor = "#002b36"
    , fgColor = "#586e75"
    , position = Static { xpos = 0, ypos = 0, width = 1238, height = 16 }
    , commands = [
        Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#174652","-l","#174652","-n","#073642","-w","3"] 10,
        Run Weather "YMML" ["-t","<tempC>C <skyCondition>","-L","64","-H","77","-n","#","-h","#839496","-l","#268bd2"] 36000,
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#586e75ff","-l","#586e75","-n","#b58900"] 10,
        Run Date "%a %b %d  %l:%M" "date" 10,
        Run StdinReader
    ]
    , sepChar = "%"
    , alignSep = "}{"
    , template = "%StdinReader% }{ | %multicpu%   %memory% | <fc=#93a1a1>%date%</fc> | %YMML%"
    , overrideRedirect = True
    , persistent =       True    -- enable/disable hiding (True = disabled)
}
