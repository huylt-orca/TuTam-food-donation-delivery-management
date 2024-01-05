class ReportDeliveryType{
  late final int id;
  late final String description;

  ReportDeliveryType({
    required this.id,
    required this.description
  });

  static List<ReportDeliveryType> sample = [
    ReportDeliveryType(id: 2, description: 'Không thể liên lạc với người quyên góp'),
    ReportDeliveryType(id: 3, description: 'Người quyên góp đã cho hết vật phẩm'),
  ];
}