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
myTerminal = "urxvtcd"

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
        img   = ["Gimp","Gimp-2.8"]
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

  -- Spawn the launcher using command specified by myLauncher.
  [ ((modMask, xK_Return), spawn myLauncher)

  -- Close focused window, but not other copies of it.
  , ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
  , ((modMask, xK_c), kill)

  -- Minimize
  -- , ((modMask,                 xK_n), withFocused minimizeWindow)
  -- , ((modMask .|. controlMask, xK_n), sendMessage RestoreNextMinimizedWin)

  -- Toggle topbar
  , ((modMask,                 xK_g), sendMessage $ ToggleGap U)
  -- Cycle through the available layout algorithms.
  , ((modMask,                 xK_space), sendMessage NextLayout)
  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. controlMask, xK_space), setLayout $ XMonad.layoutHook conf)
  -- Resize viewed windows to the rorrect size.
  , ((modMask .|. controlMask, xK_r), refresh)
  -- Move focus to the next window.
  , ((modMask,                 xK_j), focusDown)
  -- Move focus to the previous window.
  , ((modMask,                 xK_k), focusUp)
  -- Swap the focused window with the next window.
  , ((modMask .|. controlMask, xK_j), windows W.swapDown)
  -- Swap the focused window with the previous window.
  , ((modMask .|. controlMask, xK_k), windows W.swapUp)

  -- Move focus to the master window.
  , ((modMask,                 xK_m), focusMaster)
  -- Swap the focused window and the master window.
  , ((modMask .|. controlMask, xK_m), windows W.swapMaster)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma), sendMessage (IncMasterN 1))
  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period), sendMessage (IncMasterN (-1)))

  -- Shrink/Expand
  , ((modMask, xK_h), sendMessage Shrink)
  , ((modMask, xK_l), sendMessage Expand)
  , ((modMask .|. controlMask, xK_h), sendMessage MirrorShrink)
  , ((modMask .|. controlMask, xK_l), sendMessage MirrorExpand)

  -- Push window back into tiling.
  , ((modMask,                 xK_BackSpace), withFocused $ windows . W.sink)
  , ((modMask .|. controlMask, xK_BackSpace), sinkAll)

  -- Restart xmonad.
  , ((modMask,               xK_q), restart "xmonad" True)
  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
  ]
  ++
  -- mod-[x], Switch to workspace N
  -- mod-shift-[x], Move client to workspace N
  [((m .|. modMask, k), windows $ f i) |
        (i, k) <- zip (XMonad.workspaces conf) [xK_u,xK_i,xK_o,xK_p,xK_7,xK_8,xK_9,xK_0]
      , (f, m) <- [(W.greedyView, 0), (\w -> W.shift w, shiftMask), (\w -> W.greedyView w . W.shift w, controlMask)]]
  ++
  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_Left, xK_Right, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, controlMask)]]


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
