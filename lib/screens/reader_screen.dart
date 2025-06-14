import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/platform_detector.dart';
import '../utils/responsive_helper.dart';
import '../widgets/adaptive_widgets.dart';
import '../theme/theme_provider.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({Key? key}) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool isBookmarked = false;
  double fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final novelId = args['novelId'] as String;
    final chapterId = args['chapterId'] as String;
    final title = args['title'] as String;
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    final chapterTitle = 'Chapter $chapterId: ${
      chapterId == '1' ? 'The Beginning' :
      chapterId == '2' ? 'Dark Shadows' :
      chapterId == '3' ? 'Unexpected Allies' :
      chapterId == '4' ? 'The Journey Begins' :
      chapterId == '5' ? 'Secrets Revealed' :
      'Chapter Title $chapterId'
    }';

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: chapterTitle,
        leading: IconButton(
          icon: Icon(PlatformDetector.isIOS() ? CupertinoIcons.back : Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked 
                  ? (PlatformDetector.isIOS() ? CupertinoIcons.bookmark_fill : Icons.bookmark)
                  : (PlatformDetector.isIOS() ? CupertinoIcons.bookmark : Icons.bookmark_border),
              color: isBookmarked ? Theme.of(context).primaryColor : null,
            ),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
          ),
          IconButton(
            icon: Icon(PlatformDetector.isIOS() ? CupertinoIcons.settings : Icons.settings),
            onPressed: () {
              _showSettingsBottomSheet(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Reading Content
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapterTitle,
                    style: TextStyle(
                      fontSize: fontSize + 4,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'My name was Vin and i am from sunogakure village',
                    style: TextStyle(
                      fontSize: fontSize,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Progress Bar
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.35,
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                          color: Theme.of(context).primaryColor,
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '35% of chapter',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Chapter $chapterId of 32',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Chapter Navigation
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdaptiveButton(
                  label: 'Previous',
                  onPressed: int.parse(chapterId) > 1
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReaderScreen(),
                              settings: RouteSettings(
                                arguments: {
                                  'novelId': novelId,
                                  'chapterId': (int.parse(chapterId) - 1).toString(),
                                  'title': title,
                                },
                              ),
                            ),
                          );
                        }
                      : () {},
                  isPrimary: false,
                  icon: Icon(
                    PlatformDetector.isIOS() 
                        ? CupertinoIcons.chevron_left 
                        : Icons.chevron_left,
                    size: 18,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(PlatformDetector.isIOS() ? CupertinoIcons.list_bullet : Icons.menu),
                  onSelected: (String value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReaderScreen(),
                        settings: RouteSettings(
                          arguments: {
                            'novelId': novelId,
                            'chapterId': value,
                            'title': title,
                          },
                        ),
                      ),
                    );
                  },
                  itemBuilder: (BuildContext context) {
                    return List.generate(
                      5,
                      (index) => PopupMenuItem<String>(
                        value: (index + 1).toString(),
                        child: Text('Chapter ${index + 1}'),
                      ),
                    );
                  },
                ),
                AdaptiveButton(
                  label: 'Next',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReaderScreen(),
                        settings: RouteSettings(
                          arguments: {
                            'novelId': novelId,
                            'chapterId': (int.parse(chapterId) + 1).toString(),
                            'title': title,
                          },
                        ),
                      ),
                    );
                  },
                  isPrimary: false,
                  icon: Icon(
                    PlatformDetector.isIOS() 
                        ? CupertinoIcons.chevron_right 
                        : Icons.chevron_right,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reading Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  // Font Size
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Font Size',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${fontSize.toInt()}px',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: fontSize,
                    min: 12,
                    max: 24,
                    divisions: 12,
                    onChanged: (value) {
                      setModalState(() {
                        fontSize = value;
                      });
                      setState(() {
                        fontSize = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Dark Mode
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      AdaptiveSwitch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                          setModalState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Download Chapter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Download Chapter',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      AdaptiveButton(
                        label: 'Download',
                        onPressed: () {
                          // Download functionality
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chapter downloaded for offline reading'),
                            ),
                          );
                        },
                        isPrimary: false,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

