//
//  ResizeSymbolPresenterSpec_Resizing.swift
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

class ResizeSymbolPresenterSpec_Resizing: QuickSpec {
    
    override func spec() {
        
        describe("ResizeSymbolPresenter") {
            
            var useCase: TestResizeSymbolTestCase!
            
            beforeEach {
                useCase = TestResizeSymbolTestCase()
                useCase.presenter.present(with: .instant())
            }
            
            context("when pan began") {
                
                beforeEach {
                    useCase.ui.onPanBegan?(.fromCenter)
                }
                
                it("should activate") {
                    expect(useCase.presenter.isActivated).to(beTrue())
                }
                
                it("should set resize mode") {
                    expect(useCase.interactor.mode).to(equal(SymbolResizingMode.fromCenter))
                }
                
                it("should begin resizing symbol") {
                    expect(useCase.interactor.isInteracting).to(beTrue())
                }
                
                context("when pan moved") {
                    
                    beforeEach {
                        let viewPoint = CGPoint(x: 1, y: 1)
                        let view = UIView()
                        useCase.coordinatesConverter.onDiagramPoint = {
                            ($0 == viewPoint && $1 == view) ? Point(2, 2) : Point(3, 3)
                        }
                        useCase.ui.onPanMoved?(viewPoint, view)
                    }
                    
                    it("should resize symbol") {
                        expect(useCase.interactor.rightBottomCorner).to(equal(Point(2, 2)))
                    }
                    
                    context("when pan eneded") {
                        
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
}
