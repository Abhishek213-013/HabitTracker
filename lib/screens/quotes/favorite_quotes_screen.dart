import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../providers/quotes_provider.dart';
import '../../widgets/quote_card.dart';
import '../../models/quote_model.dart'; // Add this import

class FavoriteQuotesScreen extends StatelessWidget {
  const FavoriteQuotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quotesProvider = Provider.of<QuotesProvider>(context);
    final favorites = quotesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Favorite Quotes😊',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    favorites.length.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.05),
              Colors.white.withOpacity(0.1),
            ],
          ),
        ),
        child: favorites.isEmpty
            ? _buildEmptyState()
            : AnimationLimiter(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await quotesProvider.loadFavorites();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final quote = favorites[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: QuoteCard(
                          quote: quote,
                          isFavorite: true,
                          onFavoriteToggle: () {
                            quotesProvider.toggleFavorite(quote);
                            ScaffoldMessenger.of(context).showSnackBar(
                              _buildRemovedSnackBar(quote.text), // Pass quote.text instead of quote
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.favorite,
            size: 72,
            color: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No favorites yet🤔',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Text(
              'Tap the heart icon on any quote to add it to your favorites❤️',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SnackBar _buildRemovedSnackBar(String quoteText) { // Changed parameter type
    return SnackBar(
      content: Text(
        'Removed from favorites💔: "${_truncateQuote(quoteText)}"',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Colors.white,
        onPressed: () {
          // Note: You'll need to implement undo functionality in your provider
        },
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16),
    );
  }

  String _truncateQuote(String quoteText) { // Changed parameter name for clarity
    const maxLength = 40;
    return quoteText.length > maxLength
        ? '${quoteText.substring(0, maxLength)}...'
        : quoteText;
  }
}