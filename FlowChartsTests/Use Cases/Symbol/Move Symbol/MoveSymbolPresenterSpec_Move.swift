//
//  MoveSymbolPresenterSpec_Move.swift
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

class MoveSymbolPresenterSpec_Move: QuickSpec {
    
    override func spec() {
        
        describe("MoveSymbolPresenter") {
            
            var useCase: TestMoveSymbolUseCase!
            
            beforeEach {
                useCase = TestMoveSymbolUseCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onPanBegan?()
            }
            
            context("when pan moved") {
                
                beforeEach {
                    useCase.coordinatesConverter.diagramVector = Vector(2, 2)
                    useCase.ui.onPanMoved?(CGVector(dx: 1, dy: 1), UIView())
                }
                
                it("shoud move symbol") {
                    expect(useCase.interactor.location).to(equal(Point(2, 2)))
                }
                
                context("when pan ended and save succeeds") {
                    
                    beforeEach {
                        useCase.interactor.saveSucceeds = true
                        useCase.ui.onPanEnded?()
                    }
                    
                    it("should deactivate") {
                        expect(useCase.presenter.isDeactivated).to(beTrue())
                    }
                    
                    it("should save") {
                        expect(useCase.interactor.hasSaved).to(beTrue())
                        expect(useCase.interactor.hasRolledBack).to(beFalse())
                    }
                }
                
                context("when pan cancelled") {
                    
                    beforeEach {
                        useCase.ui.onPanCancelled?()
                    }
                    
                    it("should deactivate") {
                        expect(useCase.presenter.isDeactivated).to(beTrue())
                    }
                    
                    it("should rollback") {
                        expect(useCase.interactor.hasSaved).to(beFalse())
                        expect(useCase.interactor.hasRolledBack).to(beTrue())
                    }
                }
            }
        }
    }
}
