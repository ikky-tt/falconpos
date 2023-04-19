class ReceivedNotification {
  ReceivedNotification({
     required this.id,
     required this.title,
     required this.body,
     required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}



class UserModel {
  UserModel({
     required this.empId,

     required this.empName,
     required this.empLv,
     required this.empUsername,
     required this.empPassword,
     required this.empDepartment,
    required this.branch,
    required this.branchid,
    required this.empwarehouse
  });

  int empId;

  String empName;
  int empLv;
  String empUsername;
  String empPassword;
  String empDepartment;
  String branch;
  int branchid;
  String empwarehouse;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    empId: json["emp_id"],

    empName: json["emp_name"],
    empLv: json["emp_lv"],
    empUsername: json["emp_username"],
    empPassword: json["emp_password"],
    empDepartment: json["emp_department"],
      branch: json['emp_branch_name'],
    branchid: json['emp_branch_id'],
    empwarehouse: json['emp_warehouse'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;

    data['emp_name'] = this.empName;
    data['emp_lv'] = this.empLv;
    data['emp_username'] = this.empUsername;
    data['emp_password'] = this.empPassword;
    data['emp_department'] = this.empDepartment;
    return data;
  }

}
