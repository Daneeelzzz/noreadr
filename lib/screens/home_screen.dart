import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/novel.dart';
import '../utils/platform_detector.dart';
import '../utils/responsive_helper.dart';
import '../widgets/adaptive_widgets.dart';
import 'package:pocketbase/pocketbase.dart';
import '../services/pocketbase_service.dart'; // Sesuaikan path jika berbeda



class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final deviceType = ResponsiveHelper.getDeviceType(context);

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: 'Mamamayaan',
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

    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
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
                    "The Dragon's Legacy",
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
                        '4.9 (2.3k readers)',
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
                          id: '1',
                          title: "The Dragon's Legacy",
                          author: "Sarah Johnson",
                          rating: 4.9,
                          reviews: 2300,
                          genre: "Fantasy",
                          chapters: 32,
                          coverImage: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
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
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      'Bread', 'Cake', 'Pastry', 'Mie-Fi',
      'Tea', 'Soup', 'Meatba'
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
    final novels = [
      Novel(
        id: '1',
        title: "The Dragon's Legacy",
        author: "Sarah Johnson",
        rating: 4.9,
        reviews: 2300,
        genre: "Fantasy",
        chapters: 32,
        coverImage: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
      ),
      Novel(
        id: '2',
        title: "Midnight Shadows",
        author: "James Wilson",
        rating: 4.7,
        reviews: 1800,
        genre: "Mystery",
        chapters: 28,
        coverImage: 'https://images.unsplash.com/photo-1448375240586-882707db888b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
      ),
      Novel(
        id: '3',
        title: "The Lost City",
        author: "Emily Chen",
        rating: 4.8,
        reviews: 2100,
        genre: "Adventure",
        chapters: 30,
        coverImage: 'https://images.unsplash.com/photo-1518709268805-4e9042af5929?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
      ),
      Novel(
        id: '4',
        title: "Heart's Desire",
        author: "Michael Brown",
        rating: 4.6,
        reviews: 1500,
        genre: "Romance",
        chapters: 25,
        coverImage: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
      ),
    ];

    final crossAxisCount = ResponsiveHelper.getResponsiveValue(
      context: context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

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
              childAspectRatio: 0.65, // Disesuaikan untuk menghindari overflow
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
                    arguments: novel,
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
                            imageUrl: novel.coverImage,
                            fit: BoxFit.cover,
                            height: 140, // Dikurangi untuk menghindari overflow
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
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                PlatformDetector.isIOS()
                                    ? CupertinoIcons.heart
                                    : Icons.favorite_border,
                                size: 16,
                                color: Colors.grey,
                              ),
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
                                novel.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                novel.author,
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
                                    novel.rating.toString(),
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '(${(novel.reviews / 1000).toStringAsFixed(1)}k)',
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
  }

  Widget _buildContinueReading(BuildContext context) {
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
                    imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af5929?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
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
                          'The Lost City',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chapter 5 of 32',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.45,
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
                              '45% completed',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                              ),
                            ),
                            AdaptiveButton(
                              label: 'Continue',
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/reader',
                                  arguments: {
                                    'novelId': '3',
                                    'chapterId': '5',
                                    'title': 'The Lost City',
                                  },
                                );
                              },
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

      if (snapshot.hasError) {
        return const Center(child: Text('Gagal memuat data novel'));
      }

      final novels = snapshot.data ?? [];

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
                        arguments: novel,
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
                                image: NetworkImage(novel.getStringValue('coverImage')),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            novel.getStringValue('title'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            novel.getStringValue('author'),
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