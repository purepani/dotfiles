-- Imports.
import XMonad
import XMonad.Util.Ungrab
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S
import qualified Data.Map as M
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Hooks.EwmhDesktops

import XMonad.Wallpaper

-- The main function.
main = do 
	setRandomWallpaper ["$HOME/Pictures/Wallpapers"]
	barConfig <- statusBar myBar myPP toggleStrutsKey myConfig 
	xmonad $ ewmh $ docks barConfig {handleEventHook = handleEventHook def <+>   fullscreenEventHook}


-- xmonad =<< docks =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP {ppCurrent = xmobarColor "#429942" "" . wrap "<" ">"}

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Search bar settings
xpc :: XPConfig
xpc = defaultXPConfig { bgColor  = "black"
                      , fgColor  = "grey"
                      , promptBorderWidth = 0
                      , position = Bottom
                      , height   = 15
                      , historySize = 256 
	              , font = "xft:DejaVu Sans Condensed-8"}


myManageHook = composeAll 
    [className =? "kicad" --> doFloat
     , className =? "eeschema" --> doFloat
     , className =? "pcbnew" --> doFloat
    , manageDocks
    ]

-- Main configuration, override the defaults to your liking.
myConfig = defaultConfig {terminal = "konsole" 
                         , workspaces = ["web","code", "reading","irc"] ++ map show [5..9]
			 , manageHook = myManageHook <+> manageHook defaultConfig
                         , modMask = mod4Mask}
                        `additionalKeysP`
			mykeys

-- Keybindings
mykeys= [("M-s " ++ a, b) | (a,b) <- search]
        ++[("M-S-z", spawn "xscreensaver-command -lock")]
      where searchSite = S.promptSearchBrowser xpc "firefox"
            search =[("g", searchSite S.google)
                     ,("h", searchSite S.hoogle)
                     ,("a", searchSite S.amazon)
                     ,("i", searchSite S.imdb)
                     ,("y", searchSite S.youtube)
                     ,("w", searchSite S.wikipedia)]
