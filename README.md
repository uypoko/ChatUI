# ChatUI
ChatUI is a social media application in which users can browse new feed.
## Features
* Display the list of posts
* Sign in an active account and sign up a new account
* Upload users profile picture
* Update users information
## App Architecture
### Project structure
* Reusable: Custom components and extensions.
* Assests
* App: App-level objects, which only App/Scene delegate and containers should have direct access to.
* Modules: Every scene is a module, which includes its own data, domain and UI layers.
### Dependency Injection
A container is responsible for injecting dependencies into every objects in the module then return its view controller and navigation.
* App Dependency Container: contains all long-lived dependencies. The container lives as long as the app lives, held by AppDelegate.
* Module Dependency Container: contains module-level dependencies, takes App Dependency Container as init parameter. The container lives as long as the view controller lives, held by View Model through Navigation class-bound protocol.
## How the app works
When an user lauch the app, it determines if the user is signed in. If not, the app transitions to the welcome screen. From the welcome screen, you can navigate to the sign-up and sign-in screens.
<img src="https://raw.githubusercontent.com/uypoko/ChatUI/master/Screenshots/Welcome.png" width="40%">
## Built with
* [RxSwift](https://github.com/ReactiveX/RxSwift/)
* [Realm Database](https://github.com/realm/realm-cocoa/)
* [RxRealm](https://github.com/RxSwiftCommunity/RxRealm)
* [Firebase](https://firebase.google.com/)
