//
//  StubEditSymbolPropertiesInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
@testable import FlowCharts

class StubEditSymbolPropertiesInteractor: StubInteractor, EditSymbolPropertiesInteractorProtocol {
    var shapePreset: ShapePreset = .rect
    var color: UIColor = .white
}
