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
    "5A894077.McAfeeSecurity"
    "613EBCEA.PolarrPhotoEditorAcademicEdition"
    "6Wunderkinder.Wunderlist"
    "7EE7776C.LinkedInforWindows"
    "828B5831.HiddenCityMysteryofShadows"
    "89006A2E.AutodeskSketchBook"
    "9E2F88E3.Twitter"
    "A278AB0D.DisneyMagicKingdoms"
    "A278AB0D.MarchofEmpires"
    "ActiproSoftwareLLC.562882FEEB491"
    "CAF9E577.Plex"
    "ClearChannelRadioDigital.iHeartRadio"
    "D52A8D61.FarmVille2CountryEscape"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "DolbyLaboratories.DolbyAccess"
    "Drawboard.DrawboardPDF"
    "Facebook.Facebook"
    "Fitbit.FitbitCoach"
    "flaregamesGmbH.RoyalRevolt2"
    "Flipboard.Flipboard"
    "GAMELOFTSA.Asphalt8Airborne"
    "KeeperSecurityInc.Keeper"
    "king.com.BubbleWitch3Saga"
    "king.com.CandyCrushFriends"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "king.com.*"
    "NORDCURRENT.COOKINGFEVER"
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
        Get-AppXProvisionedPackage -Online | Where-Object DisplayName -eq $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    }
    if ($appInstalled -eq $true){
        Write-Output "Removing App: $app"
        Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    }
}

#Wipe the Start Menu layout
$sysLanguage = Get-WinSystemLocale | Select DisplayName
if ($sysLanguage.DisplayName -like "English*"){
    Write-Output "Resetting the Start Menu layout..."
    (New-Object -Com Shell.Application).
    NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').
    Items() | %{ $_.Verbs() } | ?{$_.Name -match 'Un.*pin from Start'} | %{$_.DoIt()}
}
