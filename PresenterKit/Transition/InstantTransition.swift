//
//  InstantTransition.swift
//  PresenterKit
//
//  Created by Alexander Kozlov on 22/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

public class InstantTransition: Transition {
    
    override public func perform() {
        
        performBeginnings()
        performViewAnimations()
        performLayerAnimations(duration: 0, timingFunction: TransitionCurve.linear.layerTiminingFunction)
        performCompletions()
        
        // FreeTransition animates view with .beginFromCurrentState option. We need to commit transaction so further transition animations during current user event will begin from the right state.
        CATransaction.commit()
    }
}
