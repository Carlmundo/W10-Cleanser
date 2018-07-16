# Initial list from https://raw.githubusercontent.com/W4RH4WK/Debloat-Windows-10/master/scripts/remove-default-apps.ps1

$apps = @(
    # default Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    "Microsoft.FreshPaint"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftPowerBIForWindows"
    "Microsoft.MinecraftUWP"
    #"Microsoft.MicrosoftStickyNotes"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    #"Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    #"Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    #"Microsoft.WindowsStore"
    #"Microsoft.XboxApp"
    #"Microsoft.XboxGameOverlay"
    #"Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    
    # Threshold 2 apps
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.WindowsFeedbackHub"

    # Creators Update apps
    "Microsoft.Microsoft3DViewer"
    #"Microsoft.MSPaint"

    #Redstone apps
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingTravel"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.WindowsReadingList"

    # non-Microsoft
    "9E2F88E3.Twitter"
    "PandoraMediaInc.29680B314EFC2"
    "Flipboard.Flipboard"
    "ShazamEntertainmentLtd.Shazam"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "ClearChannelRadioDigital.iHeartRadio"
    "4DF9E0F8.Netflix"
    "6Wunderkinder.Wunderlist"
    "Drawboard.DrawboardPDF"
    "2FE3CB00.PicsArt-PhotoStudio"
    "D52A8D61.FarmVille2CountryEscape"
    "TuneIn.TuneInRadio"
    "GAMELOFTSA.Asphalt8Airborne"
    "TheNewYorkTimes.NYTCrossword"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "Facebook.Facebook"
    "flaregamesGmbH.RoyalRevolt2"
    "Playtika.CaesarsSlotsFreeCasino"
    "A278AB0D.MarchofEmpires"
    "KeeperSecurityInc.Keeper"
    "ThumbmunkeysLtd.PhototasticCollage"
    "XINGAG.XING"
    "89006A2E.AutodeskSketchBook"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "46928bounde.EclipseManager"
    "ActiproSoftwareLLC.562882FEEB491"
    "DolbyLaboratories.DolbyAccess"
    "SpotifyAB.SpotifyMusic"
    "A278AB0D.DisneyMagicKingdoms"
    "WinZipComputing.WinZipUniversal"

    # apps which cannot be removed using Remove-AppxPackage
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"

    #Added by W10 Cleanser
    "Microsoft.Advertising.Xaml"
    "828B5831.HiddenCityMysteryofShadows"
    "king.com.BubbleWitch3Saga"
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