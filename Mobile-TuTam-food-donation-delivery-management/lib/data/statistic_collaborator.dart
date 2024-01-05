class StatisticCollaborator{
  final String name;
  final int requests;
  final int distances;
  final int times;

  const StatisticCollaborator({
    required this.name,
    required this.requests,
    required this.distances,
    required this.times
  }); 

  static List<StatisticCollaborator> list = [
    const StatisticCollaborator(name: 'Hôm nay - (10 chuyến)', requests: 10, distances: 100, times: 200),
    const StatisticCollaborator(name: 'Hôm qua - (11 chuyến)', requests: 12, distances: 120, times: 250),
    const StatisticCollaborator(name: 'Tổng - (57 chuyến)', requests: 120, distances: 1100, times: 2000),

  ];
}

