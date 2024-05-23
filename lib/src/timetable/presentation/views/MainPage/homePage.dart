import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/dummy_data.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/post_detail.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Opportuities_hub/Op_database.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Opportuities_hub/OpportunityDetailPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/detailedInfoPage.dart';
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
            backgroundColor: Colors.grey[300],
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
    required List<Widget> buttons,
  }) {
    return Container(
      width: 250,
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
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buttons,
          ),
        ],
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
            '掲示板リスト',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          _buildBoardSectionTabs(context),
          _buildBoardPreviewPosts(context),
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
            margin: const EdgeInsets.symmetric(vertical: 4),
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
              height: 100, // Reduced height for each post preview
              child: Row(
                children: [
                  if (post.imageUrls.isNotEmpty)
                    Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(post.imageUrls[0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                          post.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Limit the title to 1 line
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
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.comment, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  "${post.commentCount}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "閲覧数 ${post.viewCount}",
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

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: topPosts.length,
      separatorBuilder: (context, index) => const Divider(color: Colors.grey),
      itemBuilder: (context, index) {
        final post = topPosts[index];
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
            padding: const EdgeInsets.all(8.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${post.commentCount}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            "コメント",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.comment, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "${post.commentCount}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "閲覧数 ${post.viewCount}",
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
      },
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16), // 아이콘과 화면 좌측 사이의 간격 조정
                    _buildTile(
                      context,
                      icon: Icons.school,
                      title: 'Manaba+R',
                      subtitle: '',
                      onTap: () => openUrl('https://ct.ritsumei.ac.jp/ct/'),
                      color: Colors.black,
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
                      color: Colors.black,
                    ),
                    const SizedBox(width: 16), // 아이콘 사이의 간격 조정
                    _buildTile(
                      context,
                      icon: Icons.schedule,
                      title: '授業',
                      subtitle: 'スケジュール',
                      onTap: () => openUrl('https://www.ritsumei.ac.jp/file.jsp?id=606518'),
                      color: Colors.black,
                    ),
                    const SizedBox(width: 16), // 아이콘 사이의 간격 조정
                    _buildTile(
                      context,
                      icon: Icons.library_books,
                      title: '図書館',
                      subtitle: '',
                      onTap: () => openUrl('https://runners.ritsumei.ac.jp/opac/opac_search/?lang=0'),
                      color: Colors.black,
                    ),
                    const SizedBox(width: 16), // 아이콘 사이의 간격 조정
                    _buildTile(
                      context,
                      icon: Icons.directions_bus_filled,
                      title: 'シャトルバス',
                      subtitle: '',
                      onTap: () => openUrl('https://www.ritsumei.ac.jp/file.jsp?id=566535'),
                      color: Colors.black,
                    ),
                    const SizedBox(width: 16), // 아이콘 사이의 간격 조정
                    _buildTile(
                      context,
                      icon: Icons.public,
                      title: '大学',
                      subtitle: 'ホームページ',
                      onTap: () => openUrl('https://en.ritsumei.ac.jp/'),
                      color: Colors.black,
                    ),
                    const SizedBox(width: 16), // 아이콘과 화면 우측 사이의 간격 조정
                  ],
                ),
              ),
              const SizedBox(height: 10), // 조정된 간격
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildInfoCard(
                      context,
                      title: '今日の予定',
                      subtitle: '2月 22日(木)',
                      buttons: [
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
                        IconButton(
                          icon: const Icon(Icons.list, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TodolistPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    _buildInfoCard(
                      context,
                      title: '新学期を始めよう!',
                      subtitle: '学割、募集中の部活など',
                      buttons: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedInfoPage(),
                              ),
                            );
                          },
                          child: const Text(
                            '詳しく見る',
                            style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    _buildInfoCard(
                      context,
                      title: '時間割をDIYしよう',
                      subtitle: '講義選びのコツや効率的な時間割作成方法など',
                      buttons: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            '詳しく見る',
                            style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    _buildInfoCard(
                      context,
                      title: '卒業生後もユニベリと一緒に',
                      subtitle: '卒業生アカウントに転換する',
                      buttons: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            '詳しく見る',
                            style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // 위젯 간격 조정
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '現在人気の投稿',
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
