class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    if (obj['code'] == 200) {
      return Login(
        code: obj['code'],
        status: obj['status'],
        token: obj['data']?['token'],
        userID: obj['data']?['user']?['id'] is int
            ? obj['data']['user']['id']
            : int.tryParse(obj['data']?['user']?['id']?.toString() ?? ''),
        userEmail: obj['data']?['user']?['email'],
      );
    } else {
      return Login(code: obj['code'], status: obj['status']);
    }
  }
}
