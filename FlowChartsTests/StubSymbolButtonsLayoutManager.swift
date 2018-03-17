//
//  StubSymbolButtonsLayoutManager.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
@testable import FlowCharts

class StubSymbolButtonsLayoutManager: SymbolButtonsLayoutManagerProtocol {
    
    var deleteButtonLocations = [UIView: CGPoint]()
    var editTextButtonLocations = [UIView: CGPoint]()
    var resizeButtonLocations = [UIView: CGPoint]()
    var editButtonLocations = [UIView: CGPoint]()
    
    func deleteButtonLocation(in view: UIView) -> CGPoint {
        return deleteButtonLocations[view] ?? .zero
    }
    
    func editTextButtonLocation(in view: UIView) -> CGPoint {
        return editTextButtonLocations[view] ?? .zero
    }
    
    func resizeButtonLocation(in view: UIView) -> CGPoint {
        return resizeButtonLocations[view] ?? .zero
    }
    
    func editPropertiesButtonLocation(in view: UIView) -> CGPoint {
        return editButtonLocations[view] ?? .zero
    }
    
    func buildTopLinkButtonLocation(in view: UIView) -> CGPoint {
        return .zero
    }
    
    func buildBottomLinkButtonLocation(in view: UIView) -> CGPoint {
        return .zero
    }
    
    func buildRightLinkButtonLocation(in view: UIView) -> CGPoint {
        return .zero
    }
    
    func buildLeftLinkButtonLocation(in view: UIView) -> CGPoint {
        return .zero
    }
}
