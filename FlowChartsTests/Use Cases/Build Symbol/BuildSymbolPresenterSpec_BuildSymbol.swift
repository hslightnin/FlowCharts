//
//  BuildSymbolPresenterSpec_BuildSymbol.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class BuildSymbolPresenterSpec_BuildSymbol: QuickSpec {
    
    override func spec() {
        
        describe("BuildSymbolPresenter") {
            
            var useCase: TestBuildSymbolUseCase!
            
            beforeEach {
                useCase = TestBuildSymbolUseCase()
                useCase.presenter.present(with: .instant())
            }
            
            context("when button pressed") {
                
                beforeEach {
                    useCase.ui.onButtonPressed?()
                }
                
                it("should create placeholder") {
                    expect(useCase.interactor.hasCreatedPlaceholder).to(beTrue())
                }
                
                it("should dismiss button") {
                    expect(useCase.ui.isButtonPresented).to(beFalse())
                }
                
                it("should present presets popover") {
                    expect(useCase.ui.isPresetsPopoverPresented).to(beTrue())
                }
                
                context("when presets selected") {
                    
                    beforeEach {
                        useCase.ui.onPresetsSelected?(ShapePreset.ellipsis, UIColor.green)
                    }
                    
                    it("should set presets") {
                        expect(useCase.interactor.addedSymbolShapePreset).to(be(ShapePreset.ellipsis))
                        expect(useCase.interactor.addedSymbolColor).to(be(UIColor.green))
                    }
                    
                    it("should fire onEnded") {
                        expect(useCase.hasEnded).to(beTrue())
                    }
                    
                    it("should not present button") {
                        expect(useCase.ui.isButtonPresented).to(beFalse())
                    }
                    
                    it("should not dismiss presets popover") {
                        expect(useCase.ui.isPresetsPopoverPresented).to(beTrue())
                    }
                    
                    context("when dismissed") {
                        
                        beforeEach {
                            useCase.presenter.dismiss(with: .instant())
                        }
                        
                        it("should not present button") {
                            expect(useCase.ui.isButtonPresented).to(beFalse())
                        }
                        
                        it("should dismiss presets popover") {
                            expect(useCase.ui.isPresetsPopoverPresented).to(beFalse())
                        }
                    }
                }
                
                context("when popover should dismiss") {
                    
                    beforeEach {
                        useCase.ui.onPresetsSelectionCancelled?()
                    }
                    
                    it("should fire onCancelled") {
                        expect(useCase.hasCancelled).to(beTrue())
                    }
                    
                    it("should not present button") {
                        expect(useCase.ui.isButtonPresented).to(beFalse())
                    }
                    
                    it("should not dismiss presets popover") {
                        expect(useCase.ui.isPresetsPopoverPresented).to(beTrue())
                    }
                    
                    context("when dismissed") {
                        
                        beforeEach {
                            useCase.presenter.dismiss(with: .instant())
                        }
                        
                        it("should not present button") {
                            expect(useCase.ui.isButtonPresented).to(beFalse())
                        }
                        
                        it("should dismiss button") {
                            expect(useCase.ui.isPresetsPopoverPresented).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}
