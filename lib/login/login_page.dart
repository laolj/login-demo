import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
//登录界面
class LoginPage extends StatefulWidget {

  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}


class UserRestful<T>{
  int code;
  String message;
  List<T> data;
  UserRestful({required this.code,required this.message,required this.data});

  factory UserRestful.fromJson(Map<String, dynamic> json,T Function(Map<String, dynamic>) cvt) {
    return UserRestful(
      code: json['code'],
      message: json['message'],
      //转换json数据，然后一个一个对象元素取出来，再转换为当前对象的集合
      data: List.of(json['data']).map((e) => cvt(e)).toList(),
    );
  }


  @override
  String toString() {
    return 'UserRestful{code: $code, message: $message, data: $data}';
  }
}


class UserInfo {
  String username;
  String role;
  num id;
  String password;

  UserInfo({required this.username,required this.role,required this.id,required this.password});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'],
      role: json['role'],
      id: json['id'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['id'] = this.id;
    data['role'] = this.role;
    data['password'] = this.password;
    return data;
  }

  @override
  String toString() {
    return 'UserInfo{username: $username, role: $role, id: $id, password: $password}';
  }
}



class _LoginPageState extends State<LoginPage> {
  //发送请求测试
  void doGet() async{
    Dio dio=new Dio();
    String url="http://localhost:8081/test";
    Response response = await dio.get(url);
    var data = response.data;
    print(data.toString());
  }

  //登录返回结果
  Future<UserRestful<UserInfo>> login(String username,String password) async{
    print("=========================");
    String url="http://localhost:8081/login";
    Map<String,dynamic> map=Map();
    map["username"] = username;
    map["password"] = password;
    final response = await Dio().get(
        url,queryParameters: map,
        //UserInfo.fromJson 传入方法解析
        options: Options(responseType: ResponseType.json)).then((res)=>UserRestful<UserInfo>.fromJson(res.data,UserInfo.fromJson));
    // if (response.statusCode==200) {
    //   print(UserRestful.fromJson(response.data));
    // }
    print(response.runtimeType);
    print(response.data);
    // Map<String,dynamic> decode = json.decode(data.toString());
    // print(decode['data']);
    return response;
  }

  //提示框
  void showToast(
      String text, {
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
      }) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
        webPosition: "center",
        webShowClose: true,
        webBgColor: "blue"
    );
  }
  @override
  Widget build(BuildContext context) {
    doGet();
    //login("admin0", "1230");
    final logo = Hero(//飞行动画
      tag: 'hero',
      child: CircleAvatar(//圆形图片组件
        backgroundColor: Colors.transparent,//透明
        radius: 48.0,//半径
        child: Image.asset("images/R-C.jp"
            "g"),//图片
      ),
    );


    String username='';
    String loginPassword='';
    final email = TextFormField(//用户名
      autofocus: false,//是否自动对焦
      initialValue: 'liyuanjinglyj@163.com',//默认输入的类容
      decoration: InputDecoration(
          hintText: '请输入用户名',//提示内容
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),//上下左右边距设置
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)//设置圆角大小
          )
      ),
      onChanged: (value){
        username=value;
        //username=(String)value;
      },
    );

    final password = TextFormField(//密码
      autofocus: false,
      initialValue: 'ssssssssssssssssssssss',
      obscureText: true,
      decoration: InputDecoration(
          hintText: '请输入密码',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)
          )
      ),
      onChanged: (val){
        loginPassword = val;
      },
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),//上下各添加16像素补白
      child: Material(
        borderRadius: BorderRadius.circular(30.0),// 圆角度
        shadowColor: Colors.lightBlueAccent.shade100,//阴影颜色
        elevation: 5.0,//浮动的距离
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: (){
            //登录逻辑
            print(username);
            Future<UserRestful<UserInfo>> future = login(username, loginPassword);
            future.then((value) => {
              if(value.code==200){
                Navigator.of(context).pushNamed(HomePage.tag)//点击跳转界面
              }else{
                showToast("用户名或者密码错误")
              }
            });
            print(loginPassword);
            //login(username!, loginPassword!);
          },
          color: Colors.green,//按钮颜色
          child: Text('登 录', style: TextStyle(color: Colors.white, fontSize: 20.0),),
        ),
      ),
    );

    final forgotLabel = FlatButton(//扁平化的按钮，前面博主已经讲解过
      child: Text('忘记密码?', style: TextStyle(color: Colors.black54, fontSize: 18.0),),
      onPressed: () {
        showToast("还未开发");
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(//将这些组件全部放置在ListView中
          shrinkWrap: true,//内容适配
          padding: EdgeInsets.only(left: 24.0, right: 24.0),//左右填充24个像素块
          children: <Widget>[
            logo,
            SizedBox(height: 48.0,),//用来设置两个控件之间的间距
            email,
            SizedBox(height: 8.0,),
            password,
            SizedBox(height: 24.0,),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }

}
