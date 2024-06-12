

final List<Opportunity> dummyOpportunities = [
  Opportunity(
    category: '奨学金',
    title: '「新1年生対象」返済不要の給付型奨学金',
    description: 'キーエンス　',
    imageUrls: [
      'https://pbs.twimg.com/media/F5z7dvQaEAAtm67.png',
    ],
    additionalInfo: '奨学生の募集は2024年4月5日午前10時に終了します',
      viewCount: 150, // 조회수 추가
  ),
  Opportunity(
    category: 'Volunteering',
    title: 'Community Clean-up Drive',
    description: 'Participate in our community clean-up drive and help us make our city cleaner.',
    imageUrls: [
      'https://kddi-h.assetsadobe3.com/is/image/content/dam/au-com/mobile/campaign/sale2402/images/mb_sale2402_bnr_01.jpg?scl=1&qlt=90',
      'https://example.com/image4.jpg',
    ],
    additionalInfo: 'Date: May 5, 2024. Location: Central Park.',
      viewCount: 350, // 조회수 추가
  ),
  Opportunity(
    category: 'Internship',
    title: 'Marketing Internship',
    description: 'Gain real-world experience with our 6-month marketing internship program.',
    imageUrls: [
      'https://example.com/image5.jpg',
    ],
    additionalInfo: 'Application deadline: March 31, 2024. Remote opportunity.',
      viewCount: 450, // 조회수 추가
  ),
  Opportunity(
    category: 'Scholarship',
    title: 'Undergraduate Scholarship Program',
    description: 'Apply for our undergraduate scholarship program and secure your future.',
    imageUrls: [],
    additionalInfo: 'Eligibility: High school seniors. Deadline: April 30, 2024.',
      viewCount: 550, // 조회수 추가
  ),
  Opportunity(
    category: 'Workshop',
    title: 'Digital Marketing Workshop',
    description: 'Enhance your digital marketing skills with our expert-led workshop.',
    imageUrls: [
      'https://example.com/image6.jpg',
    ],
    additionalInfo: 'Date: June 10, 2024. Location: Online.',
      viewCount: 150, // 조회수 추가
  ),
];

class Opportunity { // 조회수는 변경될 수 있으므로 final 키워드 제거

  Opportunity({
    required this.category,
    required this.title,
    required this.description,
    this.imageUrls = const [],
    this.additionalInfo,
    this.viewCount = 0,
  });
  final String category;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String? additionalInfo;
  int viewCount;

  void incrementViewCount() {
    viewCount += 1;
  }
}
