import XMonad

import XMonad.Actions.Navigation2D
import XMonad.Config
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.FixedColumn
import XMonad.Layout.Spacing
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.MultiToggle

import XMonad.Util.CustomKeys
import XMonad.Util.Run

import Data.List

import MyKeyBindings


main :: IO ()
main = do
  xmobarPipe <- spawnPipe xmobarCommand
  xmonad
    $ myConfig { logHook = dynamicLogWithPP $ myXmobarPP xmobarPipe }

backgroundColor   = "#202020"
middleColor       = "#AEAEAE"
shadedColor       = "#606060"
foregroundColor   = "#9a2bc2"
titleColor        = "#2bc26f"

myConfig = def
  { borderWidth        = 4
  , focusedBorderColor = foregroundColor
  , focusFollowsMouse  = False
  , handleEventHook    = docksEventHook
  , keys               = myKeys
  , layoutHook         = myLayoutHook
  , manageHook         = manageDocks
  , modMask            = mod4Mask
  , normalBorderColor  = middleColor
  , terminal           = "gnome-terminal"
  , workspaces         = [ "上網", "emacs", "終端", "etc" ]
  }

myXmobarPP xmobarPipe = defaultPP
  { ppCurrent         = pad . xmobarColor foregroundColor  ""
  , ppHidden          = pad . xmobarColor middleColor ""
  , ppHiddenNoWindows = pad . xmobarColor shadedColor ""
  , ppLayout          = const ""
  , ppOutput          = hPutStrLn xmobarPipe
  , ppTitle           = titleStyle
  , ppVisible         = pad . xmobarColor middleColor ""
  , ppWsSep           = " "
  }
  where
    titleStyle = xmobarColor titleColor "" . shorten 100 . filterCurly
    filterCurly = filter (not . isCurly)
    isCurly x = x == '{' || x == '}'

xmobarCommand :: String
xmobarCommand =
  intercalate " "
    [ "xmobar"
    , "-d"
    , "-B", stringed backgroundColor
    , "-F", stringed middleColor
    ]
      where stringed x = "\"" ++ x ++ "\""

-- with spacing
myLayoutHook = (spacing 10 $ avoidStruts (tall ||| GridRatio (4/3) ||| Full )) ||| smartBorders Full
                   where tall = Tall 1 (3/100) (1/2)
