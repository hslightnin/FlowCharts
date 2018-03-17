//
//  StubEditLinkTextInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry
@testable import FlowCharts

class StubeEditLinkTextInteractor: StubContinuousInteractor, EditLinkTextInteractorProtocol {
    
    var text: String?
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var textInsets = Vector()
    
    var maxTextWidth: Double = 0
    var linkCenter = Point()
}
