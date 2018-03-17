//
//  EditLinkAnchorPresenterMoveSpec.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class EditLinkAnchorPresenterMoveSpec: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkAnchorPresenter") {
            
            var useCase: TestEditLinkAnchorUseCase!
            
            beforeEach {
                useCase = TestEditLinkAnchorUseCase()
            }
            
            context("when presented") {
                
                beforeEach {
                    useCase.presenter.present(with: .instant())
                }
                
                it("should present pan") {
                    expect(useCase.ui.isButtonPresented).to(beTrue())
                }
                
                context("when pan began") {
                    
                    beforeEach {
                        useCase.ui.onPanBegan?()
                    }
                    
                    it("should activate") {
                        expect(useCase.presenter.isActivated).to(beTrue())
                    }
                    
                    it("should begin moving link anchor") {
                        expect(useCase.moveInteractor.isInteracting).to(beTrue())
                    }
                    
                    context("when pan moved") {
                        
                        let viewPoint = CGPoint(x: 1, y: 1)
                        let diagramPoint = Point(2, 2)
                        
                        beforeEach {
                            useCase.coordinatesConverter.onDiagramPoint = {
                                ($0 == viewPoint && $1 === useCase.ui.presentingView) ?
                                    diagramPoint : Point(.nan, .nan)
                            }
                            useCase.ui.onPanMoved?(viewPoint, useCase.ui.presentingView)
                        }
                        
                        it("should move link anchor") {
                            expect(useCase.moveInteractor.anchorLocation).to(equal(diagramPoint))
                        }
                    
                        context("when pan ended and can save") {
                            
                            beforeEach {
                                useCase.moveInteractor.canSave = true
                                useCase.ui.onPanEnded?()
                            }
                            
                            it("should save") {
                                expect(useCase.moveInteractor.hasSaved).to(beTrue())
                                expect(useCase.moveInteractor.hasRolledBack).to(beFalse())
                            }
                            
                            it("should deactivate") {
                                expect(useCase.presenter.isActivated).to(beFalse())
                            }
                        }
                        
                        context("when pan ended and can't save") {
                            
                            beforeEach {
                                useCase.moveInteractor.canSave = false
                                useCase.ui.onPanEnded?()
                            }
                            
                            it("should rollback") {
                                expect(useCase.moveInteractor.hasSaved).to(beFalse())
                                expect(useCase.moveInteractor.hasRolledBack).to(beTrue())
                            }
                            
                            it("should deactivate") {
                                expect(useCase.presenter.isActivated).to(beFalse())
                            }
                        }
                        
                        context("when pan cancelled") {
                            
                            beforeEach {
                                useCase.ui.onPanCancelled?()
                            }
                            
                            it("should rollback") {
                                expect(useCase.moveInteractor.hasSaved).to(beFalse())
                                expect(useCase.moveInteractor.hasRolledBack).to(beTrue())
                            }
                            
                            it("should deactivate") {
                                expect(useCase.presenter.isActivated).to(beFalse())
                            }
                        }
                    }
                }
                
                context("when dismissed") {
                    
                    beforeEach {
                        useCase.presenter.dismiss(with: .instant())
                    }
                    
                    it("should dismiss pan") {
                        expect(useCase.ui.isButtonPresented).to(beFalse())
                    }
                }
            }
        }
    }
}
