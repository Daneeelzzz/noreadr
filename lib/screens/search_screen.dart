import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/novel.dart';
import '../utils/responsive_helper.dart'; // Added for responsiveness

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;
  List<Novel> _searchResults = []; // To store search results

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _hasSearched = true;
        // Simulate search results (replace with actual API call)
        _searchResults = _generateSearchResults(_searchController.text);
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _hasSearched = false;
      _searchResults.clear();
    });
  }

  // Simulate search results based on query
  List<Novel> _generateSearchResults(String query) {
    final allNovels = [
      Novel(
        id: '1',
        title: "The Dragon's Legacy",
        author: "Sarah Johnson",
        // FIX: Added the required 'description' parameter
        description: "An ancient prophecy, a forgotten kingdom, and a young woman who holds the key to its survival. A thrilling fantasy adventure.",
        rating: 4.9,
        reviews: 2300,
        genreIds: ["fantasy"],
        chapters: 32,
        coverImage: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
      ),
      Novel(
        id: '2',
        title: "Midnight Shadows",
        author: "James Wilson",
        // FIX: Added the required 'description' parameter
        description: "In the rain-slicked streets of a city that never sleeps, a detective hunts a killer who leaves no trace but a single black feather.",
        rating: 4.7,
        reviews: 1800,
        genreIds: ["mystery"],
        chapters: 28,
        coverImage: 'https://images.unsplash.com/photo-1448375240586-882707db888b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
      ),
      Novel(
        id: '3',
        title: "The Lost City",
        author: "Emily Chen",
        // FIX: Added the required 'description' parameter
        description: "An ambitious archaeologist discovers a map that could lead to the legendary lost city of Zerzura, a place of untold riches and deadly secrets.",
        rating: 4.8,
        reviews: 2100,
        genreIds: ["adventure"],
        chapters: 30,
        coverImage: 'https://images.unsplash.com/photo-1518709268805-4e9042af5929?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
      ),
    ];
    return allNovels.where((novel) =>
        novel.title.toLowerCase().contains(query.toLowerCase()) ||
        novel.author.toLowerCase().contains(query.toLowerCase()) ||
        novel.genreIds.any((id) => id.toLowerCase().contains(query.toLowerCase()))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search novels, authors...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (_) => _performSearch(),
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Search Results or Suggestions
          Expanded(
            child: _hasSearched ? _buildSearchResults() : _buildSearchSuggestions(),
          ),
        ],
      ),
      // NOTE: You still need to correctly configure your BottomNavBar.
      // The error in your original post was for the 'Novel' class, but if your
      // BottomNavBar also requires parameters, you'll need to provide them.
      // For example:
      // bottomNavigationBar: BottomNavBar(
      //   items: [...],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
    );
  }

  // ... (Sisa kode tidak berubah)
  Widget _buildSearchResults() {
    return Column(
      children: [
        // Tab Bar
        TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Novels'),
            Tab(text: 'Authors'),
          ],
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // All Tab
              _buildAllResults(),
              // Novels Tab
              _buildNovelResults(filterByNovel: true),
              // Authors Tab
              _buildAuthorResults(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllResults() {
    return ListView.builder(
      padding: ResponsiveHelper.getResponsivePadding(context),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final novel = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/novel-detail',
                arguments: novel,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: novel.coverImage ?? '',
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          novel.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          novel.author,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            novel.genreIds.join(', '), // Join genreIds for display
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNovelResults({bool filterByNovel = false}) {
    final filteredResults = filterByNovel
        ? _searchResults
        : _searchResults; // No additional filtering for now
    return ListView.builder(
      padding: ResponsiveHelper.getResponsivePadding(context),
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final novel = filteredResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/novel-detail',
                arguments: novel,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: novel.coverImage ?? '',
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          novel.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          novel.author,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            novel.genreIds.join(', '), // Join genreIds for display
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthorResults() {
    // Simulate authors based on search results (simplified mapping)
    final authorMap = <String, Map<String, dynamic>>{};
    for (var novel in _searchResults) {
      if (!authorMap.containsKey(novel.author)) {
        authorMap[novel.author] = {
          'id': novel.id,
          'name': novel.author,
          'books': 1, // Increment based on novels
          'genre': novel.genreIds.join(', '), // Join genreIds for display
          'avatar': novel.coverImage,
        };
      } else {
        authorMap[novel.author]!['books']++;
      }
    }
    final authors = authorMap.values.toList();

    return ListView.builder(
      padding: ResponsiveHelper.getResponsivePadding(context),
      itemCount: authors.length,
      itemBuilder: (context, index) {
        final author = authors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: author['avatar'] as String? ?? '',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        author['name'].toString()[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${author['books']} books • ${author['genre']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchSuggestions() {
    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Searches
          Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Fantasy',
              'Romance',
              'Mystery',
              'Adventure',
              'Sci-Fi',
              'Horror',
              'Historical',
              'Young Adult'
            ].map((tag) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchController.text = tag;
                      _hasSearched = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                      ),
                    ),
                  ),
                )).toList(),
          ),

          const SizedBox(height: 24),

          // Recent Searches
          Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              'Dragon Knight',
              'Love in Paris',
              'Mystery of the Ancient Temple'
            ].map((search) => ListTile(
                  leading: const Icon(Icons.search, color: Colors.grey),
                  title: Text(
                    search,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                    ),
                  ),
                  trailing: const Icon(Icons.close, color: Colors.grey),
                  onTap: () {
                    setState(() {
                      _searchController.text = search;
                      _hasSearched = true;
                    });
                  },
                )).toList(),
          ),
        ],
      ),
    );
  }
}