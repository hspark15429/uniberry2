import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/BoardPostsPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/dummy_data.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/post_detail.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Opportuities_hub/Op_database.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Opportuities_hub/OpportunityDetailPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/freemarketPage/freemarket.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/todolist_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/settiing/notificationPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/settiing/scrapPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/settiing/setting_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/homePage';

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool isBoardListExpanded = false;
  int _currentPage = 0;
  BoardType? selectedBoardType;
  int currentPageIndex = 0;
  List<TodoItem> todoList = []; // To-Do 리스트를 위한 추가

  Future<void> openUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await canLaunchUrl(_url)) {
      throw 'Could not launch $url';
    } else {
      await launchUrl(_url);
    }
  }

  List<Post> getFilteredPosts() {
    if (selectedBoardType == null) {
      return dummyPosts;
    }
    return dummyPosts.where((post) => post.boardType == selectedBoardType).toList();
  }

  List<Post> getSortedPosts() {
    List<Post> filteredPosts = getFilteredPosts();
    filteredPosts.sort((a, b) => b.datePosted.compareTo(a.datePosted));
    return filteredPosts;
  }

  List<TodoItem> _getTodayTodoItems() {
    final DateTime today = DateTime.now();
    return todoList.where((todo) {
      return todo.date.year == today.year && todo.date.month == today.month && todo.date.day == today.day;
    }).toList();
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    void Function()? onTap,
    Color color = Colors.black,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white, // Colors.grey[300],
            radius: 30,
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    List<Widget>? buttons,
    List<TodoItem>? todoItems,
  }) {
    return GestureDetector(
      onTap: buttons != null ? () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TodolistPage()),
        );
      } : null, // buttons가 있을 때만 동작하도록 설정
      child: Container(
        width: 1.2 * 250, // 폭을 1.2배로 설정
        height: 2 * 100, // 높이를 2배로 설정
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (buttons != null)
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TodolistPage(openAddDialog: true),
                        ),
                      );
                    },
                  ),
              ],
            ),
            Text(
              subtitle,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            if (todoItems != null && todoItems.isNotEmpty)
              ...todoItems.map((todo) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: todo.tagColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          color: todo.tagColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (todo.startTime != null)
                        Text(
                          '${todo.startTime?.format(context) ?? ''} - ${todo.endTime?.format(context) ?? ''}',
                          style: const TextStyle(color: Colors.black),
                        ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardListCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '게시판리스트',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          _buildBoardSectionTabs(context),
          _buildBoardPreviewPosts(context),
          if (selectedBoardType != null) // 조건 추가: 태그가 ALL이 아닐 때만 버튼을 표시
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoardPostsPage(boardName: boardTypeToString(selectedBoardType!)),
                  ),
                );
              },
              child: const Text(
                '전체 게시물 보기',
                style: TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBoardSectionTabs(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedBoardType = null;
              });
            },
            child: const Text('ALL', style: TextStyle(color: Colors.black)),
          ),
          ...BoardType.values.map((boardType) {
            return TextButton(
              onPressed: () {
                setState(() {
                  selectedBoardType = boardType;
                });
              },
              child: Text(
                boardTypeToString(boardType),
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

 Widget _buildBoardPreviewPosts(BuildContext context) {
  List<Post> sortedPosts = getSortedPosts();
  List<Post> previewPosts = sortedPosts.take(5).toList();

  String shortenText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    } else {
      return text;
    }
  }

  return Column(
    children: previewPosts.map((post) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(post: post),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SizedBox(
            height: 150, // 높이를 150으로 설정하여 각 게시물의 높이를 키움
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "#${post.category}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shortenText(post.title, 14),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // 제목을 1줄로 제한
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "작성자: ${post.author} · ${post.datePosted}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
shortenText(post.content, 50),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
maxLines: 2, // 
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.visibility, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${post.viewCount}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.thumb_up, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${post.likesCount}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.comment, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${post.commentCount}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (post.imageUrls.isNotEmpty)
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(post.imageUrls[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );
}



  Widget _buildAllPosts(BuildContext context) {
    List<Post> sortedPosts = List.from(dummyPosts)
      ..sort((a, b) {
        int compare = b.viewCount.compareTo(a.viewCount);
        if (compare == 0) {
          return b.commentCount.compareTo(a.commentCount);
        }
        return compare;
      });

    List<Post> topPosts = sortedPosts.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.3)), // 연한 선으로 설정
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: topPosts.map((post) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailPage(post: post),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${post.category}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "작성자: ${post.author} · ${post.datePosted}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thumb_up, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${post.likesCount}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.comment, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${post.commentCount}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey),
                          ),
                        ],
                      ),
                      Text(
                        "조회수 ${post.viewCount}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOpportunitiesBox(BuildContext context) {
    final PageController pageController = PageController(viewportFraction: 0.8);

    return Column(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: PageView.builder(
            itemCount: dummyOpportunities.length,
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final opportunity = dummyOpportunities[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            opportunity.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          subtitle: Text(
                            opportunity.description,
                            style: const TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OpportunityDetailPage(opportunity: opportunity),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Row(
                        children: [
                          const Icon(Icons.visibility, size: 20, color: Colors.black), // 조회수 아이콘
                          const SizedBox(width: 4), // 아이콘과 숫자 사이의 간격
                          Text('${opportunity.viewCount}', style: const TextStyle(color: Colors.black)), // 조회수 숫자
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        PageViewDotIndicator(
          currentItem: _currentPage,
          count: dummyOpportunities.length,
          unselectedColor: Colors.grey,
          selectedColor: Colors.black,
          size: const Size(8, 8),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TodoItem> todayTodoItems = _getTodayTodoItems();

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {},
          child: const Text('Home', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkManagerPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTile(
                        context,
                        icon: Icons.school,
                        title: 'Manaba+R',
                        subtitle: '',
                        onTap: () => openUrl('https://ct.ritsumei.ac.jp/ct/'),
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 16), // 아이콘 사이의 간격 조정
                      _buildTile(
                        context,
                        icon: Icons.shopping_basket,
                        title: 'フリーマ',
                        subtitle: '',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FreeMarketPage()),
                          );
                        },
                        color: Colors.orangeAccent,
                      ),
                      const SizedBox(width: 16), // 아이콘 사이의 간격 조정
                      _buildTile(
                        context,
                        icon: Icons.schedule,
                        title: '授業',
                        subtitle: 'スケジュール',
                        onTap: () => openUrl('https://www.ritsumei.ac.jp/file.jsp?id=606518'),
                        color: Colors.green,
                      ),
                      const SizedBox(width: 16), // 아이콘 사이의 간격 조정
                      _buildTile(
                        context,
                        icon: Icons.library_books,
                        title: '図書館',
                        subtitle: '',
                        onTap: () => openUrl('https://runners.ritsumei.ac.jp/opac/opac_search/?lang=0'),
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 16), // 아이콘 사이의 간격 조정
                      _buildTile(
                        context,
                        icon: Icons.directions_bus_filled,
                        title: 'シャトルバス',
                        subtitle: '',
                        onTap: () => openUrl('https://www.ritsumei.ac.jp/file.jsp?id=566535'),
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 16), // 아이콘 사이의 간격 조정
                      _buildTile(
                        context,
                        icon: Icons.public,
                        title: '大学',
                        subtitle: 'ホームページ',
                        onTap: () => openUrl('https://en.ritsumei.ac.jp/'),
                        color: Colors.purpleAccent,
                      ),
                      const SizedBox(width: 16), // 아이콘과 화면 우측 사이의 간격 조정
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // 앱바와 아이콘 간의 간격
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildInfoCard(
                      context,
                      title: '오늘의예정',
                      subtitle: DateFormat('M月 d日(E)', 'ja').format(DateTime.now()), // 오늘 날짜를 표시
                      buttons: [], // 아이콘을 삭제했으므로 빈 리스트
                      todoItems: todayTodoItems, // 오늘 일정을 보여주기 위해 추가
                    ),
                    _buildInfoCard(
                      context,
                      title: '新学期を始めよう!',
                      subtitle: '学割、募集中の部活など',
                    ),
                    _buildInfoCard(
                      context,
                      title: '時間割をDIYしよう',
                      subtitle: '講義選びのコツや効率的な時間割作成方法など',
                    ),
                    _buildInfoCard(
                      context,
                      title: '卒業生後もユニベリと一緒に',
                      subtitle: '卒業生アカウントに転換する',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // 위젯 간격 조정
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '인기글',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildAllPosts(context),
              const SizedBox(height: 20),
              _buildBoardListCard(context),
              const SizedBox(height: 20),
              _buildOpportunitiesBox(context),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoItem {
  final String title;
  final bool isAllDay;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Color tagColor;
  final DateTime date;

  TodoItem({
    required this.title,
    this.isAllDay = false,
    this.startTime,
    this.endTime,
    required this.tagColor,
    required this.date,
  });
}
