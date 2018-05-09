<p align="center">
  <img src="https://github.com/jdisho/RxCoordinator/blob/master/Images/munich.png">
</p>

# 🏄‍♂️ RxCoordinator
“How does an app transition from a ViewController to another?”. 
This question is common and puzzling regarding MVVM. There are many answers, as every architecture has different implementation variations. Some do it from the ViewController, while some do it using a router, which is an object that connects view models.

To better answer the question, we are building **RxCoordinator**, a navigation framework based on the **Coordinator** pattern.

<p align="center">
  <img src="https://github.com/jdisho/RxCoordinator/blob/master/Images/mvvmc.png">
</p>


##  Why coordinators:
* **Separation of responsibilities** by coordinator being only component knowing anything related to the flow of your application
* **Reusable View ands ViewModels** because the don't contain any navigation logic
* **Less coupling between components**

* **Changeable navigation**: Each coordinator is only responsible for one component and makes no assumptions about its parent. It can therefore be placed wherever we want to.

> [The Coordinator](http://khanlou.com/2015/01/the-coordinator/) by **Soroush Khanlou**

## Why RxCoordinator
* Actual **navigation code is already written** and abstracted away

* Clear **separation of concerns**:
  - Coordinator: Coordinates routing of a set of routes
  - Route: Describes navigation path
  - Transition: Describe transition type and animation to new view
* **Reuse** coordinators, routers and transitions in different combinations
* Full support for **custom transitions/animations**
* Support for **embedding child views** / container views
* Provides **observables for presentation / dismissal** of views (E.g. block button until presentation is done)
* Generic BasicCoordinator class suitable for most use cases and therefore **less** need to write your **own coordinators**
* Still full **support** for your **own coordinator classes** conforming to our Coordinator protocol
* Generic AnyCoordinator type erasure class encapsulates all types of coordinators supporting the same set of routes. Therefor you can **easily replace coordinators**
* Use of enum for routes gives you **autocompletion** and **type safety** to perform only transition to routes supported by the coordinator.

### Components

### 🎢 Route
Describes a navigation path. Creates transition and loads View (and corresponding ViewModel) with the help of the coordinator performing the transition.

#### 👨‍✈️ Coordinator
An object coordinating the transition to a set of routes pointing to views or other coordinators.

#### 🏗 Transition Types
Describes presentation/dismissal of a view including the type of the transition and the animation used.
  - push: push view controller to navigation stack.
  - present: present view controller.
  - embed: embed view controller to a container view.
  - pop: pop the top view controller from the navigation stack and updates the display.
  - popToRoot: pop all the view controllers on the navigation stack except the root view controller and updates the display.
  - dismiss: dismissthe view controller that was presented modally by the view controller.
  - none: does nothing to the view controller

## 🛠 Installation

### CocoaPods

To integrate RxCoordinator into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'rx-coordinator'
```

### Manually

If you prefer not to use any of the dependency managers, you can integrate RxCoordinator into your project manually, by downloading the source code and placing the files on your project directory.

## 🏃‍♂️Getting started

Create an enum with all of the navigation paths for a particular flow. (It is up to you when to create a `Route/Coordinator`, but as **our rule of thumb**, create a new `Route/Coordinator` whenever is needed a new navigation controller.)

```swift 
enum HomeRoute: Route {
    case home
    case users
    case logout

    func prepareTransition(coordinator: AnyCoordinator<HomeRoute>) -> Transition {
        switch self {
        case .home:
            var vc = HomeViewController()
            let viewModel = HomeViewModel(coodinator: coordinator)
            vc.bind(to: viewModel)
            return .push(vc)
        case .users:
            var vc = UsersViewController()
            let viewModel = UsersViewModel(coodinator: coordinator)
            vc.bind(to: viewModel)
            return .push(vc)
        case .logout:
            return .dismiss()
        }
    }
}
```

Setup the root view controller in the AppDelegate.
```swift 
  ...
  var coordinator: AnyCoordinator<MainRoute>!

    func application(_ application:didFinishLaunchingWithOptions) -> Bool {
        guard let window = self.window else { return false }
        
        let basicCoordinator = BasicCoordinator<HomeRoute>(initalRoute: .home, initalLoadingType: .immediately)
        coordinator = AnyCoordinator(basicCoordinator)
        window.rootViewController = coordinator.navigationController

        return true
    }
```

## 🤸‍♂️Custom Transitions
RxCoordinator supports cases for custom transitions between view controllers. In the `switch case` in `prepareTransition(coordinator:)` create an `Animation` while specifying your custom presentation transition or/and dismissal transition. 

```swift 
  ...
  func prepareTransition(coordinator: AnyCoordinator<HomeRoute>) -> Transition {
        switch self {
        ...
        
        case .users(let string):
            *let animation = Animation(presentationAnimation: YourAwesomePresentationTransitionAnimation(), dismissalAnimation: YourAwesomeDismissalTransitionAnimation())*
            var vc = UsersViewController.instantiateFromNib()
            let viewModel = UsersViewModelImpl(coordinator: coordinator, string: string)
            vc.bind(to: viewModel)
            return *.push(vc, animation: animation)*
        ...
    }
```

## 🧙‍♂️Custom Coordinators
In RxCoordinator is possible to create custom coordinators. For example, a custom coordinator can be created to show Home if the user is logged in otehrwise Login.

```swift 

class CustomCoordinator<R: Route>: Coordinator {
    typealias CoordinatorRoute = R

    var context: UIViewController
    var navigationController = UINavigationController()
    
    init() {}
    
    func presented(from presentable: Presentable?) {
        if isLoggedIn {
          transition(to: .home)
        } else {
          transition(to: .login)
        }
    }
}

```

## 👨🏻‍💻 Usage

Implementation in the viewModel:

```swift
    ...
    
    init(coodinator: AnyCoordinator<HomeRoute>) {
        self.coordinator = coodinator
    }
    
    private lazy var usersAction: CocoaAction = {
        return CocoaAction {
            self.coordinator.transition(to: .users)
            return .empty()
        }
    }()
    
    ...
```

[**Example**](https://github.com/jdisho/RxCoordinator/tree/master/RxCoordinator-Example/RxCoordinator-Example) for more!

## 👤 Author
This tiny library is created with ❤️ by [QuickBird Studios](www.quickbirdstudios.com)

### 📃 License

RxCoordinator is released under an MIT license. See [License.md](https://github.com/jdisho/RxCoordinator/blob/master/LICENSE) for more information.

