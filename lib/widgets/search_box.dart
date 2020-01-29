import 'package:chat/routers/routers.dart';
import 'package:flutter/material.dart';

const searchList = ["wangcai", "xiaoxianrou", "dachangtui", "nvfengsi"];

const recentSuggest = ["wangcai推荐-1", "nvfengsi推荐-2"];

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(10.0),
      child: new ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 25,
          // maxWidth: 200,
        ),
        child: new FlatButton(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          onPressed: () {
            Routers.push('/search-page', context);
            // showSearch(context: context, delegate: SearchBarDelegate());
          },
          child: new TextField(
            enabled: false,
            readOnly: true,
            textAlign: TextAlign.center,
            // onTap: () {
            //   Routers.push('/search-page', context);
            //   // showSearch(context: context, delegate: SearchBarDelegate());
            // },
            // onChanged: (v) => _textController.text = v,
            decoration: InputDecoration(
              labelText: '搜索',
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
              // hintText: '请输入搜索内容',
              prefixIcon: Icon(Icons.search),
              // contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
      ),
    );

    // return IconButton(
    //   icon: Icon(Icons.search),
    //   onPressed: () {
    //     showSearch(context: context, delegate: SearchBarDelegate());
    //   },
    // );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
//重写右侧的图标
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
    // return [
    //   IconButton(
    //     icon: Icon(Icons.clear),
    //     //将搜索内容置为空
    //     onPressed: () => query = "",
    //   )
    // ];
  }

//重写返回图标
  @override
  Widget buildLeading(BuildContext context) {
    // return null;
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      //关闭上下文，当前页面
      onPressed: () => close(context, null),
    );
  }

  //重写搜索结果
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Card(
        color: Colors.redAccent,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSuggest
        : searchList.where((input) => input.startsWith(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
    );
  }
}
