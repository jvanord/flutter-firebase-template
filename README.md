# flutter-firebase-template
A template for a flutter app using BLoC patterns and Firebase as a login provider.

## Getting Started
1. Obviously you'll need to setup a Firebase project for this. You'll probably want to get that started first.
  - On your Firebase console for your project, navigate to Authentication > Sign-in method and enable "Email/Password" and "Google" providers.
1. You could just fork and clone this repository, but that will stick you with a bunch of preset names that you probably won't like. So I recommend starting a fresh project with `flutter create ...` and then copying the contents of "lib" and "test" from this project and then renaming any classes as you see fit.

:warning: Unfortunately, Firebase authentication doesn't work nicely out-of the box and if your environment isn't configured correctly you'll get app crashes with unhelpful error messages (and that's if you know where to look.) So here's a short list of additional steps that *should* be sufficient to get you to a working template app. Some of these tips can be seen [here](https://codelabs.developers.google.com/codelabs/flutter-firebase/#6) as well.

## Additional Steps Required for iOS
1. On your Firebase console for your project, navigate to Settings > General. Choose "Add app" and follow the prompts for iOS. Make note of the Bundle ID you set here, as it will have to match the Bundle Identifier in your XCode project.
1. Download the GoogleService-Info.plist file for the app you just defined and move it to the "ios/Runner" directory of your flutter project. (This may be a good time to put *.plist in your .gitignore to keep your app secrets safe.) 
1. Open the ios/Runner workspace in XCode. In the General tab of the Runner project, make sure your "Bundle Identifier" is set to the same 
![Url Types in XCode](_help/bundleid.png)
1. While you're in XCode, take the value of REVERSED_CLIENT_ID from GoogleService-Info.plist and add it to your Url Types. Only the text value is needed - like shown [here](https://developers.google.com/identity/sign-in/ios/start-integrating#add_a_url_scheme_to_your_project).
![Url Types in XCode](_help/urltypes.png)

## Additional Steps Required for Android
1. TBD

## Other helpful links
- https://medium.com/@sokrato/storing-your-secret-keys-in-flutter-c0b9af1c0f69
- https://medium.com/flutter-community/building-a-chat-app-with-flutter-and-firebase-from-scratch-9eaa7f41782e