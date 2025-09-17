class ApiException implements Exception {
  final String title;
  final String detail;
  final int? status;

  ApiException({required this.title, required this.detail, this.status});

  @override
  String toString() => "$title: $detail";
}
