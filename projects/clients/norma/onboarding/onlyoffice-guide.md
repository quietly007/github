# OnlyOffice Guide for NORMA

> **Organization**: NORMA  
> **Service**: OnlyOffice Document Server  
> **Access URL**: https://office.quietly.online  
> **Document Version**: 1.0  
> **Created**: 2026-02-13

---

## 📋 Overview

OnlyOffice is a fully-featured office suite integrated with your Nextcloud. It allows you to create, edit, and collaborate on documents directly in your browser without needing Microsoft Office or other desktop software.

### Key Features
- ✅ Create and edit Word documents (.docx)
- ✅ Create and edit Excel spreadsheets (.xlsx)
- ✅ Create and edit PowerPoint presentations (.pptx)
- ✅ Real-time collaboration with team members
- ✅ Comments and suggestions
- ✅ Version history
- ✅ Convert between formats

---

## ⚡ Prerequisites

### VPN Connection Required

> **IMPORTANT**: OnlyOffice document editing requires a VPN connection for security reasons.

Before editing documents, ensure you are connected to the company VPN:
1. Open **Tailscale** (or Headscale client)
2. Verify connection status shows "Connected"
3. Your VPN IP should be in the `100.64.x.x` range

If you don't have VPN access, contact your administrator for setup.

---

## 🚀 Getting Started

### Creating a New Document

1. **Login to Nextcloud**: https://nextcloud.quietly.online
2. **Navigate to your folder** (e.g., `NORMA_Storage`)
3. **Click the + New button** (top of file list)
4. **Select document type**:
   - 📄 **New document** - Word processor
   - 📊 **New spreadsheet** - Excel-like
   - 📽️ **New presentation** - PowerPoint-like
5. **Enter a filename** (without extension)
6. **Press Enter** - Document opens in editor

### Opening an Existing Document

1. **Navigate to the file** in Nextcloud
2. **Click on the file** - Opens automatically in OnlyOffice
3. **Edit as needed** - Changes save automatically
4. **Close the tab** when finished

---

## 📄 Document Editor (Word Processing)

### Toolbar Overview
```
[File] [Edit] [Insert] [Layout] [References] [Review] [View] [Plugins]
```

### Common Operations

#### Text Formatting
| Action | Shortcut |
|--------|----------|
| Bold | Ctrl + B |
| Italic | Ctrl + I |
| Underline | Ctrl + U |
| Strikethrough | Ctrl + 5 |
| Copy | Ctrl + C |
| Paste | Ctrl + V |
| Undo | Ctrl + Z |
| Redo | Ctrl + Y |

#### Paragraph Formatting
- **Alignment**: Use toolbar buttons or Ctrl + L/E/R/J
- **Lists**: Click bullet/numbered list icons
- **Indentation**: Tab to indent, Shift+Tab to unindent
- **Line spacing**: Format → Paragraph → Line Spacing

#### Insert Elements
- **Images**: Insert → Image → From File/URL
- **Tables**: Insert → Table → Select size
- **Links**: Insert → Hyperlink (or Ctrl + K)
- **Page break**: Insert → Page Break (or Ctrl + Enter)
- **Header/Footer**: Insert → Header/Footer

### Styles
1. Select text
2. Click style dropdown (e.g., "Normal")
3. Choose heading level or style
4. Use styles for consistent formatting

---

## 📊 Spreadsheet Editor (Excel-like)

### Toolbar Overview
```
[File] [Home] [Insert] [Layout] [Formulas] [Data] [View] [Plugins]
```

### Cell Operations

#### Basic Shortcuts
| Action | Shortcut |
|--------|----------|
| Edit cell | F2 or double-click |
| Copy | Ctrl + C |
| Paste | Ctrl + V |
| Paste values only | Ctrl + Shift + V |
| Delete content | Delete |
| Insert row | Right-click → Insert → Row |
| Insert column | Right-click → Insert → Column |
| Merge cells | Select → Home → Merge |

#### Formulas
Start formulas with `=`

**Common Formulas:**
```
=SUM(A1:A10)          Sum of range
=AVERAGE(A1:A10)      Average of range
=COUNT(A1:A10)        Count of numbers
=COUNTA(A1:A10)       Count of non-empty cells
=IF(A1>10,"Yes","No") Conditional
=VLOOKUP(...)         Vertical lookup
=TODAY()              Current date
=NOW()                Current date/time
```

#### Formatting
- **Number format**: Home → Format dropdown
- **Currency**: Select cells → Format → Currency
- **Percentage**: Select cells → Format → Percentage
- **Conditional formatting**: Home → Conditional Formatting

### Working with Data

#### Sort Data
1. Select data range (including headers)
2. Data → Sort
3. Choose column and order

#### Filter Data
1. Select header row
2. Data → Filter
3. Click dropdown arrows on column headers

#### Charts
1. Select data range
2. Insert → Chart
3. Choose chart type
4. Customize as needed

---

## 📽️ Presentation Editor (PowerPoint-like)

### Toolbar Overview
```
[File] [Home] [Insert] [Transitions] [Slide Show] [View] [Plugins]
```

### Slide Operations

#### Managing Slides
| Action | Method |
|--------|--------|
| New slide | Home → New Slide (or Ctrl + M) |
| Duplicate slide | Right-click slide → Duplicate |
| Delete slide | Right-click slide → Delete |
| Reorder | Drag slide in left panel |

#### Adding Content
- **Text**: Click text placeholder or Insert → Text Box
- **Images**: Insert → Image
- **Shapes**: Insert → Shape
- **Tables**: Insert → Table
- **Charts**: Insert → Chart

#### Slide Design
- **Themes**: Design → Themes
- **Background**: Right-click → Slide Settings → Background
- **Layout**: Home → Layout

### Presenting

#### Start Slideshow
- **From beginning**: Slide Show → From Beginning (F5)
- **From current slide**: Slide Show → From Current Slide (Shift + F5)

#### During Presentation
| Action | Key |
|--------|-----|
| Next slide | Click / Space / Right Arrow |
| Previous slide | Backspace / Left Arrow |
| Go to slide | Number + Enter |
| End show | Esc |
| Black screen | B |
| White screen | W |

---

## 👥 Real-Time Collaboration

### Concurrent Editing
- Multiple users can edit the same document simultaneously
- Each user's cursor appears in a different color
- Changes appear instantly for all users
- No need to "check out" or lock documents

### User Indicators
- **Colored cursors** show where others are editing
- **User avatars** appear at top when others are viewing
- **Highlight** shows recent changes by others

### Communication Features

#### Comments
1. Select text or cell
2. Insert → Comment (or Ctrl + Alt + M)
3. Type your comment
4. Click Post

#### Review Comments
- Comments appear in right sidebar
- Click to jump to commented area
- Reply or resolve comments
- Filter: Resolved/Unresolved

#### Suggesting Mode (Documents only)
1. Click dropdown next to cursor icon (top-right)
2. Select "Suggesting"
3. Changes appear as tracked suggestions
4. Others can accept/reject your suggestions

---

## 🔄 Version History

### Viewing History
1. File → Version History
2. Version list appears on right
3. Click version to preview
4. Compare changes highlighted

### Restoring a Version
1. Open Version History
2. Click on desired version
3. Click **Restore** at top
4. Confirm restoration

### Manual Versioning
Nextcloud automatically creates versions, but for important milestones:
1. File → Download (save local backup)
2. Or: Rename with version number (e.g., `Report_v2.docx`)

---

## 📤 Sharing and Export

### Download Document
1. File → Download as
2. Choose format:
   - Original format (.docx, .xlsx, .pptx)
   - PDF
   - Other formats (ODT, RTF, etc.)

### Print Document
1. File → Print (or Ctrl + P)
2. PDF preview opens
3. Use browser print dialog

### Share Link
1. Return to Nextcloud file view
2. Click share icon on file
3. Create link or share with specific users
4. Set permissions (view/edit)

---

## ⚙️ Settings and Preferences

### Editor Settings
Access via: File → Advanced Settings

**Common Settings:**
- **Autosave**: Enabled by default
- **Spelling**: Auto-check while typing
- **Zoom**: View → Zoom or Ctrl + Mouse wheel
- **Theme**: Light/Dark mode (if available)

### Keyboard Shortcuts Reference
File → Keyboard Shortcuts (or Ctrl + /)

---

## ❓ Troubleshooting

### "OnlyOffice is not available"

**Cause**: Not connected to VPN

**Solution**:
1. Open Tailscale/Headscale client
2. Connect to VPN
3. Verify status shows "Connected"
4. Refresh Nextcloud page
5. Try opening document again

### Document Won't Open

**Possible causes and solutions**:

1. **File format not supported**
   - Convert to supported format (.docx, .xlsx, .pptx)
   
2. **File is corrupted**
   - Try downloading and reopening locally
   - Restore from version history

3. **Browser cache issue**
   - Clear browser cache (Ctrl + Shift + Delete)
   - Try incognito/private window

### Changes Not Saving

1. Check internet connection
2. Look for "Saving..." indicator
3. Wait for "All changes saved" message
4. If stuck, copy content → refresh → paste

### Slow Performance

1. Close unnecessary browser tabs
2. Check internet connection speed
3. Disable browser extensions temporarily
4. Try different browser (Chrome recommended)

### Collaboration Issues

**Can't see other users' cursors:**
1. Ensure both users have edit permissions
2. Both users must have VPN connected
3. Refresh page

**Conflicting edits:**
- OnlyOffice handles this automatically
- Latest change wins in simultaneous edits
- Use comments for coordination

---

## 🔒 Security Notes

### Data Security
- All traffic encrypted (HTTPS)
- Documents stored in your Nextcloud
- VPN adds additional encryption layer
- No data stored on external servers

### Access Control
- Only authorized users can access documents
- Permissions inherited from Nextcloud sharing
- Audit logs available for admins

### Best Practices
1. Don't share login credentials
2. Log out when using shared computers
3. Use strong, unique passwords
4. Enable two-factor authentication
5. Report suspicious activity to admin

---

## 📱 Mobile Editing

### OnlyOffice Mobile Apps
OnlyOffice offers mobile apps for editing on the go:

**iOS**: Search "OnlyOffice Documents" in App Store
**Android**: Search "OnlyOffice Documents" in Google Play

### Mobile Limitations
- Some advanced features may be limited
- Collaboration may be slower on mobile networks
- Consider using WiFi for large documents

### Alternative: Nextcloud Mobile
For simple viewing and light editing:
1. Open Nextcloud mobile app
2. Navigate to document
3. Tap to open
4. Uses OnlyOffice for editing

---

## 📞 Support

### Common Issues
Check the troubleshooting section above first.

### Contact Information
| Issue | Contact |
|-------|---------|
| VPN access | IT Administrator |
| Account problems | norma_admin |
| Service issues | support@quietly.online |

### Reporting Bugs
When reporting issues, include:
1. What you were trying to do
2. What happened instead
3. Error messages (if any)
4. Browser and version
5. Whether VPN was connected

---

## 🎯 Quick Reference Card

### Essential Shortcuts

| Action | Shortcut |
|--------|----------|
| Save | Ctrl + S (auto-saves) |
| Undo | Ctrl + Z |
| Redo | Ctrl + Y |
| Find | Ctrl + F |
| Replace | Ctrl + H |
| Print | Ctrl + P |
| Bold | Ctrl + B |
| Italic | Ctrl + I |
| Copy | Ctrl + C |
| Paste | Ctrl + V |
| Select all | Ctrl + A |

### Before You Start Checklist
- [ ] Connected to VPN (Tailscale/Headscale)
- [ ] Logged into Nextcloud
- [ ] In correct folder (NORMA_Storage)
- [ ] Have necessary permissions

### When Finished
- [ ] Changes saved (check indicator)
- [ ] Close document tab
- [ ] Share or notify collaborators if needed

---

**END OF DOCUMENT**
