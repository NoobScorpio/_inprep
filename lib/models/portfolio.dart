class Portfolio {
  String pid;
  String title;
  String to;
  String from;
  String uid;
  String image;
  bool current;
  Portfolio({this.pid, this.title, this.to, this.from, this.uid, this.current});

  Portfolio.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    image = json['image'];
    title = json['title'];
    to = json['to'];
    from = json['from'];
    uid = json['uid'];
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pid'] = this.pid;
    data['image'] = this.image;
    data['title'] = this.title;
    data['to'] = this.to;
    data['from'] = this.from;
    data['uid'] = this.uid;
    data['current'] = this.current;
    return data;
  }
}
