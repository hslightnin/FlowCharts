//
//  ResizeSymbolPresenterSpec_General.swift
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

class ResizeSymbolPresenterSpec_General: QuickSpec {
    
    override func spec() {
        
        describe("ResizeSymbolPresenter") {
            
            var useCase: TestResizeSymbolTestCase!
            
            beforeEach {
                useCase = TestResizeSymbolTestCase()
            }
            
            it("should not create reference cycles") {
                weak var weakPresenter = useCase.presenter
                useCase.presenter = nil
                expect(weakPresenter).to(beNil())
            }
            
            context("when presented") {
                
                beforeEach {
                    useCase.presenter.present(with: .instant())
                }
                
                it("should present resize control") {
                    expect(useCase.ui.isResizeControlOn).to(beTrue())
                }
                
                context("when dismissed") {
                    
                    beforeEach {
                        useCase.presenter.dismiss(with: .instant())
                    }
                    
                    it("should dismiss resize control") {
                        expect(useCase.ui.isResizeControlOn).to(beFalse())
                    }
                }
            }
        }
    }
}
