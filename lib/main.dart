import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Java App Maker',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primaryColor = isDark ? const Color(0xFF78aeff) : const Color(0xFF1a73e8);
    final scaffoldBackground = isDark ? const Color(0xFF242424) : const Color(0xFFFAFAFA);

    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
      ),
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF303030) : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF383838) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _jarPath;
  String? _iconPath;
  final TextEditingController _appNameController = TextEditingController();

  Future<void> _pickFile({required List<String> extensions, required Function(String) onSelected}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        onSelected(result.files.single.path!);
      });
    }
  }

  void _createDesktopFile() {
    String appName = _appNameController.text.trim();

    if (_jarPath == null || appName.isEmpty || _iconPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill all fields and select files."),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final String homeDir = Platform.environment['HOME'] ?? '';
    final String desktopFilePath = "$homeDir/.local/share/applications/${appName.replaceAll(' ', '_')}.desktop";

    final String desktopFileContent = """
[Desktop Entry]
Name=$appName
Comment=Java Application
Exec=java -jar $_jarPath
Icon=$_iconPath
Terminal=false
Type=Application
Categories=Utility;Application;
""";

    try {
      File file = File(desktopFilePath);
      file.writeAsStringSync(desktopFileContent);

      ProcessResult chmodResult = Process.runSync("chmod", ["+x", desktopFilePath]);

      if (chmodResult.exitCode == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Created successfully at:\n$desktopFilePath"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        throw Exception("Failed to set permission: ${chmodResult.stderr}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error: $e"),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _openGitHubProfile() async {
    final Uri url = Uri.parse('https://github.com/iijawadm');
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Could not open GitHub profile."),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Java App Maker"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: _openGitHubProfile,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? screenWidth * 0.1 : 16,
              vertical: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: isLargeScreen ? 800 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Application Details
                  _buildSectionHeader("Application Details"),
                  const SizedBox(height: 16),
                  _buildGtkEntry(
                    controller: _appNameController,
                    label: "Application Name",
                    icon: Icons.app_registration,
                  ),
                  const SizedBox(height: 24),

                  // Application Components
                  _buildSectionHeader("Application Components"),
                  const SizedBox(height: 16),
                  _buildFileSelector(
                    label: "JAR File",
                    value: _jarPath,
                    icon: Icons.insert_drive_file,
                    onPressed: () => _pickFile(
                      extensions: ['jar'],
                      onSelected: (path) => _jarPath = path,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFileSelector(
                    label: "Application Icon",
                    value: _iconPath,
                    icon: Icons.image,
                    onPressed: () => _pickFile(
                      extensions: ['png', 'jpg', 'jpeg'],
                      onSelected: (path) => _iconPath = path,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Create Button
                  Center(
                    child: SizedBox(
                      width: isLargeScreen ? screenWidth * 0.5 : double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: isDark
                              ? null
                              : const LinearGradient(
                            colors: [Color(0xFF1a73e8), Color(0xFF669df6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: isDark
                              ? null
                              : [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _createDesktopFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? const Color(0xFF3584e4) : null,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.create_rounded),
                              SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  "Create Desktop Entry",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Made with Love Footer
                  Center(
                    child: InkWell(
                      onTap: _openGitHubProfile,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Made with ",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            WidgetSpan(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                            const TextSpan(
                              text: " by Jawad Maayah",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildGtkEntry({required TextEditingController controller, required String label, required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 24),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFileSelector({required String label, required String? value, required IconData icon, required VoidCallback onPressed}) {
    return Card(
      elevation: 0,
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF383838)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value ?? "Not selected",
                      style: TextStyle(
                        color: value != null
                            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}