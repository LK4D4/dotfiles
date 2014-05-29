--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import Data.Monoid
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.LayoutHints
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.Cursor
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "st -e tmux"
myBrowser       = "google-chrome-stable"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1:main","2:www","3:jabber","4:code"] ++ map show[5..9]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts $ layoutHints $ tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [className =? "Google-chrome-stable"          --> doF (W.shift "2:www")]

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
myStartupHook = setDefaultCursor xC_left_ptr <+> spawnOnce myBrowser <+> spawnOnce myTerminal <+> spawnOnce "gpg-agent --daemon --use-standard-socket --default-cache-ttl 28800"


-- Colors
myBaseColor0   = "#657b83"
myBaseColor00  = "#839496"
myBaseColor01  = "#93a1a1"
myBaseColor02  = "#eee8d5"
myBaseColor03  = "#fdf6e3"
myBaseColor1   = "#586e75"
myBaseColor2   = "#073642"
myBaseColor3   = "#002b36"
myYellow       = "#b58900"
myOrange       = "#cb4b16"
myRed          = "#dc322f"
myMagenta      = "#d33682"
myViolet       = "#6c71c4"
myBlue         = "#268bd2"
myCyan         = "#2aa198"
myGreen        = "#859900"

-- Normal
myFgNormal = myBaseColor02
myBgNormal = myBaseColor3

-- Focus
myFgFocus  = myBaseColor03
myBgFocus  = myBaseColor1

--Urgent
myFgUrgent = myBaseColor3
myBgUrgent = myRed

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = myBaseColor3
myFocusedBorderColor = myBaseColor1

myXPConfig = defaultXPConfig{ position = Top
                            , font     = "xft:Terminus-10"
                            , bgColor  = myBgNormal
                            , fgColor  = myFgNormal
                            , bgHLight = myBgFocus
                            , fgHLight = myFgFocus
                            }

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor myFgNormal myBgFocus . wrap "[" "]"
                , ppUrgent  = xmobarColor myFgUrgent myBgUrgent
                , ppTitle   = xmobarColor myGreen ""}
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad =<< statusBar myBar myPP toggleStrutsKey (withUrgencyHook NoUrgencyHook $ defaults)

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
    `additionalKeysP`
    [ ("M-p", shellPrompt myXPConfig)
    , ("M-S-d", spawn myBrowser)
    , ("<XF86ScreenSaver>", spawn "slock")
    , ("<XF86AudioLowerVolume>", spawn "amixer -q -c 0 sset Master 5%- unmute")
    , ("<XF86AudioRaiseVolume>", spawn "amixer -q -c 0 sset Master 5%+ unmute")
    , ("<XF86AudioMute>", spawn "amixer -q set Master toggle")
    , ("<XF86Launch1>", spawn "systemctl hibernate")
    ]

