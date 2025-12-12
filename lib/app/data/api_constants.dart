class ApiConstants {
  static const String baseUrl = "http://192.168.18.219:8000/api";
  static String fixImageUrl(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) {
      return "";
    }
    return originalUrl.replaceAll('192.168.1.22', '192.168.18.219');
  }

  static const String login = "/login";
  static const String register = "/register";
  static const String logout = "/logout";

  static const String items = "/items";
  static const String categories = "/categories";
  static const String myClaims = "/my-claims";
  static const String claims = "/claims";

  static String getMessages(int claimId) => "/claims/$claimId/messages";
  static String postMessage(int claimId) => "/claims/$claimId/messages";
}
