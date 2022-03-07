################################################################################
##  File:  Install-Unity.ps1
##  Desc:  Install Unity 2019.2.21f1
##  By:    Philip Lamb
##  Mod:   2021-11-15
################################################################################

$UNITY_VERSION = "2019.2.21f1"
$UNITY_DOWNLOAD_HASH = "9d528d026557"

$argumentList = ("/S", "/D=C:\Program Files\Unity")
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/Windows64EditorInstaller/UnitySetup64.exe" -Name "UnitySetup64.exe" -ArgumentList $argumentList
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/TargetSupportInstaller/UnitySetup-Windows-IL2CPP-Support-for-Editor-${UNITY_VERSION}.exe" -Name "UnitySetup-Windows-IL2CPP-Support-for-Editor-${UNITY_VERSION}.exe" -ArgumentList $argumentList
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/TargetSupportInstaller/UnitySetup-Android-Support-for-Editor-${UNITY_VERSION}.exe" -Name "UnitySetup-Android-Support-for-Editor-${UNITY_VERSION}.exe" -ArgumentList $argumentList

$sdkInstallRoot = 'C:\Program Files\Unity\Editor\Data\PlaybackEngines\AndroidPlayer'

# Android SDK and NDK must be fetched separately. These versions are valid for Unity 2019.2.21f1.
$sdkToolsUrl = "https://dl.google.com/android/repository/sdk-tools-windows-4333796.zip"
$sdkToolsArchPath = Start-DownloadWithRetry -Url $sdkToolsUrl -Name "android-sdk-tools.zip"
Extract-7Zip -Path $sdkToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK"

$buildToolsUrl = "https://dl.google.com/android/repository/build-tools_r28.0.3-windows.zip"
$buildToolsArchPath = Start-DownloadWithRetry -Url $buildToolsUrl -Name "android-build-tools.zip"
Extract-7Zip -Path $buildToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK\build-tools"
Rename-Item "${sdkInstallRoot}\SDK\build-tools\android-9" "28.0.3"

$platformToolsUrl = "https://dl.google.com/android/repository/platform-tools_r28.0.1-windows.zip"
$platformToolsArchPath = Start-DownloadWithRetry -Url $platformToolsUrl -Name "android-platform-tools.zip"
Extract-7Zip -Path $platformToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK"

$ndkUrl = "https://dl.google.com/android/repository/android-ndk-r16b-windows-x86_64.zip"
$ndkArchPath = Start-DownloadWithRetry -Url $ndkUrl -Name "android-ndk.zip"
Extract-7Zip -Path $ndkArchPath -DestinationPath "${sdkInstallRoot}"
Rename-Item "${sdkInstallRoot}\android-ndk-r16b" "NDK"

$platformUrl = "https://dl.google.com/android/repository/platform-28_r06.zip"
$platformArchPath = Start-DownloadWithRetry -Url $platformUrl -Name "android-platform.zip"
Extract-7Zip -Path $platformArchPath -DestinationPath "${sdkInstallRoot}\SDK\platforms"
Rename-Item "${sdkInstallRoot}\SDK\platforms\android-9" "android-28"

# Add Android 10 (API 29) platform tools.
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "${sdkInstallRoot}\Tools\OpenJDK\Windows", [System.EnvironmentVariableTarget]::Machine)
Echo 'y' | & "${sdkInstallRoot}\SDK\tools\bin\sdkmanager.bat" "platform-tools" "platforms;android-29"
