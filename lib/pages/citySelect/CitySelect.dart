import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:yay_collect/config/HttpUrlservices.dart';
import 'package:dio/dio.dart';
import 'package:fluro/src/router.dart';
import 'package:yay_collect/config/FontsConfig.dart';
import 'package:yay_collect/pages/home/CitySearchPage.dart';
import 'package:yay_collect/pages/home/HomePage.dart';
import 'package:yay_collect/router/CustomAnimationRouter.dart';
import 'package:yay_collect/utils/SharedPreferencesUtils.dart';

import 'CityModel.dart';

class CitySelect extends StatefulWidget {
  Router router;
  String cityName;
  CitySelect(Router router, {Key key, String cityName}) {
    this.router = router;
    this.cityName = cityName;
  }

  @override
  _CitySelectState createState() => _CitySelectState(cityName: cityName);
}

class _CitySelectState extends State<CitySelect> {
  String cityName;
  _CitySelectState({String cityName}) {
    this.cityName = cityName;
  }

  List<CityInfo> _cityList = List();
  List<CityInfo> _hotCityList = List();

  ///组头高度
  int _suspensionHeight = 36;

  ///cell高度
  int _itemHeight = 48;

  ///组头标签
  String _suspensionTag = " ";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  //城市列表数据请求
  void loadData() async {
    var listvalue = List();
    print(_hotCityList);
    print('*********');

    ///此处给定位城市赋值
    _hotCityList.clear();
    _hotCityList.add(CityInfo(name: "洛阳市", tagIndex: " "));
    _hotCityList.add(CityInfo(name: "开封市", tagIndex: " "));
    _hotCityList.add(CityInfo(name: "焦作市", tagIndex: " "));
    _hotCityList.add(CityInfo(name: "郑州市", tagIndex: " "));
    _hotCityList.add(CityInfo(name: "新乡市", tagIndex: " "));
    _hotCityList.add(CityInfo(name: "三门峡市", tagIndex: " "));
    print(_hotCityList);
    print('--------------');
    userLogin().then((data) {
      List countylist = data;
      for (var i = 0; i < countylist.length; i++) {
        Map countyMap = countylist[i];
        List countcList = countyMap['latterContent'];
        listvalue.addAll(countcList);
      }

      // print(listvalue);
      listvalue.forEach((value) {
        _cityList.add(CityInfo(name: value));
      });
      _handleList(_cityList);
      setState(() {
        _suspensionTag = _hotCityList[0].getSuspensionTag();
      });
    });
  }

  ///城市接口请求
  Future userLogin() async {
    try {
      Response respose = await Dio().get(HttpUrlservices.getCityUrl);
      Map<String, dynamic> news = jsonDecode(respose.data);

      String dataValue = news['response']['data'].toString();

      if (!dataValue.contains('error')) {
        return news['response']['data'];
        // Navigator.of(context).pop();
      } else {
        List<String> datalist = dataValue.split('&');
      }
    } catch (e) {
      print(e);
    }
  }

  ///城市数据处理
  void _handleList(List<CityInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_cityList);
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  ///当前定位城市
  Widget _buildSusWidget(String susTag) {
    susTag = (susTag == " " ? "开发中城市" : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  ///热门城市

  Widget _buildListItem(CityInfo model) {
    String susTag = model.getSuspensionTag();
    susTag = (susTag == " " ? "热门" : susTag);
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(model.name),
            onTap: () {
              Navigator.of(context).push(
                  CustomAnimationRouter(HomePage(null, cityName: model.name)));
              SharedPreferencesUtils.setString("city", model.name);
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          headerContent(context),
          Expanded(
              flex: 1,
              child: AzListView(
                data: _cityList,
                topData: _hotCityList,
                itemBuilder: (context, model) => _buildListItem(model),
                suspensionWidget: _buildSusWidget(_suspensionTag),
                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
                shrinkWrap: false,

                //showCenterTip: false,
              )),
        ],
      ),
    );
  }

  ///头部组件
  Widget headerContent(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        ///头部状态栏
        Container(
          padding: EdgeInsets.only(top: 0),
          // color: Colors.blue,
          height: 50,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                // color: Colors.red,
                child: IconButton(
                    icon: Image.asset('assets/images/zc_back.png'),
                    onPressed: () {
                      Navigator.of(context).push(CustomAnimationRouter(
                          HomePage(null, cityName: cityName)));
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    color: Colors.transparent,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent),
              ),

              ///搜索框
              GestureDetector(
                  child: Container(
                    width: screenWidth - 60,
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Color.fromRGBO(245, 245, 245, 1)),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 12,
                          height: 4,
                        ),
                        Image.asset('assets/images/Home_search.png',
                            fit: BoxFit.cover),
                        SizedBox(width: 8, height: 4),

                        ///输入框
                        Text(
                          '目的地',
                          style: TextStyle(
                            fontFamily: FontsConfig.$YAYAliFont,
                            fontSize: 14,
                            color: Color.fromRGBO(153, 153, 153, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    ///跳转到搜索页
                    Navigator.of(context).push(CustomAnimationRouter(
                        CitySearchPage(cityName: cityName)));
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
