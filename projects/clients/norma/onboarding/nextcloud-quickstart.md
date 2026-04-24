# NORMA Client - Nextcloud Quick Start Guide

> **Organization**: NORMA  
> **Service Provider**: quietly.online  
> **Document Version**: 1.0  
> **Created**: 2026-02-13

---

## 🔗 Access Information

| Service | URL | Purpose |
|---------|-----|---------|
| Nextcloud | https://nextcloud.quietly.online | File storage & sync |
| OnlyOffice | https://office.quietly.online | Document editing (VPN required) |

---

## 👤 Administrator Account

| Property | Value |
|----------|-------|
| Username | `norma_admin` |
| Password | `Norma2026SecurePass` ⚠️ **CHANGE IMMEDIATELY** |
| Quota | Unlimited |
| Group | `client_norma` |

---

## 📁 Shared Storage

| Property | Value |
|----------|-------|
| Folder Name | `NORMA_Storage` |
| Location | Group Folders (left sidebar) |
| Quota | 500 GB |
| Access | All `client_norma` group members |

---

## 🚀 First Login - Administrator

### 1. Access Nextcloud
1. Open browser: https://nextcloud.quietly.online
2. Login with `norma_admin` / `Norma2026SecurePass`
3. **Change password immediately**: Settings → Personal → Security

### 2. Verify Group Folder Access
1. Click "Group folders" in left sidebar
2. Confirm `NORMA_Storage` is visible
3. This folder is shared with all NORMA team members

### 3. Install Desktop Client
1. Download from: https://nextcloud.com/install/#install-clients
2. Server address: `https://nextcloud.quietly.online`
3. Login with your credentials
4. Select `NORMA_Storage` folder to sync
5. Choose local folder location

---

## 👥 Adding Team Members

As `norma_admin`, create accounts for your team:

### Via Web Interface
1. Click user icon (top right) → **Users**
2. Click **+ New user**
3. Fill in:
   - **Username**: e.g., `norma.firstname.lastname`
   - **Display name**: Full name
   - **Password**: Generate strong password
   - **Groups**: Select `client_norma`
   - **Quota**: Set as needed (e.g., 50 GB)
4. Click **Add new user**
5. Share credentials securely with the team member

### Recommended Naming Convention
```
norma.john.doe
norma.jane.smith
norma.accountant
norma.manager
```

---

## 📱 Mobile App Setup

### iOS
1. Download "Nextcloud" from App Store
2. Server: `https://nextcloud.quietly.online`
3. Login with your credentials

### Android
1. Download "Nextcloud" from Google Play
2. Server: `https://nextcloud.quietly.online`
3. Login with your credentials

### Auto-Upload (Optional)
1. Open Nextcloud app
2. Settings → Auto upload
3. Enable for Photos/Videos
4. Select target folder (e.g., `NORMA_Storage/Photos/YourName`)

---

## 📄 Document Editing with OnlyOffice

### Requirements
- **VPN Connection Required**: OnlyOffice is only accessible via the company VPN
- Contact your administrator for VPN setup (Tailscale/Headscale)

### Supported Formats
| Type | Formats |
|------|---------|
| Documents | .docx, .doc, .odt, .rtf, .txt |
| Spreadsheets | .xlsx, .xls, .ods, .csv |
| Presentations | .pptx, .ppt, .odp |

### Create New Document
1. Navigate to desired folder
2. Click **+ New** button
3. Select document type (Document, Spreadsheet, Presentation)
4. Enter filename
5. Document opens in OnlyOffice editor

### Edit Existing Document
1. Click on any Office document
2. Opens automatically in OnlyOffice
3. Changes save automatically
4. Close tab when finished

### Real-time Collaboration
- Multiple users can edit simultaneously
- See other users' cursors in real-time
- Changes sync instantly
- Comment and suggest features available

---

## 🔒 Security Best Practices

### Password Requirements
- Minimum 12 characters
- Mix of uppercase, lowercase, numbers, symbols
- Unique password (not used elsewhere)

### Two-Factor Authentication (Recommended)
1. Settings → Security → Two-Factor Authentication
2. Download authenticator app (Google Authenticator, Authy)
3. Scan QR code
4. Save backup codes securely

### App Passwords for Desktop/Mobile
Instead of using your main password:
1. Settings → Security → Devices & sessions
2. Create new app password
3. Use this password for desktop/mobile clients

---

## 📂 Folder Organization

### Suggested Structure
```
NORMA_Storage/
├── 01_Administration/
│   ├── Contracts/
│   ├── Invoices/
│   └── Reports/
├── 02_Projects/
│   ├── Project_A/
│   └── Project_B/
├── 03_Shared/
│   ├── Templates/
│   └── Resources/
├── 04_Archive/
└── 05_Photos/
```

---

## ❓ Troubleshooting

### Cannot Login
1. Verify correct URL: https://nextcloud.quietly.online
2. Check username/password (case-sensitive)
3. Clear browser cache and cookies
4. Try incognito/private browser window

### Desktop Client Not Syncing
1. Check internet connection
2. Verify Nextcloud icon in system tray
3. Right-click icon → Open Nextcloud
4. Check for error messages
5. Try "Force sync now" option

### OnlyOffice Shows "Not Available"
1. Ensure you are connected to VPN (Tailscale/Headscale)
2. Check VPN connection status
3. Try refreshing the page
4. If problem persists, contact administrator

### Files Not Appearing
1. Wait for sync to complete (check progress)
2. Refresh page (F5)
3. Check if file is in correct folder
4. Verify you have access permissions

---

## 📞 Support Contacts

| Issue Type | Contact |
|------------|---------|
| Account Problems | Your company IT administrator |
| Service Issues | support@quietly.online |
| Password Reset | Contact `norma_admin` |

---

## 🔄 Quick Reference

### Desktop Client Shortcuts
| Action | Windows | macOS |
|--------|---------|-------|
| Open Nextcloud | Click system tray icon | Click menu bar icon |
| Sync now | Right-click → Force sync | Right-click → Force sync |
| Open folder | Double-click icon | Double-click icon |
| Settings | Right-click → Settings | Right-click → Settings |

### Important URLs
- **Nextcloud**: https://nextcloud.quietly.online
- **OnlyOffice**: https://office.quietly.online (VPN required)
- **Desktop Client**: https://nextcloud.com/install/#install-clients

---

**END OF DOCUMENT**
