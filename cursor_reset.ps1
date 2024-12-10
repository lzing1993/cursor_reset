$log_file = "$env:TEMP\cursor_device_id_update.log"

function Write-Log {
    param($Message)
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$time - $Message" | Out-File -FilePath $log_file -Append
    Write-Host $Message
}

try {
    Write-Log "開始更新 Cursor 設備 ID..."
    
    # 生成新的 ID
    $new_machine_id = [guid]::NewGuid().ToString().ToLower()
    $new_telemetry_machine_id = -join ((1..64) | ForEach-Object { "{0:x}" -f (Get-Random -Max 16) })
    $new_dev_device_id = [guid]::NewGuid().ToString().ToLower()
    $new_mac_machine_id = -join ((1..64) | ForEach-Object { "{0:x}" -f (Get-Random -Max 16) })
    $new_sqm_id = "{" + [guid]::NewGuid().ToString().ToUpper() + "}"
    
    # 設置文件路徑
    $machine_id_path = "$env:APPDATA\Cursor\machineid"
    $storage_json_path = "$env:APPDATA\Cursor\User\globalStorage\storage.json"
    
    # 檢查文件是否存在
    if (-not (Test-Path $machine_id_path) -or -not (Test-Path $storage_json_path)) {
        throw "必需的 Cursor 配置文件不存在"
    }
    
    # 創建備份
    $backup_time = Get-Date -Format "yyyyMMddHHmmss"
    Copy-Item -Path $machine_id_path -Destination "$machine_id_path.backup_$backup_time"
    Copy-Item -Path $storage_json_path -Destination "$storage_json_path.backup_$backup_time"
    Write-Log "已創建配置文件備份"
    
    # 更新 machineid 文件
    $new_machine_id | Out-File -FilePath $machine_id_path -Encoding UTF8 -NoNewline
    
    # 更新 storage.json
    $content = Get-Content $storage_json_path -Raw | ConvertFrom-Json
    $content.'telemetry.sqmId' = $new_sqm_id
    $content.'telemetry.machineId' = $new_telemetry_machine_id
    $content.'telemetry.devDeviceId' = $new_dev_device_id
    $content.'telemetry.macMachineId' = $new_mac_machine_id
    $content | ConvertTo-Json -Depth 100 | Out-File $storage_json_path -Encoding UTF8
    
    Write-Log "SQM ID: $new_sqm_id"
    Write-Log "更新完成。新的 ID 值為："
    Write-Log "Machine ID: $new_machine_id"
    Write-Log "Telemetry Machine ID: $new_telemetry_machine_id"
    Write-Log "Dev Device ID: $new_dev_device_id"
    Write-Log "Mac Machine ID: $new_mac_machine_id"

} catch {
    Write-Log "發生錯誤: $_"
    $restore = Read-Host "是否恢復備份? (Y/N)"
    if ($restore -eq 'Y') {
        Copy-Item "$machine_id_path.backup_$backup_time" -Destination $machine_id_path
        Copy-Item "$storage_json_path.backup_$backup_time" -Destination $storage_json_path
        Write-Log "已恢復到備份版本"
    }
}
