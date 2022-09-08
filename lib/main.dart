import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const imageList = [
  'https://www.itying.com/images/flutter/1.png',
  'https://www.itying.com/images/flutter/2.png',
  'https://www.itying.com/images/flutter/3.png',
  'https://www.itying.com/images/flutter/4.png',
  'https://www.itying.com/images/flutter/5.png',
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  int countTimer = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      // 第一引数：繰り返す間隔の時間を設定
      const Duration(milliseconds: 10),
      // 第二引数：その間隔ごとに動作させたい処理を書く
      (Timer timer) {
        setState(() {
          countTimer += 10;
          if (countTimer == 5000) {
            countTimer = 0;
            if (currentIndex == 4) {
              currentIndex = 0;
            } else {
              // 1秒ずつインクリメント
              currentIndex++;
            }
          }
        });
      },
    );
  }

  void setIndex(index) {
    setState(() {
      currentIndex = index;
      countTimer = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider Demo'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: PageView.builder(
              itemCount: imageList.length,
              onPageChanged: (index) {
                setIndex(index);
              },
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: imageList[currentIndex],
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _Indicator(
            itemList: imageList,
            currentIndex: currentIndex,
            currentTimer: countTimer,
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    Key? key,
    required this.itemList,
    required this.currentIndex,
    required this.currentTimer,
  }) : super(key: key);

  final List itemList;
  final int currentIndex;
  final int currentTimer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: itemList.map((item) {
          var index = itemList.indexOf(item);
          return currentIndex == index
              ? _ActiveIndicator(
                  currentTimer: currentTimer,
                )
              : const _InActiveIndicator();
        }).toList(),
      ),
    );
  }
}

class _InActiveIndicator extends StatelessWidget {
  const _InActiveIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class _ActiveIndicator extends StatelessWidget {
  // コンストラクタ
  const _ActiveIndicator({
    Key? key,
    required this.currentTimer,
  }) : super(key: key);
  final int currentTimer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),

      /// インディケーターを表示
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: LinearProgressIndicator(
          value: currentTimer / 5000,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 255, 47, 10),
          ),
          backgroundColor: const Color(0xffD6D6D6),
        ),
      ),
    );
  }
}
