//
//  StubMoveSymbolInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class StubMoveSymbolInteractor: StubContinuousInteractor, MoveSymbolInteractorProtocol {
    
    var location: Point?
    
    override func begin() {
        location = Point()
        super.begin()
    }
    
    func move(by translation: Vector) {
        location!.translate(by: translation)
    }
}
