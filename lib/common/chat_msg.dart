import 'package:chat/api/api.dart';
import 'package:chat/models/chat_msg.dart';
import 'package:chat/utils/log_util.dart';

class ChatMsgUpgrage {
  ///更新聊天室对应的消息的本地存储 -- 传入一个聊天室 id 列表
  static upgradeGroupMsgs(List<int> groupIDs) async {
    Log.i("当前传入的聊天室 id 为: $groupIDs");
    List<ChatMsg> chatMsgs =
        await Api.getMsgs({'group_ids': groupIDs}); // 根据聊天室 ids 得到的服务器消息列表
    List<int> msgIDs =
        await ChatMsg.getMsgListUseGroupIDs(groupIDs); // 根据聊天室 ids 得到的本地列表

    Log.i("所有聊天室的消息 id 为: $msgIDs");

    if (msgIDs != null) {
      chatMsgs.removeWhere((msg) {
        return msgIDs.contains(msg.id);
      });
    }

    //批量插入数据库
    ChatMsg.batchInsert(chatMsgs);
    return;
  }
}
