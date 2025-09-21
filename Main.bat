<# ::
@echo off
setlocal enableDelayedExpansion

:: Variables ofuscadas
set "x1=V"
set "x2=Delete"
set "x3=Home"
set "x4=[38;5;92m"
set "x5="

title !x5!
set /a x6=0
goto x7

:x7
call :x8 "OldVoidA" "Void v1.4.2 randomization" "2" "12 14"
call :x8 "OldVoidB" "Void v1.4.2 randomization" "2" "17 19"
call :x8 "SineA" "Randomization using Sine Waves [91m(Experimental)[0m" "2" "13 15"
call :x8 "BasicA" "Basic randomization [91m(NOT RECOMMENDED)[0m" "2" "10 12"
call :x8 "BasicB" "Basic randomization [91m(NOT RECOMMENDED)[0m" "2" "18 20"
call :x8 "ClickPlayer" "Click player" "1" "clicks.txt"
goto x9

:x10
cls
echo [?25l!x4! __   __   _    _ 
echo  \ \ / /__(_)__^| ^|
echo   \ V / _ \ / _` ^|
echo    \_/\___/_\__,_^| [0mlite 1.0
echo.
goto :eof

:x9
call :x10

echo Num  Profile[31GDescription
echo ==================================================
for /l %%a in (1,1,!x6!) do (
	echo %%a.[6G!x11[%%a]![31G!x11[%%a]_x12! [!x11[%%a]_x13!]
)
echo.

goto x14

:x14
set /p "x15=[?25h> "
if "!x15!"=="!x16!" goto x14
set "x16=!x15!"

set /a x17=0
for %%a in (!x15!) do (
	set "x18[!x17!]=%%a"
	set /a x17+=1
)
set /a x17-=1

if not defined x11[!x18[0]!] (
	echo '!x18[0]!' is not valid.
	goto x14
)

set "x19=x11[!x18[0]!]"
if !x17!==0 (
	call :x20 "!%x19%!" "!%x19%_x13!"
) else if !x17! GEQ !%x19%_x21! (
	set "x22="
	for /l %%a in (1,1,!%x19%_x21!) do (
		if %%a==1 (set "x22=!x18[%%a]!") else (set "x22=!x22! !x18[%%a]!")
	)
	call :x20 "!%x19%!" "!x22!"
) else (
	echo Profile '!%x19%!' requires !%x19%_x21! arguments.
)

goto x14

:x20
call :x10
echo Profile: %~1 [%~2]
call :x23 "%~1" "!x1! !x3! !x2!" "%~2"
goto x9

:x8
set /a x6+=1
set "x11[!x6!]=%~1"
set "x11[!x6!]_x12=%~2"
set "x11[!x6!]_x21=%~3"
set "x11[!x6!]_x13=%~4"

set "x11[%~1]=%~1"
set "x11[%~1]_x12=%~2"
set "x11[%~1]_x21=%~3"
set "x11[%~1]_x13=%~4"

set "x11_%~1=!x6!"
goto :eof

:x23
set "x16="
setlocal
set "x24=%*"
if defined x24 set "x24=!x24:"=\"!"
endlocal & powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -Command "$_ = $input; Invoke-Expression $( '$input = $_; $_ = \"\"; $args = @( &{ $args } %x24% );' + [String]::Join( [char]10, $( Get-Content \"%~f0\" ) ) )"
goto :EOF
#>
$namespace = -join ((65..90) + (97..122) | Get-Random -Count 8 | % {[char]$_})
$class = -join ((65..90) + (97..122) | Get-Random -Count 8 | % {[char]$_})

$code = @"
using System;
using System.IO;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Threading;
using System.Text;

namespace $namespace
{
    public class $class
    {
        [DllImport("user32.dll")]
        private static extern short GetAsyncKeyState(Int32 vKey);
        [DllImport("user32.dll", CharSet = CharSet.Auto, ExactSpelling = true)]
        private static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int GetWindowThreadProcessId(IntPtr handle, out int processId);
        [DllImport("user32.dll", SetLastError = true)]
        static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
        [DllImport("user32.dll")]
        public static extern IntPtr SendMessage(IntPtr hWnd, uint wMsg, UIntPtr wParam, IntPtr lParam);
        [DllImport("kernel32.dll")]
        static extern IntPtr GetConsoleWindow();
        [DllImport("user32.dll")]
        static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        
        public static IntPtr MAKELPARAM(int p, int p2)
        {
            return (IntPtr)((p2 << 16) | (p & 0xFFFF));
        }
        
        private static int GetKey(string s)
        {	
            return (int)Enum.Parse(typeof(ConsoleKey), s);
        }
        
        private static string GetKeyString(string s)
        {
            if (string.IsNullOrEmpty(s)) return string.Empty;
            s = s.ToLower();
            return char.ToUpper(s[0]) + s.Substring(1);
        }
        
        private static long GetSystemTime()
        {
            return DateTimeOffset.Now.ToUnixTimeMilliseconds();
        }
        
        static Random rand;
        static int[] Keybinds = new int[3];
        static bool ClickerEnabled;
        static bool WindowVisible;
        static int StatusRow;
        static IntPtr ConsoleWindow;
        
        private static double GetRandomDouble(double min, double max)
        {
            return rand.NextDouble() * (max - min) + min;
        }
        
        public static void Init(string toggle, string hide, string disable) {
            Keybinds[0] = GetKey(char.ToUpper(toggle[0]) + toggle.Substring(1).ToLower());
            Keybinds[1] = GetKey(char.ToUpper(hide[0]) + hide.Substring(1).ToLower());
            Keybinds[2] = GetKey(char.ToUpper(disable[0]) + disable.Substring(1).ToLower());
            
            ClickerEnabled = true;
            WindowVisible = true;
            
            Console.WriteLine("");
            Console.WriteLine("Controls:");
            Console.WriteLine("  - Toggle: " + toggle);
            Console.WriteLine("  - Hide/Show: " + hide);
            Console.WriteLine("  - Disable: " + disable);
            Console.WriteLine("");
        }
        
        public static void DrawStatus(int row, bool enabled)
        {
            Console.SetCursorPosition(1, row);
            Console.WriteLine("Status: " + (enabled ? "\x1b[92mOn \x1b[0m" : "\x1b[91mOff\x1b[0m"));
        }
        
        public static void DrawStatus(int row, bool enabled, string label, string value)
        {
            Console.SetCursorPosition(1, row);
            Console.WriteLine("Status: " + (enabled ? "\x1b[92mOn \x1b[0m" : "\x1b[91mOff\x1b[0m"));
            Console.SetCursorPosition(1, row + 1);
            Console.WriteLine(label + ": " + value + "   ");
        }
        
        public static bool MinOverMaxCheck(int min, int max)
        {
            if (min > max)
            {
                Console.WriteLine("Min CPS > Max CPS");
                return true;
            }
            return false;
        }
        
        static bool[] KeyStates = new bool[3];
        static bool[] PrevKeyStates = new bool[3];
        
        public static bool CheckBinds() {
            bool ReturnValue = true;
            
            for(int i = 0; i < 3; i++)
            {
                PrevKeyStates[i] = KeyStates[i];
                KeyStates[i] = (GetAsyncKeyState(Keybinds[i]) & 0x8000) != 0;
            }
            
            if (PrevKeyStates[0] != KeyStates[0] && KeyStates[0])
            {
                ClickerEnabled = !ClickerEnabled;
                DrawStatus(StatusRow, ClickerEnabled);
            }
            
            if (PrevKeyStates[1] != KeyStates[1] && KeyStates[1])
            {
                WindowVisible = !WindowVisible;
                ShowWindow(ConsoleWindow, WindowVisible ? 5 : 0);
            }
            
            if (PrevKeyStates[2] != KeyStates[2] && KeyStates[2])
            {
                ClickerEnabled = false;
                DrawStatus(StatusRow, ClickerEnabled);
                if (!WindowVisible) ShowWindow(ConsoleWindow, 5);
                ReturnValue = false;
            }
            
            return ReturnValue;
        }
        
        public static void Basic(string[] args)
        {
            bool running = true;
            StatusRow = Console.CursorTop;
            
            int minCPS = Int32.Parse(args[4]);
            int maxCPS = Int32.Parse(args[5]);
            if (MinOverMaxCheck(minCPS, maxCPS)) return;
            DrawStatus(StatusRow, ClickerEnabled);
            
            bool ButtonState = false;
            long NextClickTime = 0;
            
            while (running)
            {
                IntPtr foreground = GetForegroundWindow();
                IntPtr mcWindow = FindWindow("LWJGL", null);
                
                if (ClickerEnabled && (GetAsyncKeyState(1) & 0x8000) != 0)
                {
                    if (mcWindow == foreground)
                    {
                        if (SendMessage(foreground, 0x0084, UIntPtr.Zero, 
                            MAKELPARAM(Cursor.Position.X, Cursor.Position.Y)) == (IntPtr)1)
                        {
                            long now = GetSystemTime();
                            if (now >= NextClickTime)
                            {
                                if (ButtonState) 
                                    SendMessage(foreground, 0x0202, UIntPtr.Zero, 
                                        MAKELPARAM(Cursor.Position.X, Cursor.Position.Y));
                                else 
                                    SendMessage(foreground, 0x0201, (UIntPtr)0x0001, 
                                        MAKELPARAM(Cursor.Position.X, Cursor.Position.Y));
                                
                                ButtonState = !ButtonState;
                                int delay = rand.Next(500 / maxCPS, 500 / minCPS);
                                NextClickTime = now + delay;
                            }
                        }
                    }
                }
                else 
                {
                    ButtonState = false;
                }
                
                if (!CheckBinds()) running = false;
                Thread.Sleep(1);
            }
        }
        
        public static void OldVoid(string[] args)
        {
            bool running = true;
            StatusRow = Console.CursorTop;
            
            int minCPS = Int32.Parse(args[4]);
            int maxCPS = Int32.Parse(args[5]);
            if (MinOverMaxCheck(minCPS, maxCPS)) return;
            DrawStatus(StatusRow, ClickerEnabled);
            
            while (running)
            {
                IntPtr foreground = GetForegroundWindow();
                IntPtr mcWindow = FindWindow("LWJGL", null);
                
                if (ClickerEnabled && (GetAsyncKeyState(1) & 0x8000) != 0)
                {
                    if (mcWindow == foreground)
                    {
                        if (SendMessage(foreground, 0x0084, UIntPtr.Zero, 
                            MAKELPARAM(Cursor.Position.X, Cursor.Position.Y)) == (IntPtr)1)
                        {
                            if (rand.Next(1, 6) == 2)
                            {
                                if (rand.Next(1, 6) <= 2) 
                                    Thread.Sleep(rand.Next(1000 / maxCPS, 1000 / minCPS) - rand.Next(8, 32) >> 1);
                                else 
                                    Thread.Sleep(rand.Next(1000 / maxCPS, 1000 / minCPS) >> 1);
                            }
                            else
                            {
                                SendMessage(foreground, 0x0201, (UIntPtr)0x0001, 
                                    MAKELPARAM(Cursor.Position.X, Cursor.Position.Y));
                                
                                if (rand.Next(1, 6) <= 2) 
                                    Thread.Sleep(rand.Next(1000 / maxCPS, 1000 / minCPS) - rand.Next(8, 32) >> 1);
                                else 
                                    Thread.Sleep(rand.Next(1000 / maxCPS, 1000 / minCPS) >> 1);
                                    
                                SendMessage(foreground, 0x0202, UIntPtr.Zero, 
                                    MAKELPARAM(Cursor.Position.X, Cursor.Position.Y));
                                
                                if (rand.Next(1, 6) <= 2) 
                                    Thread.Sleep(rand.Next(1000 / maxCPS, 1000 / minCPS) - rand.Next(8, 32) >> 1);
                                else 
                                    Thread.Sleep(rand.Next(1000 / maxCPS, 1000 / minCPS) >> 1);
                            }
                        }
                    }
                }
                
                if (!CheckBinds()) running = false;
                Thread.Sleep(1);
            }
        }
        
        public static void Sine(string[] args) 
        {
            bool running = true;
            StatusRow = Console.CursorTop;
            
            int minCPS = Int32.Parse(args[4]);
            int maxCPS = Int32.Parse(args[5]);
            if (MinOverMaxCheck(minCPS, maxCPS)) return;
            
            long lastTime = 0;
            long now = 0;
            long diff = 0;
            long lastDelay = 0;
            
            long spike = 0;
            long drop = 0;
            long lastEvent = -15;
            double sinX = 0;
            
            DrawStatus(StatusRow, ClickerEnabled);
            
            while (running)
            {
                IntPtr foreground = GetForegroundWindow();
                IntPtr mcWindow = FindWindow("LWJGL", null);
                
                if (ClickerEnabled && (GetAsyncKeyState(1) & 0x8000) != 0)
                {
                    if (mcWindow == foreground)
                    {
                        if (lastTime == 0) {
                            lastTime = GetSystemTime();
                        } else {
                            now = GetSystemTime();
                            diff = (now - lastTime) >> 1;
                            diff -= lastDelay;
                            lastTime = now;
                            
                            if (drop > 0) drop--;
                            if (spike > 0) spike--;
                            
                            if (lastEvent > 0) {
                                if (rand.Next(0, 100 / (int)lastEvent) == 0) {
                                    spike = 25;
                                    lastEvent = -20;
                                } else if (rand.Next(0, 100 / (int)lastEvent) == 0) {
                                    drop = 50;
                                    lastEvent = -30;
                                }
                            }
                            
                            double minDelay = 1000.0 / minCPS;
                            if (spike > 0) minDelay -= GetRandomDouble(1, 15);
                            
                            double maxDelay = 1000.0 / maxCPS;
                            if (drop > 0) maxDelay += GetRandomDouble(1, 15);
                            
                            double avg = (maxDelay + minDelay) / 2;
                            double halfDiff = (minDelay - maxDelay) / 2;
                            double delay = Math.Sin(sinX) * halfDiff + avg;
                            sinX += GetRandomDouble(GetRandomDouble(0.03, 0.1), GetRandomDouble(0.69, 1.24));
                            
                            if (SendMessage(foreground, 0x0084, UIntPtr.Zero, 
                                MAKELPARAM(Cursor.Position.X, Cursor.Position.Y)) == (IntPtr)1)
                            {
                                lastDelay = ((int)delay >> 1) - diff;
                                if (lastDelay < 0) lastDelay = 0;
                                
                                SendMessage(foreground, 0x0201, (UIntPtr)0x0001, 
                                    MAKELPARAM(Cursor.Position.X, Cursor.Position.Y));
                                Thread.Sleep((int)lastDelay);
                                SendMessage(foreground, 0x0202, UIntPtr.Zero, 
                                    MAKELPARAM(Cursor.Position.X, Cursor.Position.Y));
                                Thread.Sleep((int)lastDelay);
                            }
                            lastEvent++;
                        }
                    }
                }
                
                if (!CheckBinds()) running = false;
                Thread.Sleep(1);
            }
        }
        
        public static void ClickPlayer(string[] args) 
        {
            bool running = true;
            List<int> clickTimes = new List<int>();
            StatusRow = Console.CursorTop;
            
            if (File.Exists(args[4]))
            {
                foreach(string line in File.ReadLines(args[4]))
                {
                    if(int.TryParse(line, out int time) && time > 0)
                        clickTimes.Add(time);
                }
            }
            else
            {
                Console.WriteLine("File not found: {0}", args[4]);
                return;
            }
            
            if (clickTimes.Count < 50)
            {
                Console.WriteLine("Not enough data in: {0}", args[4]);
                return;
            }
            
            bool resetPoint = false;
            int currentIndex = rand.Next(1, clickTimes.Count / 4);
            long nextClick = 0;
            
            DrawStatus(StatusRow, ClickerEnabled, "Start Point", currentIndex);
            
            while (running)
            {
                IntPtr foreground = GetForegroundWindow();
                IntPtr mcWindow = FindWindow("LWJGL", null);
                
                if (ClickerEnabled && (GetAsyncKeyState(1) & 0x8000) != 0)
                {
                    if (mcWindow == foreground)
                    {
                        if (SendMessage(foreground, 0x0084, UIntPtr.Zero, 
                            MAKELPARAM(Cursor.Position.X, Cursor.Position.Y)) == (IntPtr)1)
                        {
                            resetPoint = true;
                            long now = GetSystemTime();
                            if (now >= nextClick)
                            {
                                SendMessage(foreground, 0x0201, (UIntPtr)0x0001, 
                                    MAKELPARAM(Cursor.Position.X, Cursor.Position.Y));
                                SendMessage(foreground, 0x0202, UIntPtr.Zero, 
                                    MAKELPARAM(Cursor.Position.X, Cursor.Position.Y));
                                
                                if (currentIndex == clickTimes.Count - 1)
                                    currentIndex = rand.Next(1, clickTimes.Count / 4);
                                else
                                    currentIndex++;
                                
                                nextClick = now + clickTimes[currentIndex];
                            }
                        }
                    }
                }
                else if (resetPoint)
                {
                    resetPoint = false;
                    currentIndex = rand.Next(1, clickTimes.Count / 4);
                    DrawStatus(StatusRow, ClickerEnabled, "Start Point", currentIndex);
                    nextClick = 0;
                    Thread.Sleep(1);
                }
                else
                {
                    Thread.Sleep(1);
                }
                
                if (!CheckBinds()) running = false;
            }
        }

        public static void Main()
        {
            rand = new Random();
            ConsoleWindow = GetConsoleWindow();
            string argStr = "$args";
            string[] args = argStr.Split(' ');
            string profile = args[0];
            
            Init(args[1], args[2], args[3]);
            
            switch(profile)
            {
                case "BasicA":
                case "BasicB":
                    Basic(args);
                    break;
                case "OldVoidA":
                case "OldVoidB":
                    OldVoid(args);
                    break;
                case "SineA":
                    Sine(args);
                    break;
                case "ClickPlayer":
                    ClickPlayer(args);
                    break;
                default:
                    Console.WriteLine("Profile error");
                    break;
            }
        }
    }
}
"@

$assemblies = ("System.Windows.Forms", "System.Drawing")
Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $code -Language CSharp
iex "[$namespace.$class]::Main()"
