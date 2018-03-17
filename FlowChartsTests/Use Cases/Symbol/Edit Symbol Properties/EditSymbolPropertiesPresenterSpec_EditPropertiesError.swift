//
//  EditSymbolPropertiesPresenterSpec_EditPropertiesError.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class EditSymbolPropertiesPresenterSpec_EditPropertiesError: QuickSpec {
    
    override func spec() {
        
        describe("EditSymbolPropertiesPresenter") {
            
            var useCase: TestEditSymbolPropertiesUseCase!
            
            beforeEach {
                useCase = TestEditSymbolPropertiesUseCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onButtonPressed?()
                useCase.interactor.saveFails = true
            }
            
            context("when shape preset selected and save failed") {
                
                beforeEach {
                    useCase.ui.onShapePresetSelected?(.ellipsis)
                }
                
                it("should change symbol shape preset") {
                    expect(useCase.interactor.shapePreset).to(be(ShapePreset.ellipsis))
                }
                
                it("should fire onError") {
                    expect(useCase.error).notTo(beNil())
                }
                
                it("should try save and rollback") {
                    expect(useCase.interactor.hasSaved).to(beTrue())
                    expect(useCase.interactor.hasRolledBack).to(beTrue())
                }
                
                context("when dismissed") {
                    
                    context("when dismissed") {
                        
                        beforeEach {
                            useCase.presenter.dismiss(with: .instant())
                        }
                        
                        it("should not present button") {
                            expect(useCase.ui.isButtonPresented).to(beFalse())
                        }
                        
                        it("should dismiss poporver") {
                            expect(useCase.ui.isPropertiesPopoverPresented).to(beFalse())
                        }
                    }
                }
            }
            
            context("when color selected and save failed") {
                
                beforeEach {
                    useCase.ui.onColorSelected?(.black)
                }
                
                it("shoudl change symbol shape preset") {
                    expect(useCase.interactor.color).to(equal(UIColor.black))
                }
                
                it("should fire onError") {
                    expect(useCase.error).notTo(beNil())
                }
                
                it("should try save and rollback") {
                    expect(useCase.interactor.hasSaved).to(beTrue())
                    expect(useCase.interactor.hasRolledBack).to(beTrue())
                }
                
                context("when dismissed") {
                    
                    context("when dismissed") {
                        
                        beforeEach {
                            useCase.presenter.dismiss(with: .instant())
                        }
                        
                        it("should not present button") {
                            expect(useCase.ui.isButtonPresented).to(beFalse())
                        }
                        
                        it("should dismiss poporver") {
                            expect(useCase.ui.isPropertiesPopoverPresented).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}

