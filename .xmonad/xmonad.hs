-- xmonad config used by Vic Fryzel
-- Author: Vijtkc Fryzel
-- http://github.com/vicfryzel/xmonad-config

import System.IO
import System.Exit
import Control.Monad (liftM, join)
import Data.IORef
import Data.List
import XMonad
import XMonad.Actions.CycleWindows
import XMonad.Actions.Navigation2D
import qualified XMonad.Actions.FlexibleResize as F
import XMonad.Actions.WithAll
import XMonad.Layout.ResizableTile
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
import XMonad.Layout.BoringWindows
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.Named
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Actions.UpdatePointer
import Control.Monad (liftM2)
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

myNormalBorderColor  = base2
myFocusedBorderColor = base3
xmobarTitleColor = base01
xmobarUrgentColor = orange
xmobarCurrentWorkspaceColor = blue
myBorderWidth = 0
windowOpacity = 0.80 :: Rational
opacityStep = 0.05
myLauncher = "$(yeganesh -x -- -fn 'xft:Droid Sans Mono for Powerline:pixelsize=13:antialiase=true:autohinting=true:Regular' -nb '" ++ base3 ++ "' -nf '" ++ base02 ++ "' -sb '" ++ base01 ++ "' -sf '" ++ orange ++ "')"

------------------------------------------------------------------------
-- Terminal
myTerminal = "urxvtr"

------------------------------------------------------------------------
-- Workspaces - all right hand keys for easier selection
myWorkspaces = ["trm","txt","fle","web","med","img","doc","tor"]

------------------------------------------------------------------------
-- Window rules
myManageHook = composeAll . concat $
  [
      [ resource  =? "desktop_window"     --> doIgnore ]
    , [ className =? "stalonetray"        --> doIgnore ]
    , [ className =? x --> doFloat         | x <- float]
    , [ className =? x --> viewShift "web" | x <- web  ]
    , [ className =? x --> viewShift "med" | x <- med  ]
    , [ className =? x --> viewShift "img" | x <- img  ]
    , [ className =? x --> viewShift "doc" | x <- doc  ]
    , [ className =? x --> viewShift "tor" | x <- tor  ]
    , [ (className =? "Gimp" <&&> fmap (x `isSuffixOf`) role) --> doFloat | x <- gimp]
    -- , [ isFullscreen --> (doF W.focusDown <+> doFullFloat)]
  ]
  where role  = stringProperty "WM_WINDOW_ROLE"
        viewShift = doF . liftM2 (.) W.greedyView W.shift
        web   = ["chromium", "Google-chrome", "Firefox", "Karma - Google Chrome"]
        med   = ["Vlc", "Clementine", "Skype"]
        doc   = ["libreoffice", "libreoffice-writer", "libreoffice-calc"]
        img   = ["Gimp"]
        tor   = ["Nicotine.py", "Torrent Options", "Transmission-gtk","Hamster","Googleearth-bin"]
        float = ["rgl", "R-x11", "stalonetray", "gnome-calculator", "File Operation Progress", "viewnior"]
        gimp  = ["gimp-toolbox", "gimp-dock"]

------------------------------------------------------------------------
-- Layouts-
myLayout = mkToggle (single FULL) (vert ||| horiz)
  where
     tiled = \name mw -> named name . boringWindows . minimize . avoidStruts $ ResizableTall mw delta ratio []
     vert  = tiled "vert" vertmasterwindows 
     horiz = tiled "horz" horizmasterwindows 

     -- The default number of windows in the master pane
     vertmasterwindows = 1
     horizmasterwindows = 2
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 5/100

------------------------------------------------------------------------
-- Key bindings
myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

  -- Spawn the launcher using command specified by myLauncher.
  [ ((modMask, xK_Return), spawn myLauncher)

  -- Minimize
  , ((modMask,                 xK_n), withFocused minimizeWindow)
  , ((modMask .|. controlMask, xK_n), sendMessage RestoreNextMinimizedWin)
  -- Maximize
  , ((modMask, xK_backslash), withFocused (sendMessage . maximizeRestore))

  -- Close focused window, but not other copies of it.
  , ((modMask, xK_c), kill)

  -- Rotate windows
  , ((modMask                , xK_bracketleft),  rotUnfocusedUp)
  , ((modMask                , xK_bracketright), rotUnfocusedDown)
  , ((modMask .|. controlMask, xK_bracketleft),  rotFocusedUp)
  , ((modMask .|. controlMask, xK_bracketright), rotFocusedDown)


  , ((modMask, xK_s), sendMessage ToggleStruts)
  , ((modMask, xK_m), sendMessage $ Toggle FULL)
  -- Cycle through the available layout algorithms.
  , ((modMask,                 xK_space), sendMessage NextLayout)
  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. controlMask, xK_space), setLayout $ XMonad.layoutHook conf)
  -- Resize viewed windows to the correct size.
  , ((modMask .|. controlMask, xK_r), refresh) 
  -- Move focus to the next window.
  , ((modMask,                 xK_j), focusDown)
  -- Move focus to the previous window.
  , ((modMask,                 xK_k), focusUp)
  -- Swap the focused window with the next window.
  , ((modMask .|. controlMask, xK_j), windows W.swapDown)
  -- Swap the focused window with the previous window.
  , ((modMask .|. controlMask, xK_k), windows W.swapUp)

  -- -- Move focus to the master window.
  -- , ((modMask,                 xK_m), windows W.focusMaster)
  -- -- Swap the focused window and the master window.
  -- , ((modMask .|. controlMask, xK_m), windows W.swapMaster)

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
  -- ++
  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  -- [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
  --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
  --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings

-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
      ((modMask, button1), (\w -> mouseMoveWindow w))
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
             | otherwise = o + opacityStep

decOpacity :: Rational -> Rational
decOpacity o | o <= 0.0 = 0.0
             | otherwise = o - opacityStep
------------------------------------------------------------------------
-- Startup hook
myStartupHook = do
    spawn "run-once redshift-gtk -l -38.53:145.26 -t 6200:3700"
    spawn "background"
    spawn "tray"


------------------------------------------------------------------------
-- Event hook
myEventHook = minimizeEventHook

------------------------------------------------------------------------
-- Main
main = do
  noFadeSet <- newIORef S.empty
  transSet <- newIORef S.empty
  opacity <- newIORef (windowOpacity)
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ defaults {
    logHook = myLogHook xmproc
              >> liftIO (readIORef opacity)
              >>= myFadeHook noFadeSet transSet
  }
    `additionalKeys`
        [
          -- Silly transparency key commands
           ((mod4Mask .|. controlMask, xK_apostrophe),
            withFocused $ \w -> io (modifyIORef noFadeSet $ toggleFade w)
                             >> io (modifyIORef transSet $ removeFade w) >> refresh )
          , ((mod4Mask .|. controlMask, xK_semicolon),
            withFocused $ \w -> io (modifyIORef transSet $ toggleFade w)
                             >> io (modifyIORef noFadeSet $ removeFade w) >> refresh )
          , ((mod4Mask, xK_apostrophe), liftIO (modifyIORef opacity incOpacity) >> refresh)
          , ((mod4Mask, xK_semicolon), liftIO (modifyIORef opacity decOpacity) >> refresh)
        ]

------------------------------------------------------------------------
-- Config overrides
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    clickJustFocuses   = myClickJustFocuses,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,
    -- hooks, layouts
    layoutHook         = myLayout,
    handleEventHook    = myEventHook,
    manageHook         = manageDocks <+> myManageHook,
    startupHook        = myStartupHook
}
