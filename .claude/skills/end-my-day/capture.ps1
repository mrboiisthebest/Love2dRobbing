# Launches the game, screenshots its window, then closes it.
# Usage: powershell -ExecutionPolicy Bypass -File capture.ps1 -ProjectDir <repo> -OutFile <png> [-WaitSeconds 3]
param(
    [Parameter(Mandatory)] [string] $ProjectDir,
    [Parameter(Mandatory)] [string] $OutFile,
    [int] $WaitSeconds = 3,
    [string] $LovePath = "C:\Program Files\LOVE\love.exe"
)

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class Win {
    public delegate bool EnumProc(IntPtr h, IntPtr p);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr p);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll")] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] public static extern bool ClientToScreen(IntPtr h, ref POINT p);
    [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint flags);
    [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L, T, R, B; }
    [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X, Y; }

    // LÖVE uses SDL, whose game window class is "SDL_app" (skips the debug console window)
    public static IntPtr FindGameWindow(uint pid) {
        IntPtr found = IntPtr.Zero;
        EnumWindows((h, p) => {
            uint wp; GetWindowThreadProcessId(h, out wp);
            var sb = new StringBuilder(64); GetClassName(h, sb, 64);
            if (wp == pid && IsWindowVisible(h) && sb.ToString() == "SDL_app") { found = h; return false; }
            return true;
        }, IntPtr.Zero);
        return found;
    }
}
"@

if (-not (Test-Path $LovePath)) { Write-Error "LOVE not found at $LovePath"; exit 1 }
[Win]::SetProcessDPIAware() | Out-Null

$proc = Start-Process -FilePath $LovePath -ArgumentList "`"$ProjectDir`"" -PassThru
try {
    $hwnd = [IntPtr]::Zero
    for ($i = 0; $i -lt 50 -and $hwnd -eq [IntPtr]::Zero; $i++) {
        Start-Sleep -Milliseconds 200
        if ($proc.HasExited) { Write-Error "Game exited early (crash on startup?)"; exit 2 }
        $hwnd = [Win]::FindGameWindow([uint32]$proc.Id)
    }
    if ($hwnd -eq [IntPtr]::Zero) { Write-Error "Game window not found"; exit 3 }

    [Win]::SetForegroundWindow($hwnd) | Out-Null
    Start-Sleep -Seconds $WaitSeconds
    if ($proc.HasExited) { Write-Error "Game exited while waiting (crash?)"; exit 2 }

    # Capture only the client area (no title bar). PrintWindow with
    # PW_CLIENTONLY | PW_RENDERFULLCONTENT (1 | 2) reads the window itself,
    # so it works even if another window is covering the game.
    # The window can report 0x0 for a moment (e.g. while resizing), so retry
    $r = New-Object Win+RECT
    for ($i = 0; $i -lt 25; $i++) {
        $hwnd = [Win]::FindGameWindow([uint32]$proc.Id)
        [Win]::GetClientRect($hwnd, [ref]$r) | Out-Null
        if (($r.R - $r.L) -gt 0 -and ($r.B - $r.T) -gt 0) { break }
        Start-Sleep -Milliseconds 200
    }
    $w = $r.R - $r.L; $h = $r.B - $r.T
    if ($w -le 0 -or $h -le 0) { Write-Error "Game window has no size (minimized?)"; exit 4 }
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $hdc = $g.GetHdc()
    [Win]::PrintWindow($hwnd, $hdc, 3) | Out-Null
    $g.ReleaseHdc($hdc)
    New-Item -ItemType Directory -Force -Path (Split-Path $OutFile) | Out-Null
    $bmp.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    Write-Output "Saved $OutFile (${w}x${h})"
}
finally {
    if (-not $proc.HasExited) { Stop-Process -Id $proc.Id -Force }
}
