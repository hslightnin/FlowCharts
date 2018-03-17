//
//  Transition.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 18/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

public class Transition: NSObject {
    
    private(set) var beginnings = [() -> Void]()
    private(set) var animations = [() -> Void]()
    private(set) var layerAnimations = [(CALayer, CABasicAnimation)]()
    private(set) var completions = [() -> Void]()
    
    public static func instant() -> Transition {
        return InstantTransition()
    }
    
    public func add(beginning: (() -> Void)? = nil, animation: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        
        if beginning != nil {
            beginnings.append(beginning!)
        }
        
        if animation != nil {
            animations.append(animation!)
        }
        
        if completion != nil {
            completions.append(completion!)
        }
    }
    
    public func addBeginning(_ beginning: @escaping () -> Void) {
        beginnings.append(beginning)
    }
    
    public func addAnimation(_ animation: @escaping () -> Void) {
        animations.append(animation)
    }
    
    public func addCompletion(_ completion: @escaping () -> Void) {
        completions.append(completion)
    }
    
    public func addLayerAnimation(layer: CALayer, keyPath: String, from: Any?, to: Any?) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        layerAnimations.append((layer, animation))
    }
    
    public func perform() {
        fatalError("Must be implemented in sublasses")
    }
    
    public func end() {
        fatalError("Must be implemented in sublasses")
    }
    
    func performBeginnings() {
        beginnings.forEach { $0() }
    }
    
    func performViewAnimations() {
        animations.forEach { $0() }
    }
    
    func performLayerAnimations(duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        for (layer, animation) in layerAnimations {
            animation.duration = duration
            animation.timingFunction = timingFunction
            layer.add(animation, forKey: animation.keyPath)
        }
    }
    
    func performCompletions() {
        completions.forEach { $0() }
    }
}
