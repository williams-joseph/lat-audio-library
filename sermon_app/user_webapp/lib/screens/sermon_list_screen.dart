import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sermon_provider.dart';
import '../widgets/update_modal.dart';
import 'widgets/install_prompt.dart';
import 'widgets/sermon_card.dart';


class SermonListScreen extends StatelessWidget {
  const SermonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SermonProvider(),
      child: const _SermonListScreenContent(),
    );
  }
}

class _SermonListScreenContent extends StatefulWidget {
  const _SermonListScreenContent();

  @override
  State<_SermonListScreenContent> createState() => _SermonListScreenContentState();
}

class _SermonListScreenContentState extends State<_SermonListScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  late SermonProvider _sermonProvider;
  bool _showUpdateModal = true;
  bool _updateModalShown = false;

  @override
  void initState() {
    super.initState();
    _sermonProvider = Provider.of<SermonProvider>(context, listen: false);

    // Track app usage after screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        Provider.of<SermonProvider>(context, listen: false).incrementAppUsage();
      });
    });
    
    // Show update modal when app starts (only once per session)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showUpdateModal && !_updateModalShown) {
        showUpdateModal(context);
        _showUpdateModal = false;
        _updateModalShown = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sermonProvider = Provider.of<SermonProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sermon Library'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showUpdateModal(context),
            tooltip: 'App Information',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Content
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              
              return Padding(
                padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
                child: Column(
                  children: [
                    // Search Section
                    _buildSearchSection(isMobile),
                    const SizedBox(height: 20),
                    
                    // Sermons List
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _sermonProvider.getSermonsStream(),
                        builder: (context, snapshot) {
                          if (_sermonProvider.hasError) {
                            return _buildErrorState(_sermonProvider.errorMessage);
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildLoadingState();
                          }

                          if (snapshot.hasError) {
                            return _buildErrorState('Stream error: ${snapshot.error}');
                          }

                          if (!snapshot.hasData) {
                            return _buildErrorState('No data received from server');
                          }

                          final sermons = snapshot.data!;
                          
                          if (sermons.isEmpty) {
                            return _buildEmptyState();
                          }

                          _sermonProvider.updateSermons(sermons);

                          final filteredSermons = _sermonProvider.filteredSermons;
                          
                          if (filteredSermons.isEmpty) {
                            return _buildNoResultsState();
                          }

                          return ListView.builder(
                            itemCount: filteredSermons.length,
                            itemBuilder: (context, index) {
                              final sermon = filteredSermons[index];
                              return SermonCard(sermon: sermon);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // PWA Install Prompt Overlay
          if (sermonProvider.showInstallPrompt) ...[
            ModalBarrier(
              color: Colors.black54,
              dismissible: true,
              onDismiss: () => sermonProvider.hideInstallPrompt(),
            ),
            const Center(
              child: InstallPrompt(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchSection(bool isMobile) {
    return Consumer<SermonProvider>(
      builder: (context, sermonProvider, child) {
        return Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                sermonProvider.setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by title, preacher, or date...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          sermonProvider.setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            
            // Sort Options - Use Wrap for better responsiveness
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                const Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.bold)),
                ChoiceChip(
                  label: const Text('Date'),
                  selected: sermonProvider.sortBy == 'date',
                  onSelected: (selected) => sermonProvider.setSortBy('date'),
                ),
                ChoiceChip(
                  label: const Text('Title'),
                  selected: sermonProvider.sortBy == 'title',
                  onSelected: (selected) => sermonProvider.setSortBy('title'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading sermons...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load sermons',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              _sermonProvider.setSearchQuery(_searchController.text);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No sermons available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Check back later for new sermons',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No sermons found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Try different search terms',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}