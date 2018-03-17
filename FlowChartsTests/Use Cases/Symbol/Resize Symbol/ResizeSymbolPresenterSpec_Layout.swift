//
//  ResizeSymbolPresenterSpec_Layout.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class ResizeSymbolPresenterSpec_Layout: QuickSpec {
    
    override func spec() {
        
        describe("ResizeSymbolPresenter") {
            
            var useCase: TestResizeSymbolTestCase!
            
            beforeEach {
                useCase = TestResizeSymbolTestCase()
                useCase.presenter.present(with: .instant())
                useCase.buttonsLayoutManager.resizeButtonLocations[useCase.ui.presentingView] = CGPoint(x: 42, y: 42)
                useCase.ui.layout()
            }
            
            it("should layout resize control button location") {
                expect(useCase.ui.buttonLocation).to(equal(CGPoint(x: 42, y: 42)))
            }
        }
    }
}
