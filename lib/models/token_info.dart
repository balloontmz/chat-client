///用户
class TokenInfo {
  String accessToken;
  String tokenType;
  int expiresIn;
  String username;
  int userid;
  int companyId;
  String avatar;

  TokenInfo({
    this.accessToken,
    this.tokenType,
    this.username,
    this.userid,
    this.expiresIn,
    this.companyId = 0,
    this.avatar = '',
  });

  factory TokenInfo.fromJson(Map<String, dynamic> json) {
    print('fromJOSN $json   ${json.runtimeType}');
    Map<String, dynamic> tokenObj = json;

    return TokenInfo(
      accessToken: tokenObj['access_token'],
      tokenType: tokenObj['token_type'],
      username: tokenObj['username'],
      userid: tokenObj['userid'],
      avatar: tokenObj['avatar'],
    );
  }
}
