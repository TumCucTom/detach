# InstaWeb - Instagram Web Viewer for iOS

## 1. Project Overview

- **Project Name**: InstaWeb
- **Bundle Identifier**: com.instaweb.app
- **Core Functionality**: An iOS app that wraps Instagram's web version (instagram.com) in a WKWebView, allowing users to browse Instagram through a native app shell.
- **Target Users**: Users who want a lightweight Instagram browsing experience
- **iOS Version Support**: iOS 15.0+

## 2. UI/UX Specification

### Screen Structure

1. **MainViewController** - Single screen app with WKWebView
2. **Navigation**: Minimal - just a refresh button and share button in a simple toolbar

### Visual Design

- **Color Palette**:
  - Primary: #E1306C (Instagram pink)
  - Background: #000000 (Black - for immersive web experience)
  - Toolbar: #1A1A1A (Dark gray)
  - Text/Icons: #FFFFFF (White)

- **Typography**: System font (San Francisco)

- **Spacing**: 8pt grid system

### Views & Components

1. **WKWebView** - Full screen web view loading instagram.com
2. **UIToolbar** - Bottom toolbar with:
   - Back button (if navigation available)
   - Forward button (if navigation available)
   - Refresh button
   - Share button
3. **UIProgressView** - Top progress indicator for page loading

## 3. Functionality Specification

### Core Features

1. **Web View Integration**
   - Load instagram.com in WKWebView
   - Handle all cookies/sessions like Safari
   - Support pinch-to-zoom
   - Handle deep links (instagram:// URLs)

2. **Navigation Controls**
   - Back/Forward browser history
   - Pull-to-refresh
   - Manual refresh button

3. **Share Functionality**
   - Share current URL via UIActivityViewController

4. **Loading State**
   - Progress bar during page loads
   - Handle offline state gracefully

### Architecture Pattern

- **MVC** - Simple ViewController-based architecture

### Edge Cases

- Handle "Open in App" prompts from Instagram
- Handle authentication flows
- Handle share extensions linking back

## 4. Technical Specification

### Dependencies

- None required - using native UIKit components only

### UI Framework

- **UIKit** with programmatic layout using **SnapKit**

### Required Packages (SPM)

- **SnapKit** (5.7.0+) - For Auto Layout constraints

### Asset Requirements

- App Icon (Instagram gradient style)
- SF Symbols for toolbar icons:
  - arrow.left (back)
  - arrow.right (forward)
  - arrow.clockwise (refresh)
  - square.and.arrow.up (share)

### Info.plist Configuration

- NSAppTransportSecuritySettings to allow instagram.com
- UIApplicationSupportsIndirectInputEvents for keyboard handling
