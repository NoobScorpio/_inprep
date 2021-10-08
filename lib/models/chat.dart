class Chat {
  String sid;
  String rid;
  String cid;
  String lastMessage;
  String receiverName;
  String senderName;
  bool sDeleted;
  bool rDeleted;
  bool sRead;
  bool rRead;
  String acceptedOfferID;
  bool confirm = false;
  List<String> users;
  Chat(
      {this.sid,
      this.sRead,
      this.rRead,
      this.confirm,
      this.rid,
      this.acceptedOfferID,
      this.cid,
      this.lastMessage,
      this.receiverName,
      this.senderName,
      this.sDeleted,
      this.rDeleted,
      this.users});

  Chat.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    rid = json['rid'];
    cid = json['cid'];
    lastMessage = json['lastMessage'];
    receiverName = json['receiverName'];
    senderName = json['senderName'];
    sDeleted = json['sDeleted'];
    rDeleted = json['rDeleted'];
    sRead = json['sRead'];
    rRead = json['rRead'];
    users = json['users'].cast<String>();
    confirm = json['confirm'];
    acceptedOfferID = json['acceptedOfferID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['rid'] = this.rid;
    data['cid'] = this.cid;
    data['lastMessage'] = this.lastMessage;
    data['receiverName'] = this.receiverName;
    data['senderName'] = this.senderName;
    data['sDeleted'] = this.sDeleted;
    data['rDeleted'] = this.rDeleted;
    data['users'] = this.users;
    data['sRead'] = this.sRead;
    data['rRead'] = this.rRead;
    data['acceptedOfferID'] = this.acceptedOfferID;
    data['confirm'] = this.confirm;
    return data;
  }
}
