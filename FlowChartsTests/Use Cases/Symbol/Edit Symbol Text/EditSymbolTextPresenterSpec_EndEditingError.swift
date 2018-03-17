//
//  EditSymbolTextPresenterSpec_EndEditingError.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class EditSymbolTextPresenterSpec_EndEditingError: QuickSpec {
    
    override func spec() {
        
        describe("EditSymbolTextPresenter") {
            
            var useCase: TestEditSymbolTextUseCase!
            
            beforeEach {
                useCase = TestEditSymbolTextUseCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onButtonPressed?()
                useCase.ui.text = "New Text"
                useCase.interactor.saveFails = true
            }
            
            context("when edit text control ended editing") {
                
                beforeEach {
                    useCase.ui.onTextViewEndedEditing?()
                }
                
                itBehavesLike("edit symbol text presenter failed save") { ["useCase": useCase] }
            }
            
            context("when end tap recognized") {
                
                beforeEach {
                    useCase.ui.onCancelTapRecognized?()
                }
                
                itBehavesLike("edit symbol text presenter failed save") { ["useCase": useCase] }
            }
        }
    }
}

class EditSymbolTextPresenterSpec_EndEditingError_Configuration: QuickConfiguration {
    
    override class func configure(_ configuration: Configuration) {
        
        sharedExamples("edit symbol text presenter failed save") { (sharedExampleContext: @escaping SharedExampleContext) in
            
            var useCase: TestEditSymbolTextUseCase!
            
            beforeEach {
                useCase = sharedExampleContext()["useCase"] as! TestEditSymbolTextUseCase
            }
            
            it("should try save and rollback") {
                expect(useCase.interactor.hasSaved).to(beTrue())
                expect(useCase.interactor.hasRolledBack).to(beTrue())
            }
            
            it("should not deactivate") {
                expect(useCase.presenter.isActivated).to(beTrue())
            }
            
            it("should present button") {
                expect(useCase.ui.isButtonPresented).to(beFalse())
            }
            
            it("should present double tap") {
                expect(useCase.ui.isDoubleTapPresented).to(beFalse())
            }
            
            it("should dismiss edit text control") {
                expect(useCase.ui.isTextViewPresented).to(beTrue())
            }
            
            it("should dismiss end tap") {
                expect(useCase.ui.isCancelTapPresented).to(beTrue())
            }
        }
    }
}
