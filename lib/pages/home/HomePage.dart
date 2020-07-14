import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fluro/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yay_collect/config/FontsConfig.dart';
import 'package:yay_collect/pages/citySelect/CitySelect.dart';
import 'package:yay_collect/pages/home/DrawMenu.dart';
import 'package:yay_collect/pages/home/ScenicSpotSearchPage.dart';
import '../../utils/CustomScreenUtil.dart';
import '../../config/HttpUrlservices.dart';
import '../../router/CustomAnimationRouter.dart';
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  Router router;
  String cityName;
  Map param;

  HomePage(Router router, {this.param, Key key, String cityName}) {
    this.router = router;
    this.cityName = cityName;
    this.param = param;
  }

  @override
  _HomePageState createState() => _HomePageState(router, cityName: cityName);
}

class _HomePageState extends State<HomePage> {
  String cityName;
  Map param;
  _HomePageState(Router router, {String cityName}) {
    this.router = router;
    this.cityName = cityName;
  }

  ///经度
  double _mLongitude;

  ///纬度
  double _mLatitude;

  Router router;

  ///景区搜索输入框
  TextEditingController scenicSpotEdit = new TextEditingController();

  ///搜索框获取焦点
  FocusNode focusNode = new FocusNode();

  ///景区list数据
  List _jsonForList = new List();

  ///景区数据标记用于列表判断状态
  int scenicSpot;

  ///当前监听是否有焦点
  bool hasFocus;

  ///首页搜索结果赋值
  String _search_result_value = "";

  ///用户信息
  String userInfo;
  //城市
  String city;

  ///首页景区列表请求赋值
  void _scenicSpotList() async {
    //实例化本地存储对象
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cityName = prefs.get("city").toString() == "null"
        ? "开封市"
        : "${prefs.get("city").toString()}";
    userInfo = prefs.getString("userInfo");
    Dio dio = new Dio();
    var response = await dio
        .get(HttpUrlservices.scenicSpotList + "/?cityName=${cityName}");
    if (response.statusCode == 200) {
      ///使用转换后的map，通过指定的key获取对应的数据内容
      Map<String, Object> mapData = convert.json.decode(response.data);
      Map<String, Object> responseMapData = mapData['response'];
      List resultListMapData = responseMapData['data'];

      ///如果不等于0代表list有值赋值0代表显示数据，否则赋值-1代表显示空白页
      if (resultListMapData.length != 0) {
        ///将结果赋值给全局变量，方便其他地方调用
        setState(() {
          this._jsonForList = resultListMapData;
          this.scenicSpot = 0;
        });
      } else {
        setState(() {
          this.scenicSpot = -1;
        });
      }
    } else {
      print('请求失败:${response.statusCode}');
    }
  }

  ///景区搜索前列表数据加载
  Widget _getScenicSpotListData(conext, index) {
    return Column(
      children: <Widget>[
        GestureDetector(
            child: Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    _jsonForList[index]['ssName'],
                    style: TextStyle(
                        fontSize: CustomScreenUtil.setFontSize(14),
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontFamily: FontsConfig.$YAYAliFont),
                  ),
                  trailing: Image.asset('assets/images/jqxz_jt.png',
                      fit: BoxFit.cover,
                      width: CustomScreenUtil.setWidth(6),
                      height: CustomScreenUtil.setHeight(12)),
                )),
            onTap: () {
              ///点击进入景区页
              FlutterBoost.singleton.open("url://nativePage", urlParams: {
                "native": userInfo.split("&")[1] +
                    "&" +
                    convert.jsonEncode(this._jsonForList[index]) +
                    "&" +
                    "${cityName}"
              });
            }),
        Divider(height: 1, color: Color.fromRGBO(245, 245, 245, 1))
      ],
    );
  }

  ///首页组件
  Widget homeContent(context) {
    return Column(
      children: <Widget>[
        ///头部状态栏
        Container(
          padding: EdgeInsets.only(top: 0),
          color: Colors.white,
          height: 48,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ///定位点击
              GestureDetector(
                child: Container(
                    height: double.infinity,
                    margin: EdgeInsets.only(left: 20),
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/Home_positioning.png',
                            fit: BoxFit.cover),
                        SizedBox(width: CustomScreenUtil.setWidth(6)),
                        Container(
                          width: CustomScreenUtil.setWidth(45),
                          child: Text('${cityName}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: CustomScreenUtil.setFontSize(14),
                                  fontFamily: FontsConfig.$YAYAliFont,
                                  color: Color.fromRGBO(51, 51, 51, 1))),
                        )
                      ],
                    )),
                onTap: () {
                  Navigator.of(context).push(CustomAnimationRouter(
                      CitySelect(null, cityName: cityName)));
                },
              ),

              ///搜索框
              GestureDetector(
                  child: Container(
                    width: CustomScreenUtil.setWidth(210),
                    height: CustomScreenUtil.setHeight(40),
                    margin:
                        EdgeInsets.only(left: CustomScreenUtil.setWidth(15)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color.fromRGBO(245, 245, 245, 1)),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: CustomScreenUtil.setWidth(16),
                          height: CustomScreenUtil.setWidth(8),
                        ),
                        Image.asset('assets/images/Home_search.png',
                            fit: BoxFit.cover),
                        SizedBox(
                            width: CustomScreenUtil.setWidth(8),
                            height: CustomScreenUtil.setWidth(8)),

                        ///输入框
                        Text(
                          '请输入景区名称',
                          style: TextStyle(
                            fontFamily: FontsConfig.$YAYAliFont,
                            fontSize: CustomScreenUtil.setFontSize(12),
                            color: Color.fromRGBO(153, 153, 153, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    ///跳转到搜索页
                    Navigator.of(context).push(CustomAnimationRouter(
                        ScenicSpotSearchPage(cityName: cityName)));
                  }),

              ///个人中心
              Builder(
                  builder: (context) => Center(
                        child: GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: CustomScreenUtil.setWidth(17)),
                              child: Image.asset('assets/images/tx.png',
                                  fit: BoxFit.cover),
                            ),
                            onTap: () {
                              focusNode.unfocus();
                              Scaffold.of(context).openEndDrawer();
                            }),
                      ))
            ],
          ),
        ),

        ///景区列表
        Expanded(
          child: Container(
            child: ListView.builder(
              itemBuilder: this._getScenicSpotListData,
              itemCount: this._jsonForList.length,
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    ///初始化内容清空
    this._search_result_value = "";
  }

  @override
  Widget build(BuildContext context) {
    ///首页景区列表请求赋值
    this._scenicSpotList();
    CustomScreenUtil.init(context);
    return Scaffold(
      body: homeContent(context),
      drawer: DrawMenu(router),
      endDrawer: DrawMenu(router),
    );
  }
}
