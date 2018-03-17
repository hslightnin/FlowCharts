//
//  BuildLinkPresenterSpec_BuildLinkMoving.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import DiagramGeometry
import PresenterKit
@testable import FlowCharts

class BuildLinkPresenterSpec_BuildLinkMoving: QuickSpec {
    
    override func spec() {
        
        describe("BuildLinkPresenter") {
            
            var useCase: TestBuildLinkUseCase!
            
            beforeEach {
                useCase = TestBuildLinkUseCase()
                useCase.presenter.present(with: .instant())
                useCase.interactor.canSave = false
            }
            
            context("when pan began") {
                
                beforeEach {
                    useCase.ui.onPanBegan?()
                }
                
                it("should activate") {
                    expect(useCase.presenter.isActivated).to(beTrue())
                }
                
                it("should begin building link") {
                    expect(useCase.interactor.isInteracting).to(beTrue())
                }
                
                it("should not dismiss button") {
                    expect(useCase.ui.isButtonPresented).to(beTrue())
                }
                
                it("should present direction zones control") {
                    expect(useCase.ui.isDirectionZonesControlPresented).to(beTrue())
                }
                
                it("should not present symbol presets popover") {
                    expect(useCase.ui.isSymbolPresetsPopoverPresented).to(beFalse())
                }
                
                context("when pan moved") {
                    
                    let viewPoint = CGPoint(x: 1, y: 1)
                    let expectedDiagramPoint = Point(2, 2)
                    
                    beforeEach {
                        useCase.coordinatesConverter.onDiagramPoint = {
                            ($0 == viewPoint && $1 == useCase.ui.presentingView) ? expectedDiagramPoint : Point(.nan, .nan)
                        }
                        useCase.ui.onPanMoved?(viewPoint, useCase.ui.presentingView)
                    }
                    
                    it("should move link ending") {
                        expect(useCase.interactor.addedLinkEndingLocation).to(equal(expectedDiagramPoint))
                    }
                    
//                    it("should layout ui") {
//                        
//                    }
                }
            }
        }
    }
}

