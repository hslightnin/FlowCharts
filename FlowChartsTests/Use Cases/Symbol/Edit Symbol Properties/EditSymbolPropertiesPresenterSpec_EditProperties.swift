//
//  EditSymbolPropertiesPresenterSpec_EditProperties.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class EditSymbolPropertiesPresenterSpec_EditProperties: QuickSpec {
    
    override func spec() {
        
        describe("EditSymbolPropertiesPresenter") {
            
            var useCase: TestEditSymbolPropertiesUseCase!
            
            beforeEach {
                useCase = TestEditSymbolPropertiesUseCase()
                useCase.presenter.present(with: .instant())
            }
            
            context("when button tapped") {
                
                beforeEach {
                    useCase.ui.onButtonPressed?()
                }
                
                it("should activate") {
                    expect(useCase.presenter.isActivated).to(beTrue())
                }
                
                it("shoud present properties popover") {
                    expect(useCase.ui.isPropertiesPopoverPresented).to(beTrue())
                }
                
                it("should dismiss button") {
                    expect(useCase.ui.isButtonPresented).to(beFalse())
                }
                
                context("when shape preset selected") {
                    
                    beforeEach {
                        useCase.ui.onShapePresetSelected?(.ellipsis)
                    }
                    
                    it("shoudl change symbol shape preset") {
                        expect(useCase.interactor.shapePreset).to(be(ShapePreset.ellipsis))
                    }
                    
                    it("should save") {
                        expect(useCase.interactor.hasSaved).to(beTrue())
                        expect(useCase.interactor.hasRolledBack).to(beFalse())
                    }
                }
                
                context("when color selected") {
                    
                    beforeEach {
                        useCase.interactor.saveSucceeds = true
                        useCase.ui.onColorSelected?(.black)
                    }
                    
                    it("shoudl change symbol shape preset") {
                        expect(useCase.interactor.color).to(equal(UIColor.black))
                    }
                    
                    it("should save") {
                        expect(useCase.interactor.hasSaved).to(beTrue())
                        expect(useCase.interactor.hasRolledBack).to(beFalse())
                    }
                }
                
                context("when popover should dismiss") {
                    
                    beforeEach {
                        useCase.ui.onSelectionEnded?()
                    }
                    
                    it("should deactivate") {
                        expect(useCase.presenter.isDeactivated).to(beTrue())
                    }
                    
                    it("should dismiss properties popover") {
                        expect(useCase.ui.isPropertiesPopoverPresented).to(beFalse())
                    }
                    
                    it("should present button") {
                        expect(useCase.ui.isButtonPresented).to(beTrue())
                    }
                }
            }
        }
    }
}
