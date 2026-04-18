for ($i = 1; $i -le 15; $i++) {
    Write-Host "--- Run $i ---"
    adb shell am force-stop com.example.medi_connect
    adb shell am start-activity -W -n com.example.medi_connect/.MainActivity
    Start-Sleep -Seconds 10
}