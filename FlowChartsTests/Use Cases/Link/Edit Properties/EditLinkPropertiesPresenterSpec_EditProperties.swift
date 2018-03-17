//
//  EditLinkPropertiesPresenterSpec_EditProperties.swift
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

class EditLinkPropertiesPresenterSpec_EditProperties: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkPropertiesPresenter") {
            
            var useCase: TestEditLinkPropertiesUseCase!
            
            beforeEach {
                useCase = TestEditLinkPropertiesUseCase()
                useCase.interactor.lineTypePreset = .curved
                useCase.interactor.lineDashPatternPreset = .solid
                useCase.presenter.present(with: .instant())
            }
            
            context("when button pressed") {
                
                beforeEach {
                    useCase.ui.onButtonPressed?()
                }
                
                it("should activate") {
                    expect(useCase.presenter.isActivated).to(beTrue())
                }
                
                it("should dismiss button") {
                    expect(useCase.ui.isButtonPresented).to(beFalse())
                }
                
                it("should present popover") {
                    expect(useCase.ui.isPropertiesPopoverPresented).to(beTrue())
                }
                
                it("should set selected line type preset") {
                    expect(useCase.ui.selectedLineTypePreset).to(be(LineTypePreset.curved))
                }
                
                it("should set selected line dash pattern preset") {
                    expect(useCase.ui.selectedLineDashPatternPreset).to(be(LineDashPatternPreset.solid))
                }
                
                context("when selected presets changed") {
                    
                    beforeEach {
                        useCase.ui.onSelectedPresetsChanged?(LineTypePreset.poly, LineDashPatternPreset.medium)
                    }
                    
                    it("should set line type preset") {
                        expect(useCase.interactor.lineTypePreset).to(be(LineTypePreset.poly))
                    }
                    
                    it("should set line dash pattern preset") {
                        expect(useCase.interactor.lineDashPatternPreset).to(be(LineDashPatternPreset.medium))
                    }
                    
                    it("should save") {
                        expect(useCase.interactor.hasSaved).to(beTrue())
                        expect(useCase.interactor.hasRolledBack).to(beFalse())
                    }
                    
                    it("should not deactivate") {
                        expect(useCase.presenter.isActivated).to(beTrue())
                    }
                    
                    it("should not present button") {
                        expect(useCase.ui.isButtonPresented).to(beFalse())
                    }
                    
                    it("should not dismiss popover") {
                        expect(useCase.ui.isPropertiesPopoverPresented).to(beTrue())
                    }
                }
                
                context("when popover should dismiss") {
                    
                    beforeEach {
                        useCase.ui.onPopoverShouldDismiss?()
                    }
                    
                    it("should deactivate") {
                        expect(useCase.presenter.isActivated).to(beFalse())
                    }
                    
                    it("should present button") {
                        expect(useCase.ui.isButtonPresented).to(beTrue())
                    }
                    
                    it("should dismiss popover") {
                        expect(useCase.ui.isPropertiesPopoverPresented).to(beFalse())
                    }
                }
            }
        }
    }
}
