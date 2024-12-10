# Cursor 設備重置工具

## 功能簡介

一個用於重置 Cursor 編輯器設備和禁用自動更新的工具集。主要解決以下問題：

重置账户后 Too many free trial accounts used on this machine 限制
- 重置設備，解除試用限制
- 禁用自動更新功能
- 提供完整的備份和恢復機制

## 系統要求

### Windows
- Windows 10/11
- PowerShell 5.0+
- 管理員權限
- Cursor 編輯器（支持版本：v0.43.3、v0.43.1、v0.43.0 以及以下版本，舊版本不建議使用，可能會出現問題）

## 版本說明

本工具僅支持特定版本的 Cursor 編輯器：
- v0.43.3
- v0.43.1
- v0.43.0

您可以在這裡下載舊版本：[Cursor 歷史版本下載](https://downloader-cursor.deno.dev/) 感謝大佬

## 使用方法

### 前置步驟：
1. 安裝支持的 Cursor 版本
2. 在 PowerShell（管理員）中執行：
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

### 方式一：一鍵執行（推薦）
運行 `run_all.ps1` 腳本，自動完成所有操作：
```powershell
.\run_all.ps1
```

### 方式二：分步執行

1. 重置設備：
```powershell
.\cursor_reset.ps1
```

2. 禁用自動更新：
```powershell
.\ban_update.ps1
```

## 工作原理（不用糾結）

### 設備重置（cursor_reset.ps1）
修改以下文件和配置：
- `%APPDATA%\Cursor\machineid`
- `%APPDATA%\Cursor\User\globalStorage\storage.json`

更新的字段包括：
- telemetry.sqmId
- telemetry.machineId
- telemetry.devDeviceId
- telemetry.macMachineId

### 更新禁用（ban_update.ps1）
- 通過設置目錄權限阻止更新程序運行
- 位置：`%LOCALAPPDATA%\cursor-updater`

## 安全機制

### 自動備份
- 操作前自動備份所有修改的文件
- 備份保存在原目錄，帶有時間戳
- 出錯時可以選擇立即恢復

### 日誌記錄
- 詳細記錄所有操作步驟
- 日誌位置：`%TEMP%` 目錄
- 便於排查問題

## 注意事項

執行前請確保：
1. 安裝了支持的 Cursor 版本（v0.43.3、v0.43.1、v0.43.0）
2. 完全關閉 Cursor 編輯器
3. 以管理員身份運行 PowerShell
4. 如果遇到腳本執行限制，請執行：
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

## 恢復方法

1. 設備：
   - 執行腳本時如遇錯誤，選擇 'Y' 自動恢復
   - 手動從備份文件恢復

2. 更新功能：
   - 刪除或修改 cursor-updater 目錄的權限設置

## 常見問題

1. "無法加載腳本"
   - 以管理員身份運行 PowerShell
   - 執行 Bypass 策略命令
   - 執行以下命令解除腳本限制：
     ```powershell
     Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
     ```

2. "拒絕訪問"
   - 確認管理員權限
   - 檢查文件權限
   - 確保 Cursor 已關閉

## 免責聲明

本工具僅供學習研究使用，使用本工具所產生的任何後果由使用者自行承擔。
