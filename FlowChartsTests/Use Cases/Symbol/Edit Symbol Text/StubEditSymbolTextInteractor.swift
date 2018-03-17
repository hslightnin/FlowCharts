//
//  StubEditSymbolTextInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry
@testable import FlowCharts

class StubEditSymbolTextInteractor: StubContinuousInteractor, EditSymbolTextInteractorProtocol {

    var text: String?
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var textInsets = Vector()
    
    var textAreaPath: BezierPath {
        let path = BezierPath()
        path.move(to: Point(0, 0))
        path.addLine(to: Point(100, 0))
        path.addLine(to: Point(0, 100))
        path.close()
        return path
    }
}
