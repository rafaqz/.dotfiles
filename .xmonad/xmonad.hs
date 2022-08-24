-- xmonad config used by Vic Fryzel
-- Author: Vijtkc Fryzel
-- http://github.com/vicfryzel/xmonad-config

import System.IO
import System.Exit
import Control.Monad (liftM, liftM2, join)
import Data.IORef
import Data.List
import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Actions.WithAll
import XMonad.Actions.UpdatePointer
import qualified XMonad.Actions.FlexibleResize as F
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
import XMonad.Hooks.Place
import XMonad.Layout.ResizableTile
import XMonad.Layout.Gaps
import XMonad.Layout.BoringWindows
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.Named
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Hooks.UrgencyHook
import XMonad.Util.NamedWindows
import XMonad.Util.Run
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Util.EZConfig (additionalKeys)
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified Data.Set        as S

------------------------------------------------------------------------
-- Solarized theme

-- Dark
base0   = "#657b83"
base1   = "#586e75"
base2   = "#073642"
base3   = "#002b36"
-- Light
base00  = "#839496"
base01  = "#93a1a1"
base02  = "#eee8d5"
base03  = "#fdf6e3"
-- Colors
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"

myNormalBorderColor         = base3
myFocusedBorderColor        = orange
xmobarTitleColor            = base01
xmobarUrgentColor           = orange
xmobarCurrentWorkspaceColor = blue
myBorderWidth = 0
myWindowOpacity = 0.84 :: Rational
myOpacityStep = 0.02
myLauncher = "$(yeganesh -x -- -fn 'xft:SauceCodePro Nerd Font:pixelsize=12:antialiase=true:autohinting=true:Regular' -nb '" ++ base3 ++ "' -nf '" ++ base01 ++ "' -sb '" ++ base01 ++ "' -sf '" ++ blue ++ "')"

------------------------------------------------------------------------
-- Terminal
myTerminal = "alacritty"

------------------------------------------------------------------------
-- Workspaces - all right hand keys for easier selection
myWorkspaces = ["trm","txt","fle","web","med","img","doc","tor"]

------------------------------------------------------------------------
-- Window rules
myManageHook = composeAll . concat $
  [
      [ resource  =? "desktop_window"     --> doIgnore      ]
    , [ className =? "stalonetray"        --> doIgnore      ]
    , [ className =? "Dunst"              --> doIgnore      ]
    , [ className =? x --> viewShift "web" | x <- web       ]
    , [ className =? x --> viewShift "doc" | x <- doc       ]
    , [ className =? x --> viewShift "med" | x <- med       ]
    , [ className =? x --> viewShift "img" | x <- img       ]
    , [ className =? x --> viewShift "tor" | x <- tor       ]
    , [ className =? x --> doFloat         | x <- floatClasses]
    , [ className =? x --> doFloat         | x <- floatTitles]
    , [ fmap (x `isSuffixOf`) role --> doFloat | x <- floatRoles  ]
    -- , [ isFullscreen --> (doF W.focusDown <+> doFullFloat)]
  ]
  where role  = stringProperty "WM_WINDOW_ROLE"
        viewShift = doF . liftM2 (.) W.greedyView W.shift
        doc   = ["libreoffice", "libreoffice-writer", "libreoffice-calc"]
        web   = ["chromium", "Google-chrome", "Firefox", "Karma - Google Chrome"]
        med   = ["Vlc", "Lollypop"]
        img   = ["Gimp","Gimp-2.10"]
        tor   = ["Nicotine.py", "Torrent Options", "Transmission-gtk","Hamster","Googleearth-bin"]
        floatClasses = ["Dunst", "rgl", "R-x11", "File Operation Progress", "viewnior"]
        floatTitles = ["Export", "Downloads", "Add-ons", "Firefox Preferences"]
        floatRoles  = ["gimp-toolbox", "gimp-dock"]

------------------------------------------------------------------------
-- Layouts-
myLayout = smartBorders . boringWindows $ (vert ||| horiz ||| full)
  where
     vert = named "vert" . gaps [gap] $ ResizableTall masterwindows delta ratio []
     horiz = named "horiz" . gaps [gap] . Mirror $ ResizableTall masterwindows delta ratio []
     full =  named "full" $ Full

     -- The default number of windows in the master pane
     masterwindows = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 2/100
     gap = (U, 16)

------------------------------------------------------------------------
-- Key bindings
myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

10


myAdditionalKeys opacity transSet noFadeSet =
  [ -- Silly transparency key commands
    ((mod4Mask .|. controlMask, xK_apostrophe)
    , withFocused $ \w -> io (modifyIORef noFadeSet $ toggleFade w) >> io (modifyIORef transSet $ removeFade w) >> refresh )
  , ((mod4Mask .|. controlMask, xK_semicolon)
    , withFocused $ \w -> io (modifyIORef transSet $ toggleFade w) >> io (modifyIORef noFadeSet $ removeFade w) >> refresh )
  , ((mod4Mask, xK_apostrophe), liftIO (modifyIORef opacity incOpacity) >> refresh)
  , ((mod4Mask, xK_semicolon), liftIO (modifyIORef opacity decOpacity) >> refresh)
  ]


------------------------------------------------------------------------
-- Mouse bindings

-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ ((modMask, button1), (\w -> mouseMoveWindow w))
  , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
  , ((modMask, button3), (\w -> F.mouseResizeWindow w))
  ]

------------------------------------------------------------------------
-- Status bars and logging
myLogHook dest = dynamicLogWithPP $ defaultPP {
            ppOutput = hPutStrLn dest
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 60
          , ppUrgent = xmobarColor xmobarUrgentColor ""
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = " | "
          }

------------------------------------------------------------------------
-- Fade unfocussed windows
myFadeHook noFadeSet transSet opacity = fadeOutLogHook $ fadeIf (testCondition noFadeSet transSet) opacity
fadeBlacklist = title =? "Call with " <||> className =? "Vlc"

testCondition :: IORef (S.Set Window) -> IORef (S.Set Window) -> Query Bool
testCondition nofadeSet transSet =
    ((liftM not fadeBlacklist <&&> isUnfocused)
    <||> (join . asks $ \w -> liftX . io $ S.member w `fmap` readIORef transSet))
    <&&> (join . asks $ \w -> liftX . io $ S.notMember w `fmap` readIORef nofadeSet)

toggleFade :: Window -> S.Set Window -> S.Set Window
toggleFade w s | S.member w s = S.delete w s
               | otherwise = S.insert w s

removeFade :: Window -> S.Set Window -> S.Set Window
removeFade w s | S.member w s = S.delete w s
               | otherwise = s

incOpacity :: Rational -> Rational
incOpacity o | o >= 1.0 = 1.0
             | otherwise = o + myOpacityStep

decOpacity :: Rational -> Rational
decOpacity o | o <= 0.0 = 0.0
             | otherwise = o - myOpacityStep

------------------------------------------------------------------------
-- Event hook
myEventHook = minimizeEventHook

------------------------------------------------------------------------
-- Placement settings
myPlacement = withGaps (16,0,16,0) (smart (0.5,0.5))

------------------------------------------------------------------------
-- Main
main = do
  noFadeSet <- newIORef S.empty
  transSet <- newIORef S.empty
  opacity <- newIORef (myWindowOpacity)
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"

  xmonad
    $ withUrgencyHook LibNotifyUrgencyHook
    $ defaults
      { logHook = myLogHook xmproc
        >> liftIO (readIORef opacity)
        >>= myFadeHook noFadeSet transSet
  }
    `additionalKeys` myAdditionalKeys opacity transSet noFadeSet

------------------------------------------------------------------------
-- Config overrides
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    clickJustFocuses   = myClickJustFocuses,
    borderWidth        = myBorderWidth,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,
    -- hooks, layouts
    layoutHook         = myLayout,
    handleEventHook    = myEventHook,
    manageHook         = placeHook myPlacement <+> manageDocks <+> myManageHook
}

------------------------------------------------------------------------
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset
        safeSpawn "notify-send" [show name, "workspace " ++ idx]
