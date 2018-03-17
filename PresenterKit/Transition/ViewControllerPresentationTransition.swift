//
//  ViewControllerPresentationTransition.swift
//  PresenterKit
//
//  Created by Alexander Kozlov on 22/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

public class ViewControllerPresentationTransition: ViewControllerTransition {
    
    private let presentingViewController: UIViewController
    private let presentedViewController: UIViewController
    
    public init(presentingViewController: UIViewController, presentedViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        self.presentedViewController = presentedViewController
    }
    
    public override func perform() {
        presentingViewController.present(presentedViewController, animated: true)
        perform(with: presentedViewController.transitionCoordinator!)
    }
}
