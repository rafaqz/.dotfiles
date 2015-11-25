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
import XMonad.Layout.Fullscreen
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.Named
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
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
      [ resource  =? "desktop_window" --> doIgnore ]
    , [ className =? "stalonetray"    --> doIgnore ]
    , [ className =? x --> doFloat         | x <- float]
    , [ className =? x --> doShift "web"   | x <- web  ]
    , [ className =? x --> doShift "media" | x <- media]
    , [ className =? x --> doShift "img"   | x <- img  ]
    , [ className =? x --> doShift "doc"   | x <- doc  ]
    , [ className =? x --> doShift "tor"   | x <- tor  ]
    , [ (className =? "Gimp" <&&> fmap (x `isSuffixOf`) role) --> doFloat | x <- gimp]
    -- , [ isFullscreen --> (doF W.focusDown <+> doFullFloat)]
  ]
  where role  = stringProperty "WM_WINDOW_ROLE"
        web   = ["chromium", "Google-chrome", "Firefox", "Karma - Google Chrome"]
        media = ["Vlc", "Clementine", "Skype","Googleearth-bin"]
        doc   = ["libreoffice"]
        img   = ["Gimp"]
        tor   = ["Nicotine.py", "Torrent Options", "Transmission","Hamster"]
        float = ["stalonetray", "gnome-calculator", "File Operation Progress", "gpicview"]
        gimp  = ["gimp-toolbox", "gimp-dock"]

------------------------------------------------------------------------
-- Layouts
myLayout = vert ||| horiz ||| full
  where
     tiled = maximize $ boringWindows $ minimize $ ResizableTall nmaster delta ratio []
     vert  = named "vert" $ avoidStruts $ tiled
     horiz = named "horz" $ avoidStruts $ Mirror tiled
     full  = named "full" $ boringWindows $ minimize $ fullscreenFull Full

     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

data WindowOpacity = Window Rational

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

  -- Cycle through the available layout algorithms.
  , ((modMask,                 xK_space), sendMessage NextLayout)
  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. controlMask, xK_space), setLayout $ XMonad.layoutHook conf)
  -- Resize viewed windows to the correct size.
  , ((modMask .|. controlMask, xK_l), refresh) -- Move focus to the next window.  , ((modMask, xK_Tab), focusDown)

  -- , ((modMask,                 xK_l), windowGo R False)
  -- , ((modMask,                 xK_h), windowGo L False)
  -- , ((modMask,                 xK_k), windowGo U False)
  -- , ((modMask,                 xK_j), windowGo D False)

  -- -- Swap adjacent windows
  -- , ((modMask .|. controlMask, xK_l), windowSwap R False)
  -- , ((modMask .|. controlMask, xK_h), windowSwap L False)
  -- , ((modMask .|. controlMask, xK_k), windowSwap U False)
  -- , ((modMask .|. controlMask, xK_j), windowSwap D False)

  -- Move focus to the next window.
  , ((modMask, xK_j), focusDown)
  -- Move focus to the previous window.
  , ((modMask, xK_k), focusUp)
  -- Swap the focused window with the next window.
  , ((modMask .|. controlMask, xK_j), windows W.swapDown)
  -- Swap the focused window with the previous window.
  , ((modMask .|. controlMask, xK_k), windows W.swapUp)

  -- Move focus to the master window.
  , ((modMask,                 xK_m), windows W.focusMaster)
  -- Swap the focused window and the master window.
  , ((modMask .|. controlMask, xK_m), windows W.swapMaster)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma), sendMessage (IncMasterN 1))
  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period), sendMessage (IncMasterN (-1)))

  -- Shrink/Expand
  , ((modMask, xK_h), sendMessage Shrink)
  , ((modMask, xK_l), sendMessage Expand)
  , ((modMask, xK_apostrophe), sendMessage MirrorShrink)
  , ((modMask, xK_semicolon), sendMessage MirrorExpand)

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
  -- mod-control-shift-[x] @@ Copy client to workspace N
  [((m .|. modMask, k), windows $ f i) |
        (i, k) <- zip (XMonad.workspaces conf) [xK_u,xK_i,xK_o,xK_p,xK_7,xK_8,xK_9,xK_0]
      , (f, m) <- [(W.greedyView, 0), (\w -> W.shift w, shiftMask)]]
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
             | otherwise = o + 0.05

decOpacity :: Rational -> Rational
decOpacity o | o <= 0.0 = 0.0
             | otherwise = o - 0.05
------------------------------------------------------------------------
-- Startup hook
myStartupHook = do
    spawn "tray"
    spawn "background"

------------------------------------------------------------------------
-- Event hook
myEventHook = minimizeEventHook

------------------------------------------------------------------------
-- Main
main = do
  noFadeSet <- newIORef S.empty
  transSet <- newIORef S.empty
  opacity <- newIORef (0.8 :: Rational)
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ defaults {
    logHook = myLogHook xmproc
              >> liftIO (readIORef opacity)
              >>= myFadeHook noFadeSet transSet
  }
    `additionalKeys`
        [
           ((mod4Mask .|. controlMask, xK_period),
          -- Silly transparency key commands
            withFocused $ \w -> io (modifyIORef noFadeSet $ toggleFade w)
                             >> io (modifyIORef transSet $ removeFade w) >> refresh )
          , ((mod4Mask .|. controlMask, xK_comma),
            withFocused $ \w -> io (modifyIORef transSet $ toggleFade w)
                             >> io (modifyIORef noFadeSet $ removeFade w) >> refresh )
          , ((mod4Mask .|. shiftMask, xK_period), liftIO (modifyIORef opacity incOpacity) >> refresh)
          , ((mod4Mask .|. shiftMask, xK_comma), liftIO (modifyIORef opacity decOpacity) >> refresh)
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
