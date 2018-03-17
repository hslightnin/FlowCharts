//
//  BuildLinkPresenterSpec_BuildLinkToNewSymbol.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class BuildLinkPresenterSpec_BuildLinkToNewSymbol: QuickSpec {
    
    override func spec() {
        
        describe("BuildLinkPresenter") {
            
            var useCase: TestBuildLinkUseCase!
            
            beforeEach {
                useCase = TestBuildLinkUseCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onPanBegan?()
                useCase.interactor.hasAddedLink = true
                useCase.interactor.hasAddedSymbol = true
                useCase.interactor.canSave = true
            }
            
            context("when pan ended") {
                
                beforeEach {
                    useCase.ui.onPanEnded?()
                }
                
                it("should not deactivate") {
                    expect(useCase.presenter.isActivated).to(beTrue())
                }
                
                it("should not dismiss button") {
                    expect(useCase.ui.isButtonPresented).to(beTrue())
                }
                
                it("should dismiss direction zones control") {
                    expect(useCase.ui.isDirectionZonesControlPresented).to(beFalse())
                }
                
                it("should present symbol presets popover") {
                    expect(useCase.ui.isSymbolPresetsPopoverPresented).to(beTrue())
                }
                
                context("when presets selected") {
                    
                    let expectedAddedSymbolShapePreset = ShapePreset.rhombus
                    let expectedAddedSymbolColor = UIColor.red
                    
                    beforeEach {
                        useCase.ui.onPresetsSelected?(expectedAddedSymbolShapePreset, expectedAddedSymbolColor)
                    }
                    
                    it("should set presets") {
                        expect(useCase.interactor.addedSymbolShapePreset).to(be(expectedAddedSymbolShapePreset))
                        expect(useCase.interactor.addedSymbolColor).to(equal(expectedAddedSymbolColor))
                    }
                    
                    it("should save") {
                        expect(useCase.interactor.hasSaved).to(beTrue())
                        expect(useCase.interactor.hasRolledBack).to(beFalse())
                    }
                    
                    it("should fire onEnded") {
                        expect(useCase.hasEnded).to(beTrue())
                        expect(useCase.error).to(beNil())
                    }
                    
                    it("should not deactivate") {
                        expect(useCase.presenter.isActivated).to(beTrue())
                    }
                    
                    it("should dismiss button") {
                        expect(useCase.ui.isButtonPresented).to(beFalse())
                    }
                    
                    it("should not present direction zones control") {
                        expect(useCase.ui.isDirectionZonesControlPresented).to(beFalse())
                    }
                    
                    it("should not dismiss symbol presets popover") {
                        expect(useCase.ui.isSymbolPresetsPopoverPresented).to(beTrue())
                    }
                }
                
                context("when should dismiss popover") {
                    
                    beforeEach {
                        useCase.ui.onPresetsSelectionCancelled?()
                    }
                    
                    it("should rollback") {
                        expect(useCase.interactor.hasSaved).to(beFalse())
                        expect(useCase.interactor.hasRolledBack).to(beTrue())
                    }
                    
                    it("should deactivate") {
                        expect(useCase.presenter.isActivated).to(beFalse())
                    }
                    
                    // TODO: Actually it should dismiss it instantly and present again.
                    it("should not dismiss button") {
                        expect(useCase.ui.isButtonPresented).to(beTrue())
                    }
                    
                    it("should not present direction zones control") {
                        expect(useCase.ui.isDirectionZonesControlPresented).to(beFalse())
                    }
                    
                    it("should dismiss symbol presets popover") {
                        expect(useCase.ui.isSymbolPresetsPopoverPresented).to(beFalse())
                    }
                }
            }
        }
    }
}
