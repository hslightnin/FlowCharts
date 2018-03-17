//
//  ViewControllerTransition.swift
//  PresenterKit
//
//  Created by Alexander Kozlov on 22/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

public class ViewControllerTransition: Transition {
    
    private var endedInAdvance = false
    
    func perform(with transitionCoordinator: UIViewControllerTransitionCoordinator) {
        self.performBeginnings()
        let rootView = UIApplication.shared.keyWindow!.rootViewController!.view
        transitionCoordinator.animateAlongsideTransition(in: rootView, animation: { context in
            let duration = context.transitionDuration
            let timingFunction = TransitionCurve(viewAnimationCurve: context.completionCurve).layerTiminingFunction
            self.performLayerAnimations(duration: duration, timingFunction: timingFunction)
            self.performViewAnimations()
        }, completion: { context in
            if !self.endedInAdvance {
                self.performCompletions()
            }
        })
    }
    
    public override func end() {
        endedInAdvance = true
        performCompletions()
    }
}
