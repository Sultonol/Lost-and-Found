class ApiConstants {
  static const String baseUrl = "http://192.168.1.239:8000/api";
  static String fixImageUrl(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) {
      return "";
    }
    return originalUrl.replaceAll('192.168.1.22', '192.168.1.239');
  }

  static const String login = "/login";
  static const String register = "/register";
  static const String logout = "/logout";

  // Endpoint Item
  static const String items = "/items";
  static const String categories = "/categories";
  // Endpoint Claim & Chat
  static const String myClaims = "/my-claims";
  static const String claims = "/claims";

  // Endpoint Chat (dari file routes/api.php)
  static String getMessages(int claimId) => "/claims/$claimId/messages";
  static String postMessage(int claimId) => "/claims/$claimId/messages";
}
