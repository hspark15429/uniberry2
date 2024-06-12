class BookmarkService {
  factory BookmarkService() => _instance;
  // 싱글톤 패턴 구현
  BookmarkService._privateConstructor();
  static final BookmarkService _instance = BookmarkService._privateConstructor();

  
  // 북마크된 게시물 ID 목록
  final Set<int> _bookmarkedPostIds = {};

  // 북마크 추가
  void addBookmark(int postId) {
    _bookmarkedPostIds.add(postId);
  }

  // 북마크 제거
  void removeBookmark(int postId) {
    _bookmarkedPostIds.remove(postId);
  }

  // 북마크 확인
  bool isBookmarked(int postId) {
    return _bookmarkedPostIds.contains(postId);
  }

  // 북마크된 모든 게시물 ID 가져오기
  Set<int> getBookmarkedPosts() {
    return _bookmarkedPostIds;
  }

  
}
