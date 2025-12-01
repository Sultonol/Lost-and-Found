class ApiConstants {
  // Base URL tetap lengkap
  // static const String baseUrl = "http://192.168.1.82:8000/api";
  static const String baseUrl = "http://10.90.33.35:8000/api";

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
