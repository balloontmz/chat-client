import 'package:chat/widgets/tile_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Dio dio = new Dio();

class GridPage extends StatefulWidget {
  @override
  GridPageState createState() => new GridPageState();
}

class GridPageState extends State<GridPage> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();

  int _page = 0;
  int _size = 10;
  int _beLoad = 0; // 0表示不显示, 1表示正在请求, 2表示没有更多数据

  var posts = [];

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.init(context);
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Container(
        color: Colors.grey[100],
        child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          itemCount: posts.length,
          primary: false,
          crossAxisCount: 4,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          itemBuilder: (context, index) {
            String img = '${posts[index]['goods_pic']}';
            if (index == 0) {
              img = '';
            }
            return TileCard(
              img: img,
              // img: '${posts[index]['goods_pic']}',
              title: '${posts[index]['goods_short_title']}',
              author: '${posts[index]['goods_price']}',
              authorUrl: '${posts[index]['goods_pic']}',
              type: '${posts[index]['goods_pic']}',
              worksAspectRatio: posts[index]['dsr'],
            );
          },
          staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  // 下拉刷新数据
  Future<Null> _refreshData() async {
    _page = 0;
    _getPostData(false);
  }

  // 上拉加载数据
  Future<Null> _addMoreData() async {
    _page++;
    _getPostData(true);
  }

  void _getPostData(bool _beAdd) async {
    var response = await dio.get(
        'https://test-shop.tomtiddler.top/get-goods?page=$_page&size=$_size');
    var result = response.data;
    print('result: ${result['data']}');
    setState(() {
      if (!_beAdd) {
        posts.clear();
        posts = result['data'];
      } else {
        posts.addAll(result['data']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // 首次拉取数据
    _getPostData(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _addMoreData();
        print('我监听到底部了!');
      }
    });
  }
}
