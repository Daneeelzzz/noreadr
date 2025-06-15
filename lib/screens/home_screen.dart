import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/novel.dart';
import '../utils/platform_detector.dart';
import '../utils/responsive_helper.dart';
import '../widgets/adaptive_widgets.dart';
import 'package:pocketbase/pocketbase.dart';
import '../services/pocketbase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final deviceType = ResponsiveHelper.getDeviceType(context);

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: 'Cari novel mu',
        actions: [
          IconButton(
            icon: Icon(PlatformDetector.isIOS() ? CupertinoIcons.search : Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: Icon(PlatformDetector.isIOS() ? CupertinoIcons.person : Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: deviceType == DeviceScreenType.desktop || isLandscape
          ? _buildLandscapeLayout(context)
          : _buildPortraitLayout(context),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannerPromo(context),
          _buildCategories(context),
          _buildPopularNovels(context),
          _buildContinueReading(context),
          _buildNewReleases(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBannerPromo(context),
                _buildContinueReading(context),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategories(context),
                _buildPopularNovels(context),
                _buildNewReleases(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerPromo(BuildContext context) {
    final height = ResponsiveHelper.getResponsiveValue(
      context: context,
      mobile: 180.0,
      tablet: 220.0,
      desktop: 250.0,
    );

    return FutureBuilder<List<RecordModel>>(
      future: PocketBaseService.fetchNovels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          print('Error fetching novels: ${snapshot.error}');
          return Container(height: height, color: Colors.grey[300]);
        }
        final novels = snapshot.data!;
        final trendingNovel = novels.isNotEmpty ? novels.first : null;
        if (trendingNovel == null) {
          return Container(height: height, color: Colors.grey[300]);
        }

        return Padding(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                CachedNetworkImage(
                  imageUrl: PocketBaseService.getNovelCoverImage(trendingNovel),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                    height: height,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.error, color: Colors.red)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Trending',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        trendingNovel.data['title'] ?? 'No Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${trendingNovel.data['rating'] ?? '0.0'} (${trendingNovel.data['reviews'] ?? '0'} readers)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AdaptiveButton(
                        label: 'Read Now',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/novel-detail',
                            arguments: Novel(
                              id: trendingNovel.id,
                              title: trendingNovel.data['title'] ?? 'No Title',
                              author: trendingNovel.data['author'] ?? 'Unknown',
                              rating: double.tryParse(trendingNovel.data['rating']?.toString() ?? '0.0') ?? 0.0,
                              reviews: int.tryParse(trendingNovel.data['reviews']?.toString() ?? '0') ?? 0,
                              genre: trendingNovel.data['genre'] ?? 'Unknown',
                              chapters: int.tryParse(trendingNovel.data['chapters']?.toString() ?? '0') ?? 0,
                              coverImage: PocketBaseService.getNovelCoverImage(trendingNovel),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      'Fiction', 'Romance', 'Wuxia', 'Sci-Fi',
      'Xiaxia', 'Action', 'Mystery', 'Adventure',
    ];

    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Chip(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    label: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularNovels(BuildContext context) {
    final crossAxisCount = ResponsiveHelper.getResponsiveValue(
      context: context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

    return FutureBuilder<List<RecordModel>>(
      future: PocketBaseService.fetchNovels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          print('Error fetching novels: ${snapshot.error}');
          return const Center(child: Text('Gagal memuat data novel'));
        }
        final novels = snapshot.data!;

        return Padding(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Now',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: novels.length,
                itemBuilder: (context, index) {
                  final novel = novels[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/novel-detail',
                        arguments: Novel(
                          id: novel.id,
                          title: novel.data['title'] ?? 'No Title',
                          author: novel.data['author'] ?? 'Unknown',
                          rating: double.tryParse(novel.data['rating']?.toString() ?? '0.0') ?? 0.0,
                          reviews: int.tryParse(novel.data['reviews']?.toString() ?? '0') ?? 0,
                          genre: novel.data['genre'] ?? 'Unknown',
                          chapters: int.tryParse(novel.data['chapters']?.toString() ?? '0') ?? 0,
                          coverImage: PocketBaseService.getNovelCoverImage(novel),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: PocketBaseService.getNovelCoverImage(novel),
                                fit: BoxFit.cover,
                                height: 140,
                                width: double.infinity,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Container(
                                  height: 140,
                                  color: Colors.grey[300],
                                  child: const Center(child: Icon(Icons.error, color: Colors.red)),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(
                                    (novel.data['is_bookmarked'] ?? false)
                                        ? PlatformDetector.isIOS()
                                            ? CupertinoIcons.heart_fill
                                            : Icons.favorite
                                        : PlatformDetector.isIOS()
                                            ? CupertinoIcons.heart
                                            : Icons.favorite_border,
                                    size: 16,
                                    color: (novel.data['is_bookmarked'] ?? false) ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    try {
                                      await PocketBaseService.addBookmark(novel.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Novel ditambahkan ke bookmark')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Gagal menambahkan bookmark: $e')),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    novel.data['title'] ?? 'No Title',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    novel.data['author'] ?? 'Unknown',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        PlatformDetector.isIOS()
                                            ? CupertinoIcons.star_fill
                                            : Icons.star,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        (novel.data['rating']?.toString() ?? '0.0'),
                                        style: TextStyle(
                                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          '(${novel.data['reviews'] != null ? (int.parse(novel.data['reviews'].toString()) / 1000).toStringAsFixed(1) : '0'}k)',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContinueReading(BuildContext context) {
    return FutureBuilder<List<RecordModel>>(
      future: PocketBaseService.fetchBookmarks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          print('Error fetching bookmarks: ${snapshot.error}');
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Belum ada yang dibaca'),
          );
        }

        final bookmark = snapshot.data!.last;
        final novelId = bookmark.data['novel_id'];
        final chapterNumber = bookmark.data['chapter_number'] as int? ?? 0;
        final totalChapters = int.tryParse(bookmark.data['total_chapters']?.toString() ?? '0') ?? 0;
        final progress = totalChapters > 0 ? (chapterNumber / totalChapters).clamp(0.0, 1.0) : 0.0;

        return FutureBuilder<RecordModel>(
          future: PocketBaseService.fetchNovel(novelId),
          builder: (context, novelSnapshot) {
            if (novelSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (novelSnapshot.hasError || !novelSnapshot.hasData) {
              print('Error fetching novel: ${novelSnapshot.error}');
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Data novel tidak ditemukan'),
              );
            }

            final novel = novelSnapshot.data!;
            return Padding(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Continue Reading',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: PocketBaseService.getNovelCoverImage(novel),
                            fit: BoxFit.cover,
                            width: 60,
                            height: 90,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                              width: 60,
                              height: 90,
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.error, color: Colors.red)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  novel.data['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Chapter $chapterNumber of $totalChapters',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey[200],
                                    color: Theme.of(context).primaryColor,
                                    minHeight: 6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${(progress * 100).toStringAsFixed(0)}% completed',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                                      ),
                                    ),
                                    AdaptiveButton(
                                      label: 'Continue',
                                      onPressed: chapterNumber > 0 ? () {
                                        Navigator.pushNamed(
                                          context,
                                          '/reader',
                                          arguments: {
                                            'novelId': novelId,
                                            'chapterId': chapterNumber.toString(),
                                            'title': novel.data['title'],
                                          },
                                        );
                                      } : () {}, // Fungsi kosong jika chapterNumber <= 0
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNewReleases(BuildContext context) {
    final itemHeight = ResponsiveHelper.getResponsiveValue(
      context: context,
      mobile: 220.0,
      tablet: 240.0,
      desktop: 260.0,
    );

    return FutureBuilder<List<RecordModel>>(
      future: PocketBaseService.fetchNovels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          print('Error fetching novels: ${snapshot.error}');
          return const Center(child: Text('Gagal memuat data novel'));
        }
        final novels = snapshot.data!;

        return Padding(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Releases',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: itemHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: novels.length,
                  itemBuilder: (context, index) {
                    final novel = novels[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/novel-detail',
                          arguments: Novel(
                            id: novel.id,
                            title: novel.data['title'] ?? 'No Title',
                            author: novel.data['author'] ?? 'Unknown',
                            rating: double.tryParse(novel.data['rating']?.toString() ?? '0.0') ?? 0.0,
                            reviews: int.tryParse(novel.data['reviews']?.toString() ?? '0') ?? 0,
                            genre: novel.data['genre'] ?? 'Unknown',
                            chapters: int.tryParse(novel.data['chapters']?.toString() ?? '0') ?? 0,
                            coverImage: PocketBaseService.getNovelCoverImage(novel),
                          ),
                        );
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(PocketBaseService.getNovelCoverImage(novel)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              novel.data['title'] ?? 'No Title',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              novel.data['author'] ?? 'Unknown',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}