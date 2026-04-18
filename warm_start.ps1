for ($i = 1; $i -le 15; $i++) {
    Write-Host "--- Warm Start Run $i ---"
    Write-Host "Press HOME button on device now, then press Enter to continue..."
    Read-Host
    adb shell am start-activity -W -n com.example.medi_connect/.MainActivity
    Write-Host "Record the TotalTime value above"
    Write-Host "Waiting 10 seconds before next run..."
    Start-Sleep -Seconds 10
    Write-Host ""
}
Write-Host "=== All 15 Warm Start Runs Complete ==="