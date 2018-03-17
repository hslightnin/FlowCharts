//
//  StubLinkButtonsLayoutManager.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
@testable import FlowCharts

class StubLinkButtonsLayoutManager: LinkButtonsLayoutManagerProtocol {
    
    var deleteButtonLocations = [UIView: CGPoint]()
    var editTextButtonLocations = [UIView: CGPoint]()
    var editPropertiesButtonLocations = [UIView: CGPoint]()
    var originButtonLocations = [UIView: CGPoint]()
    var endingButtonLocations = [UIView: CGPoint]()
    
    func deleteButtonLocation(in view: UIView) -> CGPoint {
        return deleteButtonLocations[view] ?? .zero
    }
    
    func editTextButtonLocation(in view: UIView) -> CGPoint {
        return editTextButtonLocations[view] ?? .zero
    }
    
    func editPropertiesButtonLocation(in view: UIView) -> CGPoint {
        return editPropertiesButtonLocations[view] ?? .zero
    }
    
    func originButtonLocation(in view: UIView) -> CGPoint {
        return originButtonLocations[view] ?? .zero
    }
    
    func endingButtonLocation(in view: UIView) -> CGPoint {
        return endingButtonLocations[view] ?? .zero
    }
}
