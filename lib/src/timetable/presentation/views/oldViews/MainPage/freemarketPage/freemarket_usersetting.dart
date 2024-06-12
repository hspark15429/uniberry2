import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSettingPage extends StatelessWidget {
  const UserSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 유저 설정 섹션
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              '유저 설정',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          _buildListTile(context, '계정 관리'),
          _buildListTile(context, '차단한 유저 관리'),
          _buildListTile(context, '내 캠퍼스 변경하기'),
          const Divider(), // 구분선

          // 일반 설정 섹션
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              '일반 설정',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            title: const Text('버전 정보', style: TextStyle(color: Colors.black)),
            subtitle: const Text('현재 버전: 24.4.27', style: TextStyle(color: Colors.grey)),
            onTap: () {
              // 버전 정보 로직
            },
          ),
          _buildListTile(context, '문의하기'),
          _buildListTile(context, '캐시 데이터 삭제하기'),
          _buildListTile(context, '로그아웃'),
          ListTile(
            title: Text(
              '탈퇴하기',
              style: GoogleFonts.roboto(
                color: Colors.red, // 빨간색으로 강조
              ),
            ),
            onTap: () {
              // 탈퇴 로직
            },
          ),
        ],
      ),
    );
  }

  // 리스트 타일을 만드는 함수
  Widget _buildListTile(BuildContext context, String label) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.black)), // 레이블 텍스트
      onTap: () {
        // 각 리스트 타일의 로직
      },
    );
  }
}
