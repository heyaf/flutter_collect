class HttpUrlservices {
  static String baseUrl = 'http://114.115.167.217:8888/collect/';
  // static String baseUrl = 'http://172.18.0.165:8081/collect/';

  ///获取手机号接口
  static String getPhoneCode = baseUrl + 'api/user/phone/getMessageSendCode';

  ///用户注册接口
  static String userRegistUrl = baseUrl + 'api/user/phone/register';

  ///用户登录接口
  static String userLoginUrl = baseUrl + 'api/user/phone/login';

  ///用户信息修改
  static String updateUserInfo = baseUrl + 'api/user/phone/updateUserInfo';

  ///用户手机号验证
  static String sureUserPhone =
      baseUrl + 'api/user/phone/forgetValidationPhoneNo';

  ///景区列表接口
  static String scenicSpotList = baseUrl + 'api/scenicSpot/phone/getScenicSpot';

  ///城市列表接口
  static String getCityUrl = baseUrl + 'api/city/phone/getAllCity';

  ///城市搜索接口
  static String searchCity = baseUrl + 'api/city/phone/searchCityByName';
}
