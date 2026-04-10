import 'package:flutter/material.dart';

const Map<String, IconData> kIconMap = {
  // Income
  'attach_money': Icons.attach_money,
  'payments': Icons.payments,
  'account_balance': Icons.account_balance,
  'savings': Icons.savings,
  'wallet': Icons.wallet,
  'business': Icons.business,
  'work_outline': Icons.work_outline,
  'work': Icons.work,
  'trending_up': Icons.trending_up,
  'card_giftcard': Icons.card_giftcard,
  'volunteer_activism': Icons.volunteer_activism,

  // Food & Dining
  'restaurant': Icons.restaurant,
  'fastfood': Icons.fastfood,
  'local_cafe': Icons.local_cafe,
  'local_bar': Icons.local_bar,
  'cake': Icons.cake,
  'set_meal': Icons.set_meal,
  'lunch_dining': Icons.lunch_dining,
  'bakery_dining': Icons.bakery_dining,

  // Shopping
  'shopping_cart': Icons.shopping_cart,
  'shopping_bag': Icons.shopping_bag,
  'store': Icons.store,
  'local_mall': Icons.local_mall,
  'checkroom': Icons.checkroom,
  'redeem': Icons.redeem,

  // Transport
  'directions_car': Icons.directions_car,
  'directions_bus': Icons.directions_bus,
  'local_taxi': Icons.local_taxi,
  'flight': Icons.flight,
  'train': Icons.train,
  'two_wheeler': Icons.two_wheeler,
  'local_gas_station': Icons.local_gas_station,

  // Housing
  'home': Icons.home,
  'apartment': Icons.apartment,
  'bed': Icons.bed,
  'kitchen': Icons.kitchen,
  'chair': Icons.chair,
  'plumbing': Icons.plumbing,
  'electrical_services': Icons.electrical_services,

  // Health
  'local_hospital': Icons.local_hospital,
  'medical_services': Icons.medical_services,
  'fitness_center': Icons.fitness_center,
  'spa': Icons.spa,
  'medication': Icons.medication,

  // Entertainment
  'movie': Icons.movie,
  'movie_filter': Icons.movie_filter,
  'music_note': Icons.music_note,
  'sports_esports': Icons.sports_esports,
  'beach_access': Icons.beach_access,
  'sports_soccer': Icons.sports_soccer,
  'casino': Icons.casino,
  'theater_comedy': Icons.theater_comedy,

  // Education
  'school': Icons.school,
  'book': Icons.book,
  'library_books': Icons.library_books,
  'computer': Icons.computer,
  'science': Icons.science,

  // Utilities
  'bolt': Icons.bolt,
  'water_drop': Icons.water_drop,
  'wifi': Icons.wifi,
  'phone_android': Icons.phone_android,
  'tv': Icons.tv,
  'thermostat': Icons.thermostat,

  // Misc
  'pets': Icons.pets,
  'child_care': Icons.child_care,
  'elderly': Icons.elderly,
  'celebration': Icons.celebration,
  'local_florist': Icons.local_florist,
  'more_horiz': Icons.more_horiz,
};

/// Ordered categories for the icon picker UI.
/// Each entry: category label → list of keys from [kIconMap].
const Map<String, List<String>> kIconCategories = {
  'Income': [
    'attach_money',
    'payments',
    'account_balance',
    'savings',
    'wallet',
    'business',
    'work_outline',
    'work',
    'trending_up',
    'card_giftcard',
    'volunteer_activism',
  ],
  'Food & Dining': [
    'restaurant',
    'fastfood',
    'local_cafe',
    'local_bar',
    'cake',
    'set_meal',
    'lunch_dining',
    'bakery_dining',
  ],
  'Shopping': [
    'shopping_cart',
    'shopping_bag',
    'store',
    'local_mall',
    'checkroom',
    'redeem',
  ],
  'Transport': [
    'directions_car',
    'directions_bus',
    'local_taxi',
    'flight',
    'train',
    'two_wheeler',
    'local_gas_station',
  ],
  'Housing': [
    'home',
    'apartment',
    'bed',
    'kitchen',
    'chair',
    'plumbing',
    'electrical_services',
  ],
  'Health': [
    'local_hospital',
    'medical_services',
    'fitness_center',
    'spa',
    'medication',
  ],
  'Entertainment': [
    'movie',
    'movie_filter',
    'music_note',
    'sports_esports',
    'beach_access',
    'sports_soccer',
    'casino',
    'theater_comedy',
  ],
  'Education': [
    'school',
    'book',
    'library_books',
    'computer',
    'science',
  ],
  'Utilities': [
    'bolt',
    'water_drop',
    'wifi',
    'phone_android',
    'tv',
    'thermostat',
  ],
  'Misc': [
    'pets',
    'child_care',
    'elderly',
    'celebration',
    'local_florist',
    'more_horiz',
  ],
};

IconData iconFromName(String? name) =>
    kIconMap[name] ?? Icons.label_outline;
