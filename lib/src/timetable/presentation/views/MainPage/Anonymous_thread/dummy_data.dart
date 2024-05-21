class Post {
  final String id;
  final String category;
  final String title;
  final String content;
  final List<String> imageUrls;
  final BoardType boardType;
  final int commentCount;
  final String datePosted;
  final int viewCount;
  int likesCount; // final을 제거하여 값을 변경할 수 있도록 함
  final List<Comment> comments;
  final String author;

  Post({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.boardType,
    required this.commentCount,
    required this.datePosted,
    required this.viewCount,
    this.likesCount = 0,
    this.comments = const [],
    required this.author,
  });
}


class Comment {
  final int? id; // Nullable int로 변경
  final String content;
  final String datePosted;
  final int likesCount;
  final List<Comment> replies; // 답글 목록

  Comment({
    required this.content,
    required this.datePosted,
    this.likesCount = 0,
    this.replies = const [],
    this.id, // Nullable int로 변경
  });
}


enum BoardType {
  freshman,
  certification,
  entrepreneurship,
  employment,
  club,
  free,
  scholarship,
  schoolevent
}

String boardTypeToString(BoardType type) {
  switch (type) {
    case BoardType.freshman:
      return "新入生";
    case BoardType.certification:
      return "資格";
    case BoardType.entrepreneurship:
      return "起業";
    case BoardType.employment:
      return "就活";
    case BoardType.club:
      return "部活・クラブ";
    case BoardType.free:
      return "知恵箱";
    case BoardType.schoolevent:
      return "学内イベント";
    default:
      return "悩み相談";
  }
}




final List<Post> dummyPosts = [
  Post(
    id: '1',
    category: '就活', 
    title: '面接のコツ', 
    content: '面接官からの質問に答える際は、結論から伝えることが大切です。これはPREP法といって、ビジネスの基本的なコミュニケーションの方法とされています。',
    imageUrls: [
      'https://cdn-media.port-career.com/portcarrercom/prod/portcareer/wp-content/uploads/2022/05/17143907/623acd0ea35ed21b164538749adea687.jpg'
    ],
    boardType: BoardType.employment,
    commentCount: 10,
    datePosted: '2024-03-12',
    viewCount: 150,
    author: 'Tokyo',
  ),
  Post(
    id: '2',
    category: '自由', 
    title: '簿記２級取れた！！', 
    content: '２０２１年２月実施の第１５７回日商簿記検定に合格しました。',
    imageUrls: [
      'https://bokikaikei.info/wp-content/uploads/2021/04/157boki2ytg.png'
    ],
    boardType: BoardType.free,
    commentCount: 7,
    datePosted: '2024-03-09',
    viewCount: 300,
    author: 'Singapore',
  ),
  Post(
    id: '3',
    category: '起業', 
    title: '京都府のスタートアップ支援', 
    content: 'この補助金は、地域の課題解決を通じて地方創生を促進することを目的とし、京都府内で新たに起業する人や事業承継・第二創業する人に対して、起業に必要な経費の一部を助成します。',
    imageUrls: [
      'https://taxlabor.com/web/wp-content/uploads/2023/05/070.png'
    ],
    boardType: BoardType.entrepreneurship,
    commentCount: 7,
    datePosted: '2024-03-12',
    viewCount: 200,
    author: 'London',
  ),
  Post(
    id: '4',
    category: '学生支援',
    title: '学内奨学金情報',
    content: '【立命館大学おすすめ奨学金8選！】奨学金の基礎知識、申し込みスケジュールと立命館大学のおすすめ奨学金を徹底解説！',
    imageUrls: [
      'https://image.gaxi.jp/article_1646718701418.png', 
      'https://image.gaxi.jp/article_1646673784650.png',
      'https://image.gaxi.jp/article_1646673791518.png', 
      'https://image.gaxi.jp/article_1646673803846.png'
    ],
    boardType: BoardType.scholarship,
    commentCount: 10,
    datePosted: '2024-03-11',
    viewCount: 500,
    likesCount: 120,
    comments: [
      Comment(
        id: 1,
        content: "정말 유용한 정보네요! 감사합니다.",
        datePosted: "2024-03-12 10:30",
      ),
      Comment(
        id: 2,
        content: "저도 지원해봐야겠어요!",
        datePosted: "2024-03-12 11:20",
      ),
      Comment(
        id: 3,
        content: "장학금 정보 찾고 있었는데 딱이네요.",
        datePosted: "2024-03-12 13:45",
      ),
    ],
    author: 'Paris',
  ),
  Post(
    id: '5',
    category: '学内イベント', 
    title: '2023年OIC学園祭', 
    content: '学園祭実行委員長の石川寛太さん（映像4）は「あいにくの天候ではあったが、多くの来場者に来ていただけて非常に良かった。今後予定されるOIC（大阪いばらきキャンパス）とBKCの2つの学園祭は、それぞれの特色をもっている学園祭になるはず。来場者の方や出演する団体が楽しめて充実できる学園祭にしていきたい」と語った。',
    imageUrls: [
      'https://ritsumeikanunivpress.com/wp-content/uploads/2022/11/中央ステージ%E3%80%80立命館大学応援団--scaled.jpg'
    ],
    boardType: BoardType.schoolevent,
    commentCount: 12,
    datePosted: '2024-03-14',
    viewCount: 210,
    author: 'Berlin',
  ),
  Post(
    id: '6',
    category: '起業',
    title: '京都府のスタートアップ支援',
    content: 'この補助金は、地域の課題解決を通じて地方創生を促進することを目的とし、京都府内で新たに起業する人や事業承継・第二創業する人に対して、起業に必要な経費の一部を助成します。',
    imageUrls: [],
    boardType: BoardType.entrepreneurship,
    commentCount: 7,
    datePosted: '2024-03-12',
    viewCount: 200,
    author: 'Rome',
  ),
  Post(
    id: '7',
    category: '起業',
    title: 'スタートアップイベント情報',
    content: '新たなビジネスチャンスを見つけるためのイベントが開催されます。興味のある方はぜひご参加ください。',
    imageUrls: [],
    boardType: BoardType.entrepreneurship,
    commentCount: 12,
    datePosted: '2024-03-10',
    viewCount: 150,
    author: 'Vienna',
  ),
  Post(
    id: '8',
    category: '起業',
    title: '起業家のための情報交換会',
    content: '起業家同士の交流を目的としたイベントが開催されます。積極的な参加をお待ちしています。',
    imageUrls: [],
    boardType: BoardType.entrepreneurship,
    commentCount: 5,
    datePosted: '2024-03-14',
    viewCount: 80,
    author: 'Moscow',
  ),
  Post(
    id: '9',
    category: '起業',
    title: '起業に向けたスキルアップセミナー',
    content: '起業家になるためのスキルを磨くためのセミナーが行われます。参加することで新たなアイデアを得るチャンスです。',
    imageUrls: [],
    boardType: BoardType.entrepreneurship,
    commentCount: 8,
    datePosted: '2024-03-08',
    viewCount: 120,
    author: 'Madrid',
  ),
  Post(
    id: '10',
    category: '起業',
    title: '新たなビジネスアイデアについて',
    content: '新しいビジネスアイデアについてのディスカッションを行います。参加者募集中です。',
    imageUrls: [],
    boardType: BoardType.entrepreneurship,
    commentCount: 15,
    datePosted: '2024-03-16',
    viewCount: 180,
    author: 'Helsinki',
  ),
  Post(
    id: '11',
    category: '起業',
    title: '起業家のための資金調達セミナー',
    content: '起業家のための資金調達に関するセミナーが開催されます。資金調達のポイントを学ぶ絶好の機会です。',
    imageUrls: [],
    boardType: BoardType.entrepreneurship,
    commentCount: 9,
    datePosted: '2024-03-20',
    viewCount: 220,
    author: 'Lisbon',
  ),
  Post(
    id: '12',
    category: '起業',
    title: 'ビジネスプランコンテストのお知らせ',
    content: 'ビジネスプランコンテストが開催されます。優れたアイデアを持つ方はぜひ応募してください。',
    imageUrls: [],
    boardType: BoardType.entrepreneurship,
    commentCount: 6,
    datePosted: '2024-03-18',
    viewCount: 150,
    author: 'Prague',
  ),
  Post(
    id: '13',
    category: '起業',
    title: '地域活性化プロジェクトの参加者募集',
    content: '地域活性化を目指すプロジェクトに参加する起業家を募集します。地域社会への貢献の機会です。',
    imageUrls: [],
    boardType: BoardType.entrepreneurship,
    commentCount: 11,
    datePosted: '2024-03-22',
    viewCount: 190,
    author: 'Athens',
  ),
];
