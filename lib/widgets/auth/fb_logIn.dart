import 'package:flutter_login_facebook/flutter_login_facebook.dart';


// Create an instance of FacebookLogin
final fb = FacebookLogin();
bool signInStatus = false;
// Log in
 Future<bool> logUserIn() async{
  final res = await fb.logIn(permissions: [
    FacebookPermission.publicProfile,
    FacebookPermission.email,
  ]);


// Check result status
   switch (res.status) {
    case FacebookLoginStatus.success:
// Logged in
// Send access token to server for validation and auth
      final FacebookAccessToken? accessToken = res.accessToken;
      print('Access token: ${accessToken?.token}');

// Get profile data
      final profile = await fb.getUserProfile();
      print('Hello, ${profile?.name}! You ID: ${profile?.userId}');

// Get user profile image url
      final imageUrl = await fb.getProfileImageUrl(width: 100);
      print('Your profile image: $imageUrl');

// Get email (since we request email permission)
      final email = await fb.getUserEmail();
// But user can decline permission
      if (email != null)
        print('And your email is $email');
      print(fb.sdkVersion);
      signInStatus = true;
      return true;
    case FacebookLoginStatus.cancel:
// User cancel log in
      return false;
    case FacebookLoginStatus.error:
// Log in failed
      print('Error while log in: ${res.error}');
      return false;
  }
}
logUserOut(){
 if(signInStatus) fb.logOut();
}