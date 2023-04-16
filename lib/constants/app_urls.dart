class AppURL {
  // base url
  static const String baseURL = 'https://43eb-223-228-25-9.ngrok-free.app/api';

  // fetch all tracks
  static const String fetchAllTracksURL = '$baseURL/all';

  // fetch questions
  static const String fetchQuestionsListURL = '$baseURL/qtc';

  // user authentication
  static const String checkAuthURL = '$baseURL/isauth';

  // user registration
  static const String registerURL = '$baseURL/register_request';

  // user results
  static const String userResultsURL = '$baseURL/submit';
}
