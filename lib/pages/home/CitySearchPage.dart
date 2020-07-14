import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yay_collect/config/FontsConfig.dart';
import 'package:yay_collect/pages/citySelect/CitySelect.dart';
import 'package:yay_collect/router/CustomAnimationRouter.dart';
import 'package:yay_collect/utils/SharedPreferencesUtils.dart';
import '../../utils/CustomScreenUtil.dart';
import '../../config/HttpUrlservices.dart';
import 'dart:convert' as convert;

import 'HomePage.dart';

class CitySearchPage extends StatefulWidget {
  String cityName;
  CitySearchPage({String cityName}) {
    this.cityName = cityName;
  }

  @override
  _CitySearchPageState createState() =>
      _CitySearchPageState(cityName: cityName);
}

class _CitySearchPageState extends State<CitySearchPage> {
  String cityName;

  _CitySearchPageState({String cityName}) {
    this.cityName = cityName;
  }

  ///景区搜索输入框
  TextEditingController scenicSpotEdit = new TextEditingController();

  ///搜索框获取焦点
  FocusNode focusNode = new FocusNode();

  ///搜索列表的list
  List _searchList = new List();

  ///景区数据标记用于列表判断状态
  int scenicSpot;

  ///当前监听是否有焦点
  bool hasFocus;

  ///首页搜索结果赋值
  String _search_result_value = "";

  ///首页景区列表请求赋值
  void _scenicSpotList(String scenicSpotName) async {
    if (scenicSpotName == '') {
      setState(() {
        List resultListMapData = new List();
        this._searchList = resultListMapData;
      });
    } else {
      Dio dio = new Dio();
      var response = await dio
          .get(HttpUrlservices.searchCity + "/?cityName=${scenicSpotName}");
      if (response.statusCode == 200) {
        ///使用转换后的map，通过指定的key获取对应的数据内容
        Map<String, Object> mapData = convert.json.decode(response.data);
        Map<String, Object> responseMapData = mapData['response'];
        List resultListMapData = responseMapData['data'];

        ///如果不等于0代表list有值赋值0代表显示数据，否则赋值-1代表显示空白页【无结果页功能暂时不做 scenicSpot 赋值暂时忽略】
        if (resultListMapData.length != 0) {
          ///将结果赋值给全局变量，方便其他地方调用
          setState(() {
            this._searchList = resultListMapData;
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
  }

  @override
  void initState() {
    super.initState();

    ///添加获取焦点与失去焦点的兼听
    focusNode.addListener(() {
      ///当前兼听的 TextFeild 是否获取了输入焦点
      hasFocus = focusNode.hasFocus;

      ///当前 focusNode 是否添加了兼听
      bool hasListeners = focusNode.hasListeners;
      print("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ///获取输入框焦点
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  ///景区搜索后列表加载
  Widget _getScenicSpotListData(conext, index) {
    return Column(
      children: <Widget>[
        Container(
            color: _searchList.length == 0
                ? Color.fromRGBO(245, 245, 245, 1)
                : Colors.white,
            child: GestureDetector(
              child: ListTile(
                title: Text(
                  this._searchList[index]['name'],
                  style: TextStyle(
                      fontSize: CustomScreenUtil.setFontSize(14),
                      color: Color.fromRGBO(153, 153, 153, 1),
                      fontFamily: FontsConfig.$YAYAliFont),
                ),
                trailing: Image.asset('assets/images/jqxz_jt.png',
                    fit: BoxFit.cover,
                    width: CustomScreenUtil.setWidth(6),
                    height: CustomScreenUtil.setHeight(12)),
              ),
              onTap: () {
                ///将选中的城市传递到homePage页面
                Navigator.of(context).push(CustomAnimationRouter(
                    HomePage(null, cityName: this._searchList[index]['name'])));
                SharedPreferencesUtils.setString(
                    "city", this._searchList[index]['name']);
              },
            )),
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
          height: 50,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ///搜索框
              Container(
                width: CustomScreenUtil.setWidth(300),
                height: 32,
                margin: EdgeInsets.only(left: CustomScreenUtil.setWidth(15)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color.fromRGBO(245, 245, 245, 1)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Container(
                      width: CustomScreenUtil.setWidth(230),
                      height: 28,
                      child: TextFormField(

                          ///软键盘监听避免点击键盘确认后变回到原首页状态
                          onFieldSubmitted: (term) {},

                          ///设置键盘为完成状态，用于监听和控制按钮，让完成按钮变为失效。
                          textInputAction: TextInputAction.none,
                          controller: scenicSpotEdit,

                          ///最大行数1
                          maxLines: 1,
                          cursorColor: Color.fromRGBO(153, 153, 153, 1),

                          ///最大长度
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(50) //限制长度
                          ],

                          ///字体风格
                          style: TextStyle(
                            fontFamily: FontsConfig.$YAYAliFont,
                            fontSize: CustomScreenUtil.setFontSize(12),
                            color: Color.fromRGBO(51, 51, 51, 1),
                          ),

                          ///提示字风格
                          decoration: InputDecoration(
                              hintMaxLines: 1,
                              hintText: '请输入城市名称',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontFamily: FontsConfig.$YAYAliFont,
                              ),
                              border: InputBorder.none),

                          ///动态获取输入框内容
                          onChanged: (value) {
                            if (value == '') {
                              setState(() {
                                this._scenicSpotList('');
                                this._search_result_value = '';
                              });
                            } else {
                              //遍历景区列表
                              setState(() {
                                this._search_result_value = value;
                                this._scenicSpotList(this._search_result_value);
                              });
                            }
                          },
                          focusNode: focusNode),
                    ),

                    ///搜索框叉图标，用于清理搜索框中的内容
                    GestureDetector(
                      child: Container(
                          child: Image.asset('assets/images/mhss_delete.png')),
                      onTap: () {
                        scenicSpotEdit.clear();
                        setState(() {
                          this._scenicSpotList('');
                          this._search_result_value = '';
                        });
                      },
                    ),
                  ],
                ),
              ),

              ///返回景区列表页
              Builder(
                  builder: (context) => Center(
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: CustomScreenUtil.setWidth(17)),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                  fontSize: CustomScreenUtil.setFontSize(14),
                                  fontFamily: FontsConfig.$YAYAliFont),
                            ),
                          ),
                          onTap: () {
                            //点击取消跳转到景区列表页
                            Navigator.of(context)
                                .push(CustomAnimationRouter(CitySelect(
                              null,
                              cityName: cityName,
                            )));
                          },
                        ),
                      ))
            ],
          ),
        ),

        ///搜索文字显示
        Container(
            width: double.infinity,
            height: CustomScreenUtil.setHeight(40),
            alignment: Alignment.center,
            color: Color.fromRGBO(245, 245, 245, 1),
            child: Text(
              this._searchList.length == 0
                  ? "以下为包含“${_search_result_value}”的搜索结果为空"
                  : "以下为包含“${_search_result_value}”的搜索结果",
              style: TextStyle(
                  fontSize: CustomScreenUtil.setFontSize(12),
                  fontFamily: FontsConfig.$YAYAliFont,
                  color: Color.fromRGBO(153, 153, 153, 1)),
            )),

        ///景区列表
        Expanded(
          child: ListView.builder(
              itemBuilder: this._getScenicSpotListData,
              itemCount: this._searchList.length),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.init(context);
    return Scaffold(
        body: Container(
      color: this._searchList.length == 0
          ? Color.fromRGBO(245, 245, 245, 1)
          : Colors.white,
      child: homeContent(context),
    ));
  }
}
