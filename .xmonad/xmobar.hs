-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config
------------------------------------------------------------------------

-- Solarized colors and borders
--

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

-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config {
    font = "xft:Droid Sans Mono for Powerline:pixelsize=12:antialiase=true:autohinting=true:Regular",
    -- font = "xft:Fantasque Sans Mono:pixelsize=15:antialiase=true:autohinting=true:Bold",
    -- font = "xft:Menlo for Powerline:Regular:pixelsize=13:antialiase=true:autohinting=true",
    -- font = "xft:DejaVu Sans Mono for Powerline:Bold:pixelsize=13:antialiase=true:autohinting=true",
    -- font = "xft:Inconsolata for Powerline:pixelsize=15:antialiase=true:autohinting=true",
    -- font = "xft:FuraMono-Bold Powerline:pixelsize=13",
    , bgColor = "#002b36"
    , fgColor = "#586e75"
    -- , position = TopW L 100
    , position = Static { xpos = 0, ypos = 0, width = 1366, height = 16 }
    -- lowerOnStart = True,
    , commands = [
        Run Weather "YMML" ["-t","<tempC>C <skyCondition>","-L","64","-H","77","-n","#","-h","#839496","-l","#268bd2"] 36000,
        Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#073642","-l","#073642","-n","#073642","-w","3"] 10,
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#586e75ff","-l","#586e75","-n","#b58900"] 10,
        Run Date "%a %b %_d %l:%M" "date" 10,
        Run StdinReader
    ]
    , sepChar = "%"
    , alignSep = "}{"
    , template = "%StdinReader% }{ %multicpu%   %memory%   <fc=#839496>%date%</fc>   %YMML%"
}
