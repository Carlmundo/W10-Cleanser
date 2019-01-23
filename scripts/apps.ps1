# Initial list from https://raw.githubusercontent.com/W4RH4WK/Debloat-Windows-10/master/scripts/remove-default-apps.ps1

$apps = @(
    # Default / Forced Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.Advertising.Xaml"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingTravel"
    "Microsoft.BingWeather"
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.FreshPaint"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftPowerBIForWindows"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MinecraftUWP"
    "Microsoft.MixedReality.Portal"
    #"Microsoft.MSPaint"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.ScreenSketch"
    "Microsoft.SkypeApp"
    #"Microsoft.MicrosoftStickyNotes"
    "Microsoft.Wallet"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    #"Microsoft.Windows.Photos"
    #"Microsoft.WindowsStore"
    "Microsoft.WindowsReadingList"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.YourPhone"
    #"Microsoft.XboxApp"
    #"Microsoft.XboxGameOverlay"
    #"Microsoft.XboxGamingOverlay"
    #"Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"

    # Third Party
    "2FE3CB00.PicsArt-PhotoStudio"
    "46928bounde.EclipseManager"
    "4DF9E0F8.Netflix"
    "6Wunderkinder.Wunderlist"
    "828B5831.HiddenCityMysteryofShadows"
    "89006A2E.AutodeskSketchBook"
    "9E2F88E3.Twitter"
    "A278AB0D.DisneyMagicKingdoms"
    "A278AB0D.MarchofEmpires"
    "ActiproSoftwareLLC.562882FEEB491"
    "ClearChannelRadioDigital.iHeartRadio"
    "D52A8D61.FarmVille2CountryEscape"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "DolbyLaboratories.DolbyAccess"
    "Drawboard.DrawboardPDF"
    "Facebook.Facebook"
    "flaregamesGmbH.RoyalRevolt2"
    "Flipboard.Flipboard"
    "GAMELOFTSA.Asphalt8Airborne"
    "KeeperSecurityInc.Keeper"
    "king.com.BubbleWitch3Saga"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "PandoraMediaInc.29680B314EFC2"
    "Playtika.CaesarsSlotsFreeCasino"
    "ShazamEntertainmentLtd.Shazam"
    "SpotifyAB.SpotifyMusic"
    "TheNewYorkTimes.NYTCrossword"
    "ThumbmunkeysLtd.PhototasticCollage"
    "TuneIn.TuneInRadio"
    "WinZipComputing.WinZipUniversal"
    "XINGAG.XING"

    # Unable to remove
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Windows.ContactSupport"
)

foreach ($app in $apps){
    $appInstalled = Get-AppxPackage $app | % {$_.Name -eq $app}
    $appProvisioned = Get-AppXProvisionedPackage -Online | % {$_.DisplayName -eq $app}
    if ($appProvisioned -eq $true){
        Write-Output "Removing Provision: $app" 
        Get-AppXProvisionedPackage -Online | Where-Object DisplayName -eq $app | Remove-AppxProvisionedPackage -Online | Out-Null
    }
    if ($appInstalled -eq $true){
        Write-Output "Removing App: $app"   
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
    }
}

#Unpin all apps from Start Menu
#Export/read layout idea from: https://social.technet.microsoft.com/Forums/en-US/afd16053-7db0-4a44-9499-be61851661bf/clean-pinned-start-menu-apps-with-powershell?forum=win10itprogeneral
$sysLanguage = Get-WinSystemLocale | Select DisplayName
if ($sysLanguage.DisplayName -like "English*"){
    Write-Output "Unpinning Start Menu apps..."
    $outputStart = "$env:temp\startlayout.xml"
    Export-StartLayout -path "$outputStart"
    [xml]$layoutfile = Get-Content "$outputStart"
    foreach ($item in $layoutfile.LayoutModificationTemplate.DefaultLayoutOverride.StartLayoutCollection.StartLayout.Group.DesktopApplicationTile.DesktopApplicationLinkPath){
            $outputFile = Split-Path $item -leaf
            $name = $outputFile.split('.') | Select-Object -first 1
            ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $name}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from Start'} | %{$_.DoIt()}  
    }
    Remove-Item -path "$outputStart"
}