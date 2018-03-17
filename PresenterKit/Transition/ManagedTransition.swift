//
//  ManagedTransition.swift
//  PresenterKit
//
//  Created by Alexander Kozlov on 22/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

public class ManagedTransition: Transition {
    
    let duration: TimeInterval
    let curve: TransitionCurve
    
    private var endedInAdvance = false
    private var completionTimer: Timer?
    private var completionHandler: (() -> Void)?
    
    public init(duration: TimeInterval, curve: TransitionCurve) {
        self.duration = duration
        self.curve = curve
    }
    
    override public func perform() {
        performBeginnings()
        performAnimations {
            if !self.endedInAdvance {
                self.performCompletions()
            }
        }
    }
    
    override public func end() {
        completionTimer?.invalidate()
        completionTimer = nil
        completionHandler = nil
        endedInAdvance = true
        performCompletions()
    }
    
    private func performAnimations(completion: @escaping () -> Void) {
        
        performLayerAnimations(duration: duration, timingFunction: curve.layerTiminingFunction)
        
        if animations.count > 0 {
            let options: UIViewAnimationOptions = [curve.viewAnimationOption, .beginFromCurrentState]
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.performViewAnimations()
            }, completion: { _ in
                completion()
            })
        } else if completions.count > 0 {
            completionHandler = completion
            completionTimer = Timer.scheduledTimer(
                timeInterval: duration,
                target: self,
                selector: #selector(completionTimer(_:)),
                userInfo: nil,
                repeats: false)
        }
    }
    
    func completionTimer(_ timer: Timer) {
        completionHandler?()
        completionHandler = nil
        completionTimer = nil
    }
}
