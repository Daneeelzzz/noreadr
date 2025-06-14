import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/platform_detector.dart';
import '../utils/responsive_helper.dart';
import '../widgets/adaptive_widgets.dart';
import '../theme/theme_provider.dart';
import '../services/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool notificationsEnabled = true;
  bool downloadOverWifiOnly = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final deviceType = ResponsiveHelper.getDeviceType(context);

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(PlatformDetector.isIOS() ? CupertinoIcons.settings : Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: deviceType == DeviceScreenType.desktop || isLandscape
          ? _buildLandscapeLayout(context, themeProvider)
          : _buildPortraitLayout(context, themeProvider),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, ThemeProvider themeProvider) {
    return Column(
      children: [
        _buildProfileInfo(context),
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Delivery'),
            Tab(text: 'Completed'),
            Tab(text: 'Simpanan'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildReadingList(context),
              _buildCompletedList(context),
              _buildBookmarks(context),
            ],
          ),
        ),
        _buildSettingsSection(context, themeProvider),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileInfo(context),
                _buildSettingsSection(context, themeProvider),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(text: 'Delivery'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Simpanan'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReadingList(context),
                    _buildCompletedList(context),
                    _buildBookmarks(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    final name = PocketBaseService.getUserName();
    final email = PocketBaseService.getUserEmail();
    final avatarUrl = PocketBaseService.getUserAvatar();

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: [
          ClipOval(
            child: avatarUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: avatarUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                  )
                : const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
          ),
          const SizedBox(height: 12),
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('@$email', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatColumn(context, '128', 'Customers'),
              Container(
                  height: 30,
                  width: 1,
                  color: Theme.of(context).dividerColor,
                  margin: const EdgeInsets.symmetric(horizontal: 16)),
              _buildStatColumn(context, '128', 'Reviews'),
              Container(
                  height: 30,
                  width: 1,
                  color: Theme.of(context).dividerColor,
                  margin: const EdgeInsets.symmetric(horizontal: 16)),
              _buildStatColumn(context, '15', 'Lists'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildReadingList(BuildContext context) {
    return const Center(child: Text('Delivery List'));
  }

  Widget _buildCompletedList(BuildContext context) {
    return const Center(child: Text('Completed List'));
  }

  Widget _buildBookmarks(BuildContext context) {
    return FutureBuilder<List<RecordModel>>(
      future: PocketBaseService.fetchBookmarks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print('ERROR BOOKMARK: ${snapshot.error}');
          return const Center(child: Text('Gagal memuat bookmark'));
        }
        final bookmarks = snapshot.data ?? [];
        if (bookmarks.isEmpty) {
          return const Center(child: Text('Belum ada bookmark'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = bookmarks[index];
            final novel = bookmark.expand['novel_id'] as RecordModel?;
            if (novel == null) {
              return const SizedBox.shrink();
            }
            final coverImage = PocketBaseService.getNovelCoverImage(novel);
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: coverImage.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: coverImage,
                          width: 60,
                          height: 90,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            width: 60,
                            height: 90,
                            color: Colors.grey[300],
                            child: const Center(child: Icon(Icons.error, color: Colors.red)),
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 90,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.book, color: Colors.white)),
                        ),
                ),
                title: Text(novel.data['title'] ?? 'Unknown Title'),
                subtitle: Text(novel.data['author'] ?? 'Unknown Author'),
                trailing: TextButton(
                  child: const Text('Add to Reading'),
                  onPressed: () {},
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/novel-detail',
                    arguments: novel,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingsSection(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          _buildSettingRow(
            context,
            icon: themeProvider.isDarkMode
                ? (PlatformDetector.isIOS() ? CupertinoIcons.moon_fill : Icons.dark_mode)
                : (PlatformDetector.isIOS() ? CupertinoIcons.sun_max_fill : Icons.light_mode),
            title: 'Dark Mode',
            trailing: AdaptiveSwitch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          _buildSettingRow(
            context,
            icon: PlatformDetector.isIOS() ? CupertinoIcons.bell : Icons.notifications,
            title: 'Notifications',
            trailing: AdaptiveSwitch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          _buildSettingRow(
            context,
            icon: PlatformDetector.isIOS() ? CupertinoIcons.wifi : Icons.wifi,
            title: 'Download over WiFi only',
            trailing: AdaptiveSwitch(
              value: downloadOverWifiOnly,
              onChanged: (value) {
                setState(() {
                  downloadOverWifiOnly = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AdaptiveButton(
              label: 'Logout',
              onPressed: () {
                PocketBaseService.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              isDestructive: true,
              icon: Icon(
                PlatformDetector.isIOS() ? CupertinoIcons.square_arrow_right : Icons.logout,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
      BuildContext context, {required IconData icon, required String title, required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}