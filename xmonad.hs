import XMonad hiding ( (|||) )
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Config.Gnome
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.Run (spawnPipe)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.Reflect
import XMonad.Util.EZConfig
import XMonad.Layout.LayoutCombinators  -- provides |||
import XMonad.Layout.NoBorders
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ICCCMFocus
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.Monoid
import System.IO

main = do
  --sp <- mkSpawner
  xmonad =<< xmobar defaultConfig
        { modMask = mod4Mask -- Use Super instead of Alt
        , manageHook = (className =? "stalonetray" --> doIgnore) <+>
                       manageSpawn <+>
                       manageHook gnomeConfig
        , terminal = "urxvt"
        -- more changes
        , keys = newKeys
        , startupHook = setWMName "LG3D"
        , layoutHook = myLayout
        , logHook = takeTopFocus
        }

myWorkspaces = map show [1..12]
        
newKeys x = M.union (M.fromList (myKeys x)) (keys gnomeConfig x)    

myKeys x =
        [
        -- Gnome/Compiz style keybindings
          ((mod1Mask, xK_Tab), windows W.focusDown)
        , ((mod1Mask .|. shiftMask, xK_Tab), windows W.focusUp)
        , ((mod1Mask, xK_F4), kill)
        -- Launcher
        , ((modMask x, xK_p), shellPromptHere defaultXPConfig)
        , ((mod1Mask, xK_space), shellPromptHere defaultXPConfig)
        -- Gnome switch windows default keybindings
        , ((controlMask .|. mod1Mask,xK_Right), moveTo Next NonEmptyWS)
        , ((controlMask .|. mod1Mask,xK_Left),  moveTo Prev NonEmptyWS)
        , ((controlMask .|. mod1Mask .|. shiftMask, xK_Right),shiftToNext >> nextWS)
        , ((controlMask .|. mod1Mask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
        -- One handed keybindings
        , ((modMask x, xK_x), spawn $ XMonad.terminal x)
        , ((0, xK_F1), windows W.focusDown)
        -- Monitor keybindings
        , ((0, xK_F12), prevScreen)
        ] ++
        -- F1, F2 ... keys to windows
        [((m, k), windows $ f i)
            | (i, k) <- zip myWorkspaces [xK_F2..xK_F10] -- I might get confused by this, if so revert
            , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myLayout = tiled ||| Mirror tiled ||| threecol ||| Full
         where
           -- default tiling algorithm partitions the screen into two panes
           tiled    = Tall nmaster delta ratio
           threecol = ThreeColMid nmaster delta ratio
           -- The default number of windows in the master pane
           nmaster = 1
        
           -- Default proportion of screen occupied by master pane
           ratio   = 1/2
        
           -- Percent of screen to increment by when resizing panes
           delta   = 3/100

            
--myLayout = (tiled |||  reflectTiled ||| Mirror tiled ||| Grid ||| Full)
--    where
--        --Layouts
--        tiled     = smartBorders (ResizableTall 1 (2/100) (1/2) [])
--        reflectTiled = (reflectHoriz tiled)
--        full              = noBorders Full
                                     
    