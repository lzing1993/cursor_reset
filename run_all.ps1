# 先執行設備更新
Write-Host "正在更新設備..." -ForegroundColor Cyan
& "$PSScriptRoot\cursor_reset.ps1"

# 然後設置更新限制
Write-Host "`n正在設置更新限制..." -ForegroundColor Cyan
& "$PSScriptRoot\ban_update.ps1"

Write-Host "`n所有操作已完成!" -ForegroundColor Green 
