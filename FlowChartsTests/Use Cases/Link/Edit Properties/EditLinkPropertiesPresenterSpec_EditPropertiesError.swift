//
//  EditLinkPropertiesPresenterSpec_EditPropertiesError.swift
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

class EditLinkPropertiesPresenterSpec_EditPropertiesError: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkPropertiesPresenter") {
            
            var useCase: TestEditLinkPropertiesUseCase!
            
            beforeEach {
                useCase = TestEditLinkPropertiesUseCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onButtonPressed?()
            }
            
            context("when save fails") {
                
                beforeEach {
                    useCase.interactor.saveFails = true
                }
                
                context("when selected presets changed") {
                    
                    beforeEach {
                        useCase.ui.onSelectedPresetsChanged?(LineTypePreset.poly, LineDashPatternPreset.medium)
                    }
                    
                    it("should try save and rollback") {
                        expect(useCase.interactor.hasSaved).to(beTrue())
                        expect(useCase.interactor.hasRolledBack).to(beTrue())
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
                    
                    context("when dismissed") {
                        
                        beforeEach {
                            useCase.presenter.dismiss(with: .instant())
                        }
                        
                        it("should not present button") {
                            expect(useCase.ui.isButtonPresented).to(beFalse())
                        }
                        
                        it("should dismiss popover") {
                            expect(useCase.ui.isPropertiesPopoverPresented).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}
