//
//  AccessoryWireframe.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 15/08/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

class AccessoryWireframe: AccessoryTransitionDelegate {
    
    let accessories: [Accessory]
    var animationsDuration: TimeInterval = 0.2
    private(set) var activeAccessory: Accessory?
    private var activationCoordinator: AccessoryTransitionCoordinator?
    
    init(accessories: [Accessory]) {
        
        guard !accessories.contains(where: { $0.state != .dismissed }) else {
            fatalError("Can't create wireframe with presented accessories")
        }
        
        self.accessories = accessories
        for accessory in accessories {
            accessory.transitionDelegate = self
        }
    }
    
    // MARK: - Lifecycle
    
    func present() {
        let coordinator = AccessoryTransitionCoordinator(animationDuration: animationsDuration)
        for accessory in accessories {
            accessory.transitionDelegate = self
            accessory.present(with: coordinator)
        }
        coordinator.performTransition()
    }
    
    func dismiss() {
        
        if let activeAccessory = activeAccessory {
            activeAccessory.transitionDelegate = nil
            let deactivationCoordinator = AccessoryTransitionCoordinator.instant()
            activeAccessory.deactivate(with: deactivationCoordinator)
            deactivationCoordinator.performTransition()
        }
        
        let coordinator = AccessoryTransitionCoordinator(animationDuration: animationsDuration)
        for accessory in accessories {
            accessory.dismiss(with: coordinator)
        }
        coordinator.performTransition()
    }
    
    // MARK: - AccessoryTransitionDelegate
    
    func accessoryWillActivate(_ accessory: Accessory) -> AccessoryTransitionCoordinator {
        activeAccessory = accessory
        activationCoordinator = AccessoryTransitionCoordinator(animationDuration: animationsDuration)
        for acc in accessories where acc != accessory {
            acc.dismiss(with: activationCoordinator!)
        }
        return activationCoordinator!
    }
    
    func accessoryDidActivate(_ accessory: Accessory) {
        activationCoordinator!.performTransition()
        activationCoordinator = nil
    }
    
    func accessoryWillDeactivate(_ accessory: Accessory) -> AccessoryTransitionCoordinator {
        activeAccessory = nil
        activationCoordinator = AccessoryTransitionCoordinator(animationDuration: animationsDuration)
        for acc in accessories where acc != accessory {
            acc.present(with: activationCoordinator!)
        }
        return activationCoordinator!
    }
    
    func accessoryDidDeactivate(_ accessory: Accessory) {
        activationCoordinator!.performTransition()
        activationCoordinator = nil
    }
}
