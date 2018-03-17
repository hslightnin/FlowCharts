//
//  EditLinkAnchorPresenterEditPropertiesSpec.swift
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

class EditLinkAnchorPresenterEditPropertiesSpec: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkAnchorPresenter") {
            
            var useCase: TestEditLinkAnchorUseCase!
            
            beforeEach {
                useCase = TestEditLinkAnchorUseCase()
                useCase.presenter.present(with: .instant())
            }
            
            context("when button pressed") {
                
                let expectedPointerVector = Vector(1, 1)
                let expectedSelectedPreset = PointerPreset.thinArrow
                
                beforeEach {
                    useCase.ui.pointerVector = Vector(-1, -1)
                    useCase.ui.selectedPointerPreset = PointerPreset.empty
                    useCase.editPropertiesInteractor.pointerVector = expectedPointerVector
                    useCase.editPropertiesInteractor.pointerPreset = expectedSelectedPreset
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
                
                it("should set pointer vector") {
                    expect(useCase.ui.pointerVector).to(equal(expectedPointerVector))
                }
                
                it("should set selected preset") {
                    expect(useCase.ui.selectedPointerPreset).to(be(expectedSelectedPreset))
                }
                
                context("when selected presets changed") {
                    
                    let expectedNewPreset = PointerPreset.strokedThickArrow
                    
                    beforeEach {
                        useCase.ui.onSelectedPointerPresetChanged?(expectedNewPreset)
                    }
                    
                    it("shoud set link anchor presets") {
                        expect(useCase.editPropertiesInteractor.pointerPreset).to(be(expectedNewPreset))
                    }
                    
                    it("shoud save") {
                        expect(useCase.editPropertiesInteractor.hasSaved).to(beTrue())
                        expect(useCase.editPropertiesInteractor.hasRolledBack).to(beFalse())
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
}
