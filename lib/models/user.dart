class User {
  final String uid;
  User({this.uid});
}

class UserData {
  final String uid;
  final String avatarUrl;
  final String name;
  final double rating;
  final int dtasks;
  final bool acc_activated;
  final String phone_number;
  final int tasks_announced;

  UserData(
      {this.uid,
      this.name,
      this.rating,
      this.dtasks,
      this.acc_activated,
      this.avatarUrl,
      this.phone_number,
      this.tasks_announced});
}
