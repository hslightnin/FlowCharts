//
//  ViewControllerDismissionTransition.swift
//  PresenterKit
//
//  Created by Alexander Kozlov on 22/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

public class ViewControllerDismissionTransition: ViewControllerTransition {
    
    private let viewController: UIViewController
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public override func perform() {
        viewController.dismiss(animated: true)
        perform(with: viewController.transitionCoordinator!)
    }
}
