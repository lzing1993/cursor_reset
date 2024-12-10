$folderPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "cursor-updater"
$log_file = "$env:TEMP\cursor_update_ban.log"

function Write-Log {
    param($Message)
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$time - $Message" | Out-File -FilePath $log_file -Append
    Write-Host $Message -ForegroundColor Cyan
}

function Test-Permission {
    param ([string]$Path)
    $acl = Get-Acl $Path -ErrorAction SilentlyContinue
    if ($acl) {
        foreach ($rule in $acl.Access) {
            if ($rule.IdentityReference -eq "Everyone" -and
                $rule.FileSystemRights -eq "Modify" -and
                $rule.AccessControlType -eq "Deny") {
                return $true
            }
        }
    }
    return $false
}

try {
    Write-Log "開始設置更新限制..."
    
    if (Test-Path $folderPath) {
        if (Test-Permission -Path $folderPath) {
            Write-Log "目標文件夾已設置 Everyone 的'修改'拒絕權限，無需重複設置。"
        } else {
            Write-Log "目標文件夾未設置權限，將進行設置..."
            Remove-Item -Path $folderPath\* -Recurse -Force
            $acl = Get-Acl $folderPath
            $denyRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
                "Everyone", 
                "Modify", 
                "ContainerInherit,ObjectInherit", 
                "None", 
                "Deny"
            )
            $acl.SetAccessRule($denyRule)
            Set-Acl -Path $folderPath -AclObject $acl
            Write-Log "權限設置完成：已拒絕 Everyone 的'修改'權限。"
        }
    } else {
        Write-Log "目標文件夾不存在，正在創建並設置權限..."
        New-Item -ItemType Directory -Path $folderPath | Out-Null
        $acl = Get-Acl $folderPath
        $denyRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "Everyone", 
            "Modify", 
            "ContainerInherit,ObjectInherit", 
            "None", 
            "Deny"
        )
        $acl.SetAccessRule($denyRule)
        Set-Acl -Path $folderPath -AclObject $acl
        Write-Log "權限設置完成：已拒絕 Everyone 的'修改'權限。"
    }
} catch {
    Write-Log "發生錯誤: $_"
}
