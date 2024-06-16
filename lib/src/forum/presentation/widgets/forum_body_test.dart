import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              AnnouncementItem('assets/horse_riding.png', 'Horse Riding'),
              AnnouncementItem('assets/tennis.png', 'Tennis Club'),
              AnnouncementItem('assets/reading.png', 'Book Club'),
              AnnouncementItem('assets/cycling.png', 'Cycling'),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              AnnouncementItem('assets/hospital.png', 'Hospital'),
              AnnouncementItem('assets/baseball.png', 'Baseball'),
              AnnouncementItem('assets/basketball.png', 'Basketball'),
              AnnouncementItem('assets/football.png', 'Football'),
            ],
          ),
        ),
        ListView.builder(
          itemCount: 20, // Replace with your dynamic data count
          itemBuilder: (context, index) {
            return ContentItem();
          },
        ),
      ],
    );
  }
}

class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem(this.imagePath, this.title, {super.key});

  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset(imagePath, width: 60, height: 60),
          Text(title),
        ],
      ),
    );
  }
}

class ContentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sample Content Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('This is a sample description for the content item.'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Category', style: TextStyle(color: Colors.grey)),
                Text('Time', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
