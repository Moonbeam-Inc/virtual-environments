################################################################################
##  File:  Install-Unity.ps1
##  Desc:  Install Unity 2021.3.2f1
##  By:    Philip Lamb
##  Mod:   2022-05-11
################################################################################

$UNITY_VERSION = "2021.3.2f1"
$UNITY_DOWNLOAD_HASH = "d6360bedb9a0"

$argumentList = ("/S", "/D=C:\Program Files\Unity")
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/Windows64EditorInstaller/UnitySetup64.exe" -Name "UnitySetup64.exe" -ArgumentList $argumentList
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/TargetSupportInstaller/UnitySetup-Windows-IL2CPP-Support-for-Editor-${UNITY_VERSION}.exe" -Name "UnitySetup-Windows-IL2CPP-Support-for-Editor-${UNITY_VERSION}.exe" -ArgumentList $argumentList
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/TargetSupportInstaller/UnitySetup-Android-Support-for-Editor-${UNITY_VERSION}.exe" -Name "UnitySetup-Android-Support-for-Editor-${UNITY_VERSION}.exe" -ArgumentList $argumentList

$sdkInstallRoot = 'C:\Program Files\Unity\Editor\Data\PlaybackEngines\AndroidPlayer'

# OpenJDK must be fetched separately. This version is valid for Unity 2021.3.2f1.
$jdkUrl = "https://github.com/AdoptOpenJDK/openjdk8-releases/releases/download/jdk8u172-b11/OpenJDK8_x64_Win_jdk8u172-b11.zip"
$jdkArchPath = Start-DownloadWithRetry -Url $jdkUrl -Name "jdk.zip"
Extract-7Zip -Path $jdkArchPath -DestinationPath "${sdkInstallRoot}"
Rename-Item "${sdkInstallRoot}\jdk8u172-b11" "OpenJDK"

# Android SDK and NDK must be fetched separately. These versions are valid for Unity 2021.3.2f1.
$sdkToolsUrl = "https://dl.google.com/android/repository/sdk-tools-windows-4333796.zip"
$sdkToolsArchPath = Start-DownloadWithRetry -Url $sdkToolsUrl -Name "android-sdk-tools.zip"
Extract-7Zip -Path $sdkToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK"

$buildToolsUrl = "https://dl.google.com/android/repository/efbaa277338195608aa4e3dbd43927e97f60218c.build-tools_r30.0.2-windows.zip"
$buildToolsArchPath = Start-DownloadWithRetry -Url $buildToolsUrl -Name "android-build-tools.zip"
Extract-7Zip -Path $buildToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK\build-tools"
Rename-Item "${sdkInstallRoot}\SDK\build-tools\android-11" "30.0.2"

$platformToolsUrl = "https://dl.google.com/android/repository/platform-tools_r30.0.4-windows.zip"
$platformToolsArchPath = Start-DownloadWithRetry -Url $platformToolsUrl -Name "android-platform-tools.zip"
Extract-7Zip -Path $platformToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK"

$ndkUrl = "https://dl.google.com/android/repository/android-ndk-r21d-windows-x86_64.zip"
$ndkArchPath = Start-DownloadWithRetry -Url $ndkUrl -Name "android-ndk.zip"
Extract-7Zip -Path $ndkArchPath -DestinationPath "${sdkInstallRoot}"
Rename-Item "${sdkInstallRoot}\android-ndk-r21d" "NDK"

$platformUrl = "https://dl.google.com/android/repository/platform-29_r05.zip"
$platformArchPath = Start-DownloadWithRetry -Url $platformUrl -Name "android-platform-29.zip"
Extract-7Zip -Path $platformArchPath -DestinationPath "${sdkInstallRoot}\SDK\platforms"
Rename-Item "${sdkInstallRoot}\SDK\platforms\android-10" "android-29"

$platformUrl = "https://dl.google.com/android/repository/platform-30_r03.zip"
$platformArchPath = Start-DownloadWithRetry -Url $platformUrl -Name "android-platform-30.zip"
Extract-7Zip -Path $platformArchPath -DestinationPath "${sdkInstallRoot}\SDK\platforms"
Rename-Item "${sdkInstallRoot}\SDK\platforms\android-11" "android-30"

# Uncomment to add Android API XX platform tools, where XX is desired version number.
#[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "${sdkInstallRoot}\Tools\OpenJDK\Windows", [System.EnvironmentVariableTarget]::Machine)
#Echo 'y' | & "${sdkInstallRoot}\SDK\tools\bin\sdkmanager.bat" "platform-tools" "platforms;android-XX"
