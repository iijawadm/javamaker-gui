# Java App Maker 🚀

A modern Flutter desktop application that simplifies creating Linux desktop entries for Java JAR applications.

## ✨ Features

- **Easy JAR Integration**: Select any Java JAR file to create a desktop entry
- **Custom Icons**: Choose custom icons for your applications
- **Beautiful UI**: Modern, clean interface with dark mode support
- **Instant Creation**: One-click desktop entry generation
- **Visual Feedback**: Clear success/error messages with improved UX

## 🎨 Recent Improvements

### Fixed Issues ✅
- **Icon Configuration**: Fixed incorrect icon path in `pubspec.yaml` (`avamaker.png` → `javamaker.png`)
- **Icon Display**: All icons now show correctly throughout the application

### UI Enhancements 🎯

1. **Hero Section**
   - Added stunning gradient icon with app logo
   - Clear title and description
   - Better visual hierarchy

2. **Improved Components**
   - Enhanced file selector cards with:
     - Visual selection state indicators
     - Check marks for selected files
     - Better spacing and borders
     - Hover effects
   - Redesigned text input with:
     - Better focus states
     - Rounded corners (12px)
     - Subtle shadows
     - Placeholder text support

3. **Enhanced Button Design**
   - Gradient background
   - Rocket icon for "launch" feeling
   - Improved shadows and hover states
   - Better visual feedback

4. **Better Feedback**
   - Enhanced success messages with location info
   - Improved error messages with icons
   - Floating snackbars with rounded corners
   - Auto-clear form after successful creation

5. **Visual Polish**
   - Updated color scheme (lighter backgrounds)
   - Better contrast in dark mode
   - Added info box with helpful information
   - Section headers with icons
   - Improved spacing throughout
   - Better responsive design

6. **AppBar Improvements**
   - Added app icon in title
   - Changed help icon to info icon with tooltip
   - Better spacing and alignment

## 🛠️ Setup & Build

### Prerequisites
- Flutter SDK (>=3.4.0)
- Linux development environment
- Java Runtime Environment (for running the created apps)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd javamaker
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate app icons** (if needed)
   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Run the app**
   ```bash
   flutter run -d linux
   ```

5. **Build for release**
   ```bash
   flutter build linux --release
   ```

## 📦 Dependencies

- `flutter`: Flutter SDK
- `file_picker`: ^6.1.1 - File selection dialog
- `path_provider`: ^2.1.2 - System path access
- `url_launcher`: ^6.1.7 - Open URLs
- `url_launcher_linux`: ^2.0.3 - Linux URL launcher
- `cupertino_icons`: ^1.0.6 - iOS-style icons
- `flutter_launcher_icons`: ^0.13.1 - Icon generation

## 🎯 Usage

1. **Enter Application Name**: Type the name for your desktop entry
2. **Select JAR File**: Click to browse and select your Java JAR file
3. **Choose Icon**: Select an image file (PNG, JPG, JPEG, SVG, ICO) for the app icon
4. **Create Entry**: Click the "Create Desktop Entry" button
5. **Done!**: Your application will appear in your system's application menu

Desktop entries are created in: `~/.local/share/applications/`

## 🎨 Screenshots

The app features:
- **Light Mode**: Clean, modern interface with blue accents
- **Dark Mode**: Eye-friendly dark theme with vibrant highlights
- **Responsive Design**: Works great on various screen sizes

## 🤝 Contributing

Feel free to open issues or submit pull requests for improvements!

## 👨‍💻 Author

**Made with ❤️ by Jawad Maayah**
- GitHub: [@iijawadm](https://github.com/iijawadm)

## 📄 License

This project is open source and available under the MIT License.

## 🔧 Technical Details

- **Platform**: Linux Desktop
- **Framework**: Flutter
- **Language**: Dart
- **Min SDK**: 3.4.0
- **Architecture**: Material Design with custom theming

## 📝 Notes

- Requires Java Runtime Environment to execute the created desktop entries
- Works on all modern Linux distributions
- Desktop entries follow the freedesktop.org specification
