import 'dart:io';

import 'package:chat/api/api.dart';
import 'package:chat/routers/routers.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/qiniu_util.dart';
import 'package:chat/utils/util.dart';
import 'package:chat/widgets/add_group_float_btn.dart';
import 'package:chat/widgets/copy_image_route.dart';
import 'package:chat/widgets/image_buttom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

///TODO: 注意 pop 能携带参数,此时 page 并不重建,只是 set state,可以对参数进行解析
///路由应该统一采用 routers 中的方法!!!
///dart 是强类型语言,注意类型!!!
class AddGroup extends StatefulWidget {
  String avatar; // 此参数暂无意义!!!
  AddGroup({key, this.avatar}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddGroupState();
  }
}

class _AddGroupState extends State<AddGroup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  String avatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      resizeToAvoidBottomPadding: false,
      // floatingActionButton: new AddGroupFloatBtn(),
      appBar: new AppBar(
        backgroundColor: Color(0xFF8c77ec),
        title: new Text("添加群聊"),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: new Text('群聊名称'),
              ),
              Expanded(
                flex: 5,
                child: new TextField(
                  autofocus: false,
                  controller: _nameController,
                ),
              )
            ],
          ),
          new Container(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start, // 默认顶部对齐
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: new Text('群聊头像'),
                ),
                Expanded(
                  flex: 2,
                  child: new Container(),
                ),
                Expanded(
                  flex: 5,
                  child: _buildAvatar(),
                ),
                Expanded(
                  flex: 8,
                  child: new Container(),
                ),
              ],
            ),
          ),
          new Container(
            padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
            child: Align(
              child: SizedBox(
                height: 45.0,
                width: 270.0,
                child: RaisedButton(
                  child: Text(
                    '创建群聊',
                    style: Theme.of(context).primaryTextTheme.headline,
                  ),
                  color: Colors.black,
                  onPressed: _onPressCreateGroup,
                  shape: StadiumBorder(side: BorderSide()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onPressCreateGroup() async {
    String name = _nameController.text;

    if (name.isEmpty) {
      Util.showSnackBar(context, "请输入群名", null);
      return false;
    }
    if (this.avatar == null) {
      Util.showSnackBar(context, "请上传图片", null);
      return false;
    }

    var result = await Api.createGroup({
      "name": name,
      "avatar": avatar,
    });

    Log.i("创建群聊的返回结果为: $result");
    //TODO: 添加完成之后,是否需要弹回上一个页面,是否需要加入弹窗提示一类的
    Routers.pop(context);

    return false;
  }

  Widget _buildAvatar() {
    if (this.avatar == null) {
      return _buildNoImageButton();
    }
    return new Image.network(this.avatar);
  }

  ///选择和裁剪图片 https://blog.csdn.net/NNadn/article/details/90633053
  Widget _buildNoImageButton() {
    // var button = new IconButton(
    //   icon: new Icon(Icons.add_a_photo),
    //   onPressed: null,
    // );
    var button = new Container(
      alignment: Alignment.topCenter,
      // margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Container(
        // width: 80.0,
        // height: 80.0,
        child: Ink(
          // width: 100.0,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Colors.grey, width: 4.0),
            ),
            // border: Border.all(color: Colors.indigoAccent, width: 4.0),
            color: Colors.transparent,
            shape: BoxShape.rectangle,
          ),
          child: InkWell(
            //This keeps the splash effect within the circle
            borderRadius: BorderRadius.circular(
                1000.0), //Something large to ensure a circle
            onTap: _onGroupAvatarBtnPress,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.add_a_photo,
                size: 60.0,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );

    return button;
  }

  _onGroupAvatarBtnPress() {
    File imageFile;
    showModalBottomSheet(
      context: context,
      builder: imageButtomSheetBuilder(context, cropImage),
    );
    // builder: (BuildContext context) {
    //   return new Column(
    //     // mainAxisAlignment: MainAxisAlignment.center,
    //     mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
    //       new ListTile(
    //         // leading: new Icon(Icons.photo_camera),
    //         title: new Center(
    //           child: new Text("Camera"),
    //         ),

    //         onTap: () async {
    //           await getImage();
    //           Navigator.pop(context);
    //         },
    //       ),
    //       new ListTile(
    //         // leading: new Icon(Icons.photo_library),
    //         title: new Center(
    //           child: new Text("Gallery"),
    //         ),
    //         onTap: () async {
    //           await chooseImage();
    //           Navigator.pop(context);
    //         },
    //       ),
    //       new Divider(
    //         thickness: 3,
    //       ),
    //       new ListTile(
    //         // leading: new Icon(Icons.photo_library),
    //         title: new Center(
    //           child: new Text("Gallery"),
    //         ),
    //         onTap: () async {
    //           Navigator.pop(context);
    //         },
    //       ),
    //     ],
    //   );
    // });
  }

  ///拍摄照片
  Future getImage() async {
    await ImagePicker.pickImage(source: ImageSource.camera)
        .then((image) => cropImage(image));
  }

  ///从相册选取
  Future chooseImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery)
        .then((image) => cropImage(image));
  }

  void cropImage(File originalImage) async {
    String result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CropImageRoute(originalImage)));
    print('裁剪结果返回 $result');
    if (result == null || result.isEmpty) {
      print('上传失败');
    } else {
      print('上传成功');
      //result是图片上传后拿到的url
      setState(() {
        Log.i("上一个页面的返回结果为: $result");
        // iconUrl = result;
        this.avatar = QiniuUtil.getImageFullPath(result);
        // _upgradeRemoteInfo(); //后续数据处理，这里是更新头像信息
      });
    }
  }
}
