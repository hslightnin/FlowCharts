#  Architecture

This is the short description of the architecture of the PureFlow app (https://itunes.apple.com/us/app/pureflow/id600955222).

## Table of contents

- [Basic concepts](#basic-concepts)
- [First problem: "Distributed" views](#first-problem-distributed-views)
- [First problem solution: Presenters](#first-problem-solution-presenters)
- [Second problem: Coordination of changes in the UI](#second-problem-coordination-of-changes-in-the-ui)
- [Second problem solution: Transitions](#second-problem-solution-transitions)
- [Implementation](#implementation)
- [Transitions](#transitions)
- [Managed Transitions](#managed-transitions)
- [UIViewController Transitions](#uiviewcontroller-transitions)
- [Presenters](#presenters)
- [Types of Presenters (based on behaviour)](#types-of-presenters-based-on-their-behaviour)
- [Free Presenters](#free-presenters)
- [Fixed Presenters](#fixed-presenters)
- [Flexible Presenters](#flexible-presenters)
- [Types of Presenters (base on presented content)](#types-of-presenters-base-on-presented-content)
- [Item Presenters](#item-presenters)
- [Use Case Presenters](#use-case-presenters)
- [Use Cases](#use-cases)

## Basic concepts

When building the app I faced two main problems. First I want to describe these problems and introduce concepts that helped me to solve them. As we will see, the architecture of the PureFlow app is not something completely unique. It is very similar to other patterns like MVP, MVVM and especially VIPER but with some peculiarities.

### First problem: "Distributed" views

Usually a module in an iOS application is built around UIViewController. This approach is used both in standard MVC pattern and other approaches like MVVM or VIPER. We take app's screen (or part of it) and turn it into separate module.

PureFlow app has basically one main screen and one UIViewController where user performs all tasks. Contents of this one UIViewController are always altered to perform various tasks (adding, deleting and editing diagram elements). So these patterns can't be used as is. We need to adopt them for our app.

The main difference is in the "View" part. In standard approach UI items for one task are located on one UIView and managed by one UIViewController. In PureFlow the "View" consists of various UI items located in different places in view hierarchy. Let's look at an example. If we want to edit symbol colour we need the following UI items: a UIButton (which is a subview of diagram scroll view), UITextView (which is a subview of diagram content view), UITapGestureRecognizer for double tap to start editing (which is added to symbol view) and UITapGestureRecognizer for cancelling editing (which is added to diagram scroll view). So we need 4 UI elements that are located in entirely different places and are not connected with each other by any means. They are "distributed" throughout view and view controller hierarchies.

These UI items can be UIViews, UIViewControllers, UIGestureRecognizes etc. We need a universal API for working with all those types of items in similar way.

### First problem solution: Presenters

The first major concept that is used throughout the app is *Presenter*. The concept is pretty simple and straightforward. Presenter can present UI items and dismiss them. It provides unified API for presenting and dismissing UIViews, CALayers, UIViewControllers, UIGestureRecognizers or anything else that lets user edit the diagram (it could be motion detection, speech recognition or whatever).

### Second problem: Coordination of changes in the UI

As I already said we are constantly changing our only screen for different tasks. We present and hide buttons, text views and other controls, present and dismiss view controllers. Usually we do it with some animation. All those UI items are used for different use cases and should be put inside different app modules. So we should not have direct access to them from one particular place in code (as it will have too many dependencies). But we need a way to perform operations with UI items from different modules together. For example we may need to present buttons for different use cases inside one animations block (Or present UI for one Use Case and dismiss UI for another inside the same animation block).

### Second problem solution: Transitions

This problem is solved by the use of *Transitions*. Transition is an object that encapsulates actions needed for the app to go from one state to another. Transition contains 3 stages: beginning, animation and completion. Before the state change all app modules that participate in it register their actions. Then the transition is performed.

## Implementation

So the main building blocks for the app are Presenters and Transitions.  Now let's describe their implementation and see how they work together.

### Transitions

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

The use is pretty simple. We create Transition, pass it to app modules responsible for different tasks, they register actions. Then we call `perform()` method.

There are two type of transitions: *Managed Transitions* and *View Controller Transitions*.

#### Managed Transitions

Managed transitions are managed by the user. We can configure animation properties and then perform transition. They inherit from [ManagedTransition](PresenterKit/Transition/ManagedTransition.swift) class.

#### UIViewController Transitions

View Controller Transitions do not allow user to modify animation properties. They perform animations alongside UIViewController presentation and dismission. They inherit from either [ViewControllerPresentationTransition](PresenterKit/Transition/ViewControllerPresentationTransition.swift) or [ViewControllerDismissionTransition](PresenterKit/Transition/ViewControllerDismissionTransition.swift) classes.

### Presenters

Presenter provides common interface for working with any entities that can be "presented".

Implementation of presenters is based on the use of Transitions. All presenters inherit from [Presenter](PresenterKit/Presenter/Presenter.swift) class. It has two opened method, where subclasses should prepare presentation or dismission actions:

```
open func setUpPresentation(withIn transition: Transition)
open func setUpDismission(withIn transition: Transition)
```

### Types of Presenters (based on their behaviour)

Different presented items have different behaviour. So we have several types of Presenters for working with different items. They differ in the way they work with Transitions.

#### Free presenters

Free presenters can be used with any Transition.

They inherit from [FreePresenter](PresenterKit/Presenter/FreePresenter.swift) class. Two main methods are:

```
func prepareForPresentation(withIn transition: Transition)
func prepareForDismission(withIn transition: Transition)
```

The user of the class creates any Transitions he wants and passes it to either one or several Presenters. Then the user performs Transition. The example is any UIKit control link UIButton or UITextView, we can present them with any animation we want.

#### Fixed presenters

Fixed presenters can only use transitions that they create for themselves.

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

When using Fixed Presenter we do not create Transition for it, but rather ask Presenter to create Transition for us. The example of use for such presenter is for example standard popover. We can't tell it to be presented with any arbitrary transition.

#### Flexible presenters

Flexible presenters can behave as free or fixed presenters depending on their state. They inherit from [FlexiblePresenter](PresenterKit/Presenter/FlexiblePresenter.swift) class.

Flexible Presenter have both sets of methods:

It has methods for working with arbitrary transitions:

```
func prepareForPresentation(withIn freeTransition: Transition)
func prepareForDismission(withIn freeTransition: Transition)
```

And methods for creating transitions:

```
func prepareFixedPresentationTransition() -> Transition
func prepareFixedDismissionTransition() -> Transition
```

The also have open methods that must to implemented by subclasses to determine how presenter should behave in concrete situation:

```
open var needsFixedPresentationTransition: Bool
open func createFixedPresentationTransition() -> Transition
open var needsFixedDismissionTransition: Bool
open func createFixedDismissionTransition() -> Transition
```

Free and Fixed transition are used for presenting single UI items. Flexible presenters usually present group of items. Though it is not strict rule. All types of presenters can be used in different situations.

### Types of Presenters (base on presented content)

Here we come to another important implementation concept. Presenters can be used for presenting single view items and for presenting groups of such items responsible for one task. The first are called Item Presents and the second - Use Case Presenters. Though these tasks may look similar they are quite different. Presenting a view item means some interactions with UIKit or CoreAnimation layers. Presenting a group of items means interpreting user actions and changing those items accordingly. Item Presenters play role of "Views" while Use Case Presenters play role of "Controllers" in our architecture. "Views" and "Controllers" share the same base class in our app. It may seem confusing but works pretty well.

#### Item presenters

Item Presenters are usually Free Presenters or Fixed Presenters. They present single UI item. The example of Free Item Presenter is [ButtonPresenter](FlowCharts/DiagramButtonPresenter.swift), the example of Fixed Item Presenter is [PopoverPresenter](FlowCharts/PopoverPresenter.swift).

#### Use Case Presenters

Use Case Presenters present several items. At different times Use Case Presenter can present different items. For example Use Case Presenter for editing symbol colour first presents button. When button is pressed it presents popover with collection view where user actually chooses color. I'll show an example in the next section.

## Use Cases

So we have Item Presenters for working with UI items and we have Use Case Presenters for presentation logic. Now lets see how they fit together.

The module of the app is called Use Case. Besides Item Presenters and Use Case Presenter it contains other classes.

Use Case Presenter interacts with Items Presenter through facade class called Use Case UI. Using of single facade for multiple Item Presenters makes code look cleaner and easier to read and makes it easier to write and maintain unit tests. Use Case UI can be reused for several use cases. For example there is the same UI for deleting links and symbols and for editing their text.

Use case has Interactor class that contains all interactions with model objects.

Use Case also has facade class for the entire module that creates all other components and establishes connections between them.

Simple example (Move Symbol Use Case):

[MoveSymbolUseCase](FlowCharts/Use%20Cases/Symbol/Move/MoveSymbolUseCase.swift) - Module facade, create module componets\
[MoveSymbolPresenter](FlowCharts/Use%20Cases/Symbol/Move/MoveSymbolPresenter.swift) - Use Case Presenter, contains presentation logic\
[MoveSymbolInteractor](FlowCharts/Use%20Cases/Symbol/Move/MoveSymbolInteractor.swift) - Interactor, interacts with the model\
[MoveSymbolUI](FlowCharts/Use%20Cases/Symbol/Move/MoveSymbolUI.swift) - Use Case UI, facade for interacting with Item Presenters Move Symbol Use Case has only one Item Presenter, usualy they have more)\
[PanGestureRecognizerPresenter](FlowCharts/PanGestureRecognizerPresenter.swift) - Item Presenter, present UIPanGestureRecognizer (can be reused for multiple Use Cases)

Unit Tests:

[MoveSymbolInteractorSpec](FlowChartsTests/Use%20Cases/Symbol/Move%20Symbol/MoveSymbolInteractorSpec.swift)\
[MoveSymbolPresenterSpec_General](FlowChartsTests/Use%20Cases/Symbol/Move%20Symbol/MoveSymbolPresenterSpec_General.swift)\
[MoveSymbolPresenterSpec_Move](FlowChartsTests/Use%20Cases/Symbol/Move%20Symbol/MoveSymbolPresenterSpec_Move.swift)\
[MoveSymbolPresenterSpec_MoveError](FlowChartsTests/Use%20Cases/Symbol/Move%20Symbol/MoveSymbolPresenterSpec_MoveError.swift)


