import XMonad hiding (Tall)
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.GridSelect
import XMonad.Actions.PhysicalScreens
--import XMonad.Actions.SpawnOn
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ScreenCorners
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.DwmStyle
import XMonad.Layout.HintedGrid
import XMonad.Layout.HintedTile
import XMonad.Layout.IM
import XMonad.Layout.Spacing
import XMonad.Layout.Maximize
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Reflect
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Circle
import qualified XMonad.Layout.Grid as G
import qualified XMonad.StackSet as W
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run(spawnPipe,runInTerm)
import qualified Data.Map as M
import Data.List
import Data.Maybe (listToMaybe)
import Data.Ratio ((%))
import System.IO
import System.Exit

-- helper functions ----------------------------------------------------------

named s = renamed [Replace s]

myFont s = "xft:Terminus:size=" ++ (show s) ++ ":antialias=true"
--myFont s = "xft:DejaVu Sans Mono:size=" ++ (show s) ++ ":antialias=true"
--myRegularFont s = "-*-terminus-medium-r-*-*-" ++ (show s) ++ "-*-*-*-*-*-*-*"

infixr 0 ~>
(~>) :: a -> b -> (a, b)
(~>) = (,)

roleName = stringProperty "WM_WINDOW_ROLE"

-- scratchpads ---------------------------------------------------------------

scratchpads = 
    [ NS "Term" execterm findterm manageterm
    , NS "mixer" (exectermcommand mixer) (findtermcommand mixer) managemixer
    , NS "music" (exectermcommand ncmpc) (findtermcommand ncmpc) managencmpc 
    ]
  where
    execterm = "urxvtc +sb -name scratchpadterm"
    findterm = resource =? "scratchpadterm"
    manageterm = customFloating $ W.RationalRect l t w h
        where h = 0.45
              w = 0.5 
              t = (1 - h)*0.6
              l = (1 - w)/2
    exectermcommand c = "urxvtc +sb -name " ++ c ++ " -e " ++ c
    findtermcommand c = resource =? c
    mixer = "alsamixer"
    managemixer = customFloating $ W.RationalRect l t w h
        where h = 0.4
              w = 0.5
              t = 0.08
              l = 0.2
    ncmpc = "ncmpcpp"
    managencmpc = customFloating $ W.RationalRect l t w h
        where h = 0.35
              w = 0.4
              t = 0.1
              l = 0.15
   

-- manage hook ---------------------------------------------------------------

myManageHook = namedScratchpadManageHook scratchpads <+> composeAll
    [ className =? "Wicd-client.py"     --> doFloat
    , className =? "Volwheel"           --> doFloat
    , className =? "collapse"           --> doFloat
    , className =? "Vncviewer"          --> doFloat
	, className =? "MPlayer"		    --> doFloat
	, className =? "mplayer2"		    --> doFloat
	, className =? "Gnuplot"		    --> doFloat
    , className =? "Pidgin"             --> doF (W.shift $ myWorkspaces !! 6)
    , className =? "Skype"              --> doF (W.shift $ myWorkspaces !! 6)
    , className =? "Chromium"           --> doF (W.shift $ myWorkspaces !! 1)
	, fmap ("OpenGL" `isInfixOf`) title --> doFloat
	, fmap ("Figure" `isInfixOf`) title --> doFloat
	, fmap ("MATLAB" `isInfixOf`) title --> doF (W.shift $ myWorkspaces !! 7)
	, fmap ("Editor" `isInfixOf`) title --> doF (W.shift $ myWorkspaces !! 7) 
    ]
    <+> composeOne [ isFullscreen -?> doFullFloat ]

	--, className =? "com-mathworks-util-PostVMInit" --> doF (W.shift "8")

{-
    where
        unfloat = ask >>= doF . W.sink
        tbirdfloat = doRectFloat (W.RationalRect l t w h)
        where
            h = 0.85
            w = 0.6
            t = (1-h)*0.9
            l = (1-w)*0.5
-}

-- layouts -------------------------------------------------------------------

myLayout = avoidStruts 
        $ onWorkspace (myWorkspaces !! 1) full
        $ onWorkspace (myWorkspaces !! 6) pidginLayout
        $ normLayout 
  where
    layouts = rtall ||| ltall ||| mtall 
    normLayout = layouts ||| full ||| circ ||| grid

    pidginLayout = named "[p]" $ withIM (18/100) (Role "buddy_list") (titleDeco $ smartBorders $ spacing 8 G.Grid)

    circ = named "[O]" (titleDeco $ Circle)
    grid = named "[+]" (titleDeco $ smartBorders $ G.Grid)
    full = named "[M]" (noBorders $ Full)

    mtall = named "==" (titleDeco $ maximize  
                $ smartBorders $ hintedTile Wide)

    tall = maximize $ smartBorders $ smartSpacing 1 $ hintedTile Tall
    ltall = named "[]=" $ titleDeco tall
    rtall = named "=[]" $ titleDeco $ reflectHoriz tall

    hintedTile = HintedTile nmaster delta ratio TopLeft
      where 
        nmaster    = 1
        ratio      = 1/2
        delta      = 3/100

    titleDeco = dwmStyle shrinkText myDWConfig
      where
        myDWConfig = defaultTheme 
            { activeColor         = "#122f5a"
            , activeBorderColor   = "#122f5a"
            , activeTextColor     = "#c5ccdc"
            , inactiveColor       = "#122f5a"
            , inactiveBorderColor = "#122f5a"
            , inactiveTextColor   = "#7789ae"
            , urgentColor         = "#122f5a"
            , urgentBorderColor   = "#122f5a"
            , urgentTextColor     = "#d029ff"
            , fontName            = myFont 8
            , decoHeight          = 17
            }


-- key bindings --------------------------------------------------------------

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  [ (modm .|. shiftMask, xK_Return)   ~>   spawn $ XMonad.terminal conf
  , (modm, xK_p)                  	  ~>   dmenuexec
  , (modm .|. shiftMask, xK_c)        ~>   kill
  , (modm, xK_space)                  ~>   sendMessage NextLayout
  , (modm .|. shiftMask, xK_space)    ~>   resetLayout
  , (modm, xK_n)                      ~>   refresh
  , (modm, xK_Tab)                    ~>   windows W.focusDown
  , (modm, xK_j)                      ~>   windows W.focusDown
  , (modm, xK_k)                      ~>   windows W.focusUp  
  , (modm, xK_Return)                 ~>   windows W.swapMaster
  , (modm .|. shiftMask, xK_j)        ~>   windows W.swapDown  
  , (modm .|. shiftMask, xK_k)        ~>   windows W.swapUp    
  , (modm, xK_h)                      ~>   sendMessage Shrink
  , (modm, xK_l)                      ~>   sendMessage Expand
  , (modm, xK_t)                      ~>   sinkWindow
  , (modm, xK_comma)                  ~>   sendToScreen 0
  , (modm, xK_period)                 ~>   sendToScreen 1
  , (mod4Mask, xK_comma)    		  ~>   sendMessage (IncMasterN 1)
  , (mod4Mask, xK_period)   		  ~>   sendMessage (IncMasterN (-1))
  , (modm .|. shiftMask, xK_q)        ~>   io (exitWith ExitSuccess)
  , (mod4Mask, xK_q)                  ~>   xmonadReload
  , (modm, xK_grave)                  ~>   toggleScratch "Term"
  , (modm, xK_a)                      ~>   toggleScratch "mixer"
  , (modm, xK_z)                      ~>   toggleScratch "music"
  , (modm, xK_bracketright)           ~>   vgaoff
  , (modm, xK_bracketleft)            ~>   vgaon 
  , (modm, xK_backslash)              ~>   toggleMax
  , (modm, xK_g)                      ~>   openGridSelect
  , (modm, xK_m)                      ~>   viewEmptyWorkspace
  , (modm .|. shiftMask,  xK_m)       ~>   tagToEmptyWorkspace --Conflict with mutt
  -- My keys --------------------------------------------------------
  , (modm, xK_s)                      ~>   swapScreens
  , (modm .|. shiftMask, xK_b)		  ~>   spawn "chromium" 
  , (modm .|. shiftMask, xK_h)		  ~>   runInTerm "+sb" "htop"
  , (modm .|. shiftMask, xK_n)		  ~>   runInTerm "+sb" "ncmpcpp"
  , (modm .|. shiftMask, xK_u)		  ~>   runInTerm "+sb" "mutt"
  , (modm .|. shiftMask, xK_i)		  ~>   runInTerm "+sb" "irssi"
  --, (modm .|. shiftMask, xK_g)		  ~>   runInTerm "+sb" "finch"
  --, (mod4Mask .|. shiftMask, 0xff13)    ~>   runInTerm "+sb" "sudo acpitool -s"
  --, (mod4Mask .|. shiftMask, xK_z)	  ~>   spawn "xscreensaver-command -lock"
  --, (mod4Mask .|. shiftMask, xK_m)	  ~>   spawn "matlab -nosplash -desktop"
  , (modm, xK_Print)				  ~>   spawn "scrot"
  , (0, xK_Print)					  ~>   runInTerm "+sb" "screenfetch -s"
  , (0, 0x1008ff13)					  ~>   spawn "amixer set PCM 2dB+"
  , (0, 0x1008ff11)		  			  ~>   spawn "amixer set PCM 2dB-"
  , (0, 0x1008ff12)				  	  ~>   spawn "amixer set Master toggle"
  , (0, 0x1008ff14)					  ~>   spawn "mpc toggle"
  , (0, 0x1008ff15)					  ~>   spawn "mpc stop"
  , (0, 0x1008ff17)					  ~>   spawn "mpc next"
  , (0, 0x1008ff16)					  ~>   spawn "mpc prev"
  , (0, 0x1008ffb2)					  ~>   spawn "mpc toggle" -- Eject on HHKB
  ] 
    ++ 
  [((m .|. modm, k), windows $ f i)
   | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
   , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]   ++
  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
   | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
   , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    where
      dmenuexec = spawn $ "exe=`dmenu_run -b -i -nb black -nf grey " 
                        ++ "-sb blue -sf white -fn \"" ++ (myFont 16) 
                        ++ "\"` && eval \"exec $exe\"" 
      vgaon = spawn $ "xrandr --output LVDS1 --auto " 
                        ++ "--output DP1 --auto --left-of LVDS1"
      vgaoff = spawn "xrandr --output DP1 --off"
      xmonadReload = spawn "xmonad --recompile; xmonad --restart"
      toggleScratch = namedScratchpadAction scratchpads 
      toggleMax = withFocused (sendMessage.maximizeRestore) 
      openGridSelect = goToSelected $ myGSConfig myGSColorizer 
      resetLayout = setLayout $ XMonad.layoutHook conf
      sinkWindow = withFocused $ windows . W.sink
      swapScreens = do
          screen <- gets (listToMaybe . W.visible . windowset)
          whenJust screen $ windows . W.greedyView . W.tag . W.workspace

        
-- start hook ----------------------------------------------------------------

myStartHook = do
    addScreenCorner SCLowerRight (goToSelected $ myGSConfig myGSColorizer )
    setWMName "LG3D"

-- gridselect theme ----------------------------------------------------------

myGSConfig colorizer = (buildDefaultGSConfig colorizer) 
    { gs_cellheight = 40
    , gs_cellwidth = 200
    , gs_cellpadding = 20
    , gs_font = myFont 8
    }

myGSColorizer = colorRangeFromClassName
                      (0x20,0x20,0xAA) -- lowest inactive bg
                      (0x20,0xAA,0x20) -- highest inactive bg
                      black            -- active bg
                      white            -- inactive fg
                      white            -- active fg
   where black = minBound
         white = maxBound


-- workspaces ----------------------------------------------------------------

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

-- main ----------------------------------------------------------------------

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar -x 0" 
  xmproc2 <- spawnPipe "xmobar -x 1" 
  xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
    { borderWidth        = 0 --used to be 1, 0 makes go away
    , normalBorderColor  = "#122f5a" -- old value "#122f5a", -- "#dddddd" = gray
    , focusedBorderColor = "#1f1f1f" -- old value "#880000", -- "#0a9dff" = light blue
    , terminal           = "urxvtc"
    , modMask            = mod4Mask 
	, workspaces		 = myWorkspaces
    , keys               = myKeys
    , manageHook         = manageDocks <+> myManageHook <+> manageHook defaultConfig
    , layoutHook         = myLayout
    , logHook            = 
            dynamicLogWithPP xmobarPP
               { ppOutput = \msg -> do
                    hPutStrLn xmproc msg
                    hPutStrLn xmproc2 msg
               , ppTitle = xmobarColor "#81aeff" "" . shorten 145
               , ppUrgent = xmobarColor "red" "" . wrap " " " " . xmobarStrip
               , ppCurrent = xmobarColor "white" "#1c488a" . wrap " " " "
               , ppVisible = xmobarColor "#81aeff" "" . wrap " " " "
               , ppHidden = wrap " " " "
               , ppHiddenNoWindows = xmobarColor "#444444" "" . wrap " " " "
               , ppSep = "  |  "
               , ppSort = fmap (. namedScratchpadFilterOutWorkspace) $ ppSort xmobarPP
               }
    , handleEventHook    = screenCornerEventHook <+> fullscreenEventHook
    , startupHook        = myStartHook 
    } 
