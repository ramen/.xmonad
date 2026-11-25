import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce

myTerminal :: String
myTerminal = "xfce4-terminal"

myBorderWidth :: Dimension
myBorderWidth = 2

-- Tokyo Night palette
myNormalBorderColor, myFocusedBorderColor :: String
myNormalBorderColor  = "#24283b"
myFocusedBorderColor = "#7aa2f7"

-- Launcher: rofi, themed in ~/.xmonad/rofi/config.rasi
myLauncher :: String
myLauncher = "rofi -show drun -config ~/.xmonad/rofi/config.rasi"

mySpacing :: l a -> ModifiedLayout Spacing l a
mySpacing = spacingRaw False (Border 4 4 4 4) True (Border 4 4 4 4) True

myLayout = avoidStruts $ smartBorders $ mySpacing (reflectHoriz tiled ||| Full)
  where
    tiled = Tall 1 (3/100) (1/2)

-- Optional helpers are started only if installed, so the config works as-is.
spawnIfExists :: String -> String -> X ()
spawnIfExists bin cmd = spawnOnce $ "command -v " ++ bin ++ " >/dev/null && " ++ cmd

myStartupHook :: X ()
myStartupHook = do
    spawnIfExists "picom" "picom --config ~/.xmonad/picom/picom.conf -b"
    spawnIfExists "polybar" "polybar -c ~/.xmonad/polybar/config.ini main &"
    spawnOnce "xsetroot -solid '#1a1b26'"

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . docks $ def
    { modMask            = mod4Mask
    , terminal           = myTerminal
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , layoutHook         = myLayout
    , startupHook        = myStartupHook
    } `additionalKeysP`
    [ ("M-p",         spawn myLauncher)
    , ("M-S-[",       sendMessage Expand)
    , ("M-S-]",       sendMessage Shrink)
    , ("<Print>",     spawn "xfce4-screenshooter -f")
    ]
