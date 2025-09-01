import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quotes_provider.dart';
import '../../constants/app_colors.dart';
import '../../widgets/quote_card.dart'; // Import the QuoteCard

class QuotesCategoryScreen extends StatelessWidget {
  final String category;

  const QuotesCategoryScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuotesProvider>(
      builder: (context, quotesProvider, _) {
        final quotes = quotesProvider.categoryQuotes;
        final isLoading = quotesProvider.isLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text(category),
            backgroundColor: AppColors.primary,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : quotes.isEmpty
              ? const Center(child: Text("No quotes available😔"))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              // Find the current favorite status from the provider
              final isCurrentlyFavorite = quotesProvider.favorites
                  .any((favQuote) => favQuote.id == quote.id);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: QuoteCard(
                  quote: quote,
                  isFavorite: isCurrentlyFavorite,
                  onFavoriteToggle: () {
                    quotesProvider.toggleFavorite(quote);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}