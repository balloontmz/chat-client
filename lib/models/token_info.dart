///用户
class TokenInfo {
  String accessToken;
  String tokenType;
  int expiresIn;
  String username;
  int companyId;

  TokenInfo(
      {this.accessToken,
      this.tokenType,
      this.expiresIn,
      this.username,
      this.companyId = 0});

  factory TokenInfo.fromJson(Map<String, dynamic> json) {
    print('fromJOSN $json   ${json.runtimeType}');
    Map<String, dynamic> tokenObj = json;

    return TokenInfo(
      accessToken: tokenObj['access_token'],
      tokenType: tokenObj['token_type'],
      username: tokenObj['username'],
    );
  }
}
