#  Architecture

Here I describe the architecture of the PureFlow app (https://itunes.apple.com/us/app/pureflow/id600955222).

## Basic concepts.

When building the architecture of this app I faced two main problems. Let's describe these problems and introduce concepts that helped to solve them.

### First problem: Decomposition into modules

Usually a module in an iOS application is build around UIViewController. This approach is used both in standard MVC pattern and in other pattens like MVVM or VIPER. We take app's screen (or part of it) and turn it into separate module.

PureFlow has basically one screen and one UIViewController where user performs all tasks. Contents of this one UIViewController are always altered to perform various tasks (adding, deleting and editing diagram elements). So these patterns can't be as is. We need to change them so they fit out app.

The main difference is in the "View" part. In PureFlow the "View" consists of various UI items located in different places in view hierarchy. Let's look at example. If we want to edit symbol colour we need the following UI items: a UIButton (which is a subview of diagram scroll view), UITextView (which is a subview of diagram content view), UITapGestureRecognizer for double tap to start editing (which is added to symbol view) and UITapGestureRecognizer for cancelling ediging (which is added to diagram scroll view). So we need 4 UI elements that are located in entirely different places and are not connected with each other.

These UI items can be UIViews, UIViewControllers, UIGestureRecognizes etc. We need a universal API for working with all those types of items in similar way.

### Presenters

The first major concept that is used throughout the app is *Presenter*. The concept is pretty simple and straightforward. Presenter can present UI items and dismiss them. It provides unified API for presenting and dismissing UIViews, CALayers, UIViewControllers, UIGestureRecognizers or anything else that lets user edit the diagram (it could be motion detection, speech recognition or whatever).

### Use Cases

The second major concept is *Use Case*. As those items are not connected with each other (for example by the common parent view) we need to create some entities that manage all those items together. These entities are Use Cases. Use Case manages UI items for performing one particular task. Use Case is a the name for the app's module. It contains presentation and business logic for one task.

### Second problem: Coordination of changes in the UI

As I said we are constantly changing our only screen for different tasks. We show and hide buttons, text views and other controls, present and dismiss view controllers. Usually we do it with some animations. All those UI items belong to different Use Cases. Therefore they are located in different modules and we should not have direct access to them from one particular place in code. But we need a way to perform operations with UI items from different Use Cases together. For example we may need to present buttons for different use cases inside one animations block (Or present UI for one Use Case and dismiss UI for another inside the same animation block).

### Transitions

This problem is solved by the use of *Transitions*. Transition is an object that encapsulates actions needed for the app to go from one state to another. Transition contains 3 stages: beginning, animation and completion. Before the state change all Use Cases that participate in it register their actions. Then the transition is performed.

## Implementation

So the design is based on 3 major concepts: Transitions, Presenters and Use Cases. Let's describe their implementation and them see how they fit together.

### Transitions implementation

All transitions inherit from the [Transition](PresenterKit/Transition/Transition.swift) class.

It has methods for registering actions:

```
func addBeginning(_ beginning: @escaping () -> Void)
func addAnimation(_ animation: @escaping () -> Void)
func addCompletion(_ completion: @escaping () -> Void)
```

And method for performing transition:

```
func perform()
```

The use is pretty simple. We create Transition, pass it to Use Cases, they register actions. Then we call `perform()` method.

There are two type of transitions: *Managed Transitions* and *View Controller Transitions*.

Managed transitions are managed by the user. We can configure animation properties and then perform transition. They inherit from [ManagedTransition](PresenterKit/Transition/ManagedTransition.swift) class.

View Controller Transitions do not allow user to modify animation properties. They perform animations alongside UIViewController presentation and dismission. They inherit from either [ViewControllerPresentationTransition](PresenterKit/Transition/ViewControllerPresentationTransition.swift) or from [ViewControllerDismissionTransition](PresenterKit/Transition/ViewControllerDismissionTransition.swift) classes.

### Item Presenters and Use Case Presenters

I already said that Presenter provides common interface for working with various UI items. But they are used not only for presenting single UI items. They can present UI for the entire Use Cases. Such presenters are called Use Case Presenters. The do not interact with UI items directly but with Item Presenters. (Moreover, there are Mission Presenter that present several Use Case Presenters, but this part of design if not finished yet). The interesting thing here is that Item Presenters contain view login, so they ares "Views" in terms of MVC pattern. Use Case Presenters contain presentation logic, so they would be "Controllers" in MVC. So "Views" and "Controllers" share the same base class in our app. It may seem confusing but works pretty well.

### Presenter

Implementation of presenters is based on the use of Transitions. All presenters inherit from [Presenter](PresenterKit/Presenter/Presenter.swift) class. It has two opened method, where subclasses should prepare presentation or dismission actions:

```
open func setUpPresentation(withIn transition: Transition)
open func setUpDismission(withIn transition: Transition)
```

There 3 types of presenters: Free, Fixed and Flexible. For now Free and Fixed Presenters are used for Item Presenters and Flexible are used for Use Case Presenters. But that's not a rule. Both Item Presenters and Use Case Presenters can inherit from any of the 3 type.

### Free presenter

Free presenters can be used with any transition. User of this presenter can create any Transition and pass it to Free Presenter.

They inherit from [FreePresenter](PresenterKit/Presenter/FreePresenter.swift) class. Two main methods are:

```
func prepareForPresentation(withIn transition: Transition)
func prepareForDismission(withIn transition: Transition)
````

### Fixed presenter

Fixed presenters can only use transitions that they create for themselves. When using Fixed Presenter we do not create Transition for it, but rather ask Presenter to create Transition for us.

They inherit from [FixedPresenter](PresenterKit/Presenter/FixedPresenter.swift) class. Here we have methods that return Transitions:

```
func preparePresentationTransition() -> Transition
func prepareDismissionTransition() -> Transition
```

Subclasses must implement methods for creating fixed transitions:

```
open func createPresentationTransition() -> Transition
open func createDismissionTransition() -> Transition
```

### Item presenters

Item Presenters are either Free Presenters or Fixed Presenters. The example of Free Presenter is [ButtonPresenter](FlowCharts/DiagramButtonPresenter.swift), the example of Fixed presenter is [PopoverPresenter](FlowCharts/PopoverPresenter.swift).

### Use Case Presenters (Flexible Presenters)

Use Case Presenters present several items. Also at different times Use Case Presenter can present different items. For example Use Case Presenter for editing symbol colour first presents button. When button is pressed it presents popover with collection view. So it can be behave as free or fixed presenters depending on their state. Such presenters are called Flexible Presenters. The inherit from [FlexiblePresenter](PresenterKit/Presenter/FlexiblePresenter.swift) class.

Flexible Presenter have both sets of methods:

It has methods for working with free transitions:

```
func prepareForPresentation(withIn freeTransition: Transition)
func prepareForDismission(withIn freeTransition: Transition)
```

And methods for working with fixed transitions:

```
func prepareFixedPresentationTransition() -> Transition
func prepareFixedDismissionTransition() -> Transition
```

The also have open methods that must to implemented by suclasses to determine how presenter should behave:

```
open var needsFixedPresentationTransition: Bool
open func createFixedPresentationTransition() -> Transition
open var needsFixedDismissionTransition: Bool
open func createFixedDismissionTransition() -> Transition
```

### Use Case Structure

Not let's look at the structure of the app's module (Use Case). As I've already said that it includes Item Presenters and Use Case Presenter.

Use Case Presenter interacts with Items Presenter through facade class called Use Case UI. Using of single facade for multiple Item Presenters makes code look cleaner and easier to read and makes it easier to write and maintain unit tests. Use Case UI can be reused for several use cases. For example there is the same UI for deleting links and symbols and for editing their text.

Use case has Interactor class that contains all business logic for the Use Case. The name is taken from VIPER pattern.

Use Case also has Use Case facade class that creates all other module components and establishes connections between them.

Simple example (Move Symbol Use Case):

[MoveSymbolUseCase](FlowCharts/Use%20Cases/Symbol/Move/MoveSymbolUseCase.swift) - Module facade, create module componets

[MoveSymbolPresenter](FlowCharts/Use%20Cases/Symbol/Move/MoveSymbolPresenter.swift) - Use Case Presenter, contains presentation logic

[MoveSymbolInteractor](FlowCharts/Use%20Cases/Symbol/Move/MoveSymbolInteractor.swift) - Interactor, interacts with the model

[MoveSymbolUI](FlowCharts/Use%20Cases/Symbol/Move/MoveSymbolUI.swift) - Use Case UI, facade for interacting with Item Presenters Move Symbol Use Case has only one Item Presenter, usualy they have more)

[PanGestureRecognizerPresenter](FlowCharts/PanGestureRecognizerPresenter.swift) - Item Presenter, present UIPanGestureRecognizer (can be reused for multiple Use Cases)

Unit Tests:

[MoveSymbolInteractorSpec](FlowChartsTests/Use%20Cases/Symbol/Move%20Symbol/MoveSymbolInteractorSpec.swift)

[MoveSymbolPresenterSpec_General](FlowChartsTests/Use%20Cases/Symbol/Move%20Symbol/MoveSymbolPresenterSpec_General.swift)

[MoveSymbolPresenterSpec_Move](FlowChartsTests/Use%20Cases/Symbol/Move%20Symbol/MoveSymbolPresenterSpec_Move.swift)

[MoveSymbolPresenterSpec_MoveError](FlowChartsTests/Use%20Cases/Symbol/Move%20Symbol/MoveSymbolPresenterSpec_MoveError.swift)
