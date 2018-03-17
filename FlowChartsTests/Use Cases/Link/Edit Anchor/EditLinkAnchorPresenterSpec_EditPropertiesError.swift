//
//  EditLinkAnchorPresenterEditPropertiesErrorSpec.swift
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

class EditLinkAnchorPresenterEditPropertiesErrorSpec: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkAnchorPresenter") {
            
            var useCase: TestEditLinkAnchorUseCase!
            
            beforeEach {
                useCase = TestEditLinkAnchorUseCase()
            }
            
            context("when save fails") {
                
                beforeEach {
                    useCase.editPropertiesInteractor.saveFails = true
                }
                
                context("when selected pointer preset changed ") {
                    
                    beforeEach {
                        useCase.presenter.present(with: .instant())
                        useCase.ui.onButtonPressed?()
                        useCase.ui.onSelectedPointerPresetChanged?(.empty)
                    }
                    
                    it("should try save and rollback") {
                        expect(useCase.editPropertiesInteractor.hasSaved).to(beTrue())
                        expect(useCase.editPropertiesInteractor.hasRolledBack).to(beTrue())
                    }
                    
                    it("should not deacivate") {
                        expect(useCase.presenter.isActivated).to(beTrue())
                    }
                    
                    it("should fire onError") {
                        expect(useCase.error).notTo(beNil())
                    }
                    
                    context("when dismissed") {
                        
                        beforeEach {
                            useCase.presenter.dismiss(with: .instant())
                        }
                        
                        it("should dismiss button") {
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
