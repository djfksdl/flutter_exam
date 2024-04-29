import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personVo.dart';


class ReadPage extends StatelessWidget {
  const ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("이연수"),),
      body: Container(
        color: Color(0xFFd6d6d6),
        padding: EdgeInsets.all(10),
        child: _ReadPage(),
      ),
    );
  }
}

//등록
class _ReadPage extends StatefulWidget {
  const _ReadPage({super.key});

  @override
  State<_ReadPage> createState() => _ReadPageState();
}

//할일(통신,데이터)
class _ReadPageState extends State<_ReadPage> {

  //공통변수
  late Future<PersonVo> personVoFuture;

  //초기화
  @override
  void initState() {
    super.initState();
    personVoFuture = getPersonVo();

  }

  //화면 그리기
  @override
  Widget build(BuildContext context) {
    print("그림그리기 작업시작");

    return FutureBuilder(
      future: personVoFuture, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.'));
        } else { //데이터가 있으면
          // _nameController.text = snapshot.data!.name;
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 480,
                    height: 40,
                    color: Color(0xFFffffff),
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text("${snapshot.data!.name}(${snapshot.data!.gender})", style: TextStyle(fontSize: 20),),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 40,
                    color: Color(0xFFffffff),
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text("핸드폰", style: TextStyle(fontSize: 20),),
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    color: Color(0xFFffffff),
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text("${snapshot.data!.hp}", style: TextStyle(fontSize: 20),),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 400,
                    color: Color(0xFFffffff),
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text("회사", style: TextStyle(fontSize: 20),),
                  ),
                  Container(
                    width: 400,
                    height: 400,
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    color: Color(0xFFffffff),
                    child: Text("${snapshot.data!.company}", style: TextStyle(fontSize: 20),),
                  )
                ],
              ),

            ],
          );
        } // 데이터가있으면
      },
    );
    ;
  }



  //데이터 가져오기
  Future<PersonVo> getPersonVo() async {
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();
      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';
        // 서버 요청
      final response = await dio.get(
        'http://15.164.245.216:9000/api/myclass',
      );
      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
      //접속성공 200 이면
        print(response.data); // json->map 자동변경
        return PersonVo.fromJson(response.data);

      } else {
      //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }


}

