//
//  Transition+Default.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 26/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit

extension Transition {
    
    static func defaultPresentation() -> Transition {
        if UIApplication.shared.isRunningTests {
            return .instant()
        } else if UserDefaults.standard.slowPresentationTransitions {
            return ManagedTransition(duration: 2.0, curve: .easeInOut)
        } else {
            return ManagedTransition(duration: 0.10, curve: .easeInOut)
        }
    }
    
    static func defaultChangeover() -> Transition {
        if UIApplication.shared.isRunningTests {
            return .instant()
        } else if UserDefaults.standard.slowChangeoverTransitions {
            return ManagedTransition(duration: 3.0, curve: .easeInOut)
        } else {
            return ManagedTransition(duration: 0.15, curve: .easeInOut)
        }
    }
    
    static func defaultDismission() -> Transition {
        if UIApplication.shared.isRunningTests {
            return .instant()
        } else if UserDefaults.standard.slowDismissionTransitions {
            return ManagedTransition(duration: 4.0, curve: .easeInOut)
        } else {
            return ManagedTransition(duration: 0.20, curve: .easeInOut)
        }
    }
}
