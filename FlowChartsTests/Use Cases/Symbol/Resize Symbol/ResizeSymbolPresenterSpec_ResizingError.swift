//
//  ResizeSymbolPresenterSpec_ResizingError.swift
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

class ResizeSymbolPresenterSpec_ResizingError: QuickSpec {
    
    override func spec() {
        
        describe("ResizeSymbolPresenter") {
            
            var useCase: TestResizeSymbolTestCase!
            
            beforeEach {
                useCase = TestResizeSymbolTestCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onPanBegan?(.fromCenter)
                useCase.ui.onPanMoved?(CGPoint(x: 1, y: 1), useCase.ui.presentingView)
                useCase.interactor.saveFails = true
            }
            
            context("when pan eneded and save failed") {
                
                beforeEach {
                    useCase.ui.onPanEnded?()
                }
                
                it("should not deactivate") {
                    expect(useCase.presenter.isActivated).to(beTrue())
                }
                
                it("should fire onError") {
                    expect(useCase.error).notTo(beNil())
                }
                
                it("should try save and rollback") {
                    expect(useCase.interactor.hasSaved).to(beTrue())
                    expect(useCase.interactor.hasRolledBack).to(beTrue())
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
