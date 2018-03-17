//
//  EditLinkTextPresenterSpec_EndEditing.swift
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

class EditLinkTextPresenterSpec_EndEditing_Configuration: QuickConfiguration {
    
    override class func configure(_ configuration: Configuration) {
        
        sharedExamples("edit link text presenter ended editing") { (sharedExampleContext: @escaping SharedExampleContext) in
            
            var useCase: TestEditLinkTextUseCase!
            
            beforeEach {
                useCase = sharedExampleContext()["useCase"] as! TestEditLinkTextUseCase
            }
            
            it("should set text") {
                expect(useCase.interactor.text).to(equal("New Text"))
            }
            
            it("should save") {
                expect(useCase.interactor.hasSaved).to(beTrue())
                expect(useCase.interactor.hasRolledBack).to(beFalse())
            }
            
            it("should deactivate") {
                expect(useCase.presenter.isActivated).to(beFalse())
            }
            
            it("should present button") {
                expect(useCase.ui.isButtonPresented).to(beTrue())
            }
            
            it("should present double tap") {
                expect(useCase.ui.isDoubleTapPresented).to(beTrue())
            }
            
            it("should dismiss edit text control") {
                expect(useCase.ui.isTextViewPresented).to(beFalse())
            }
            
            it("should dismiss end tap") {
                expect(useCase.ui.isCancelTapPresented).to(beFalse())
            }
        }
        
        sharedExamples("edit link text presenter cancelled editing") { (sharedExampleContext: @escaping SharedExampleContext) in

            var useCase: TestEditLinkTextUseCase!

            beforeEach {
                useCase = sharedExampleContext()["useCase"] as! TestEditLinkTextUseCase
            }

            it("should rollback") {
                expect(useCase.interactor.hasSaved).to(beFalse())
                expect(useCase.interactor.hasRolledBack).to(beTrue())
            }

            it("should deactivate") {
                expect(useCase.presenter.isActivated).to(beFalse())
            }

            it("should present button") {
                expect(useCase.ui.isButtonPresented).to(beTrue())
            }

            it("should present double tap") {
                expect(useCase.ui.isDoubleTapPresented).to(beTrue())
            }

            it("should dismiss edit text control") {
                expect(useCase.ui.isTextViewPresented).to(beFalse())
            }

            it("should dismiss end tap") {
                expect(useCase.ui.isCancelTapPresented).to(beFalse())
            }
        }
    }
}

class EditLinkTextPresenterSpec_EndEditing: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkTextPresenter") {
            
            var useCase: TestEditLinkTextUseCase!
            
            beforeEach {
                useCase = TestEditLinkTextUseCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onButtonPressed?()
                useCase.ui.text = "New Text"
            }
            
            context("when edit text control ended editing") {
                
                beforeEach {
                    useCase.ui.onTextViewEndedEditing?()
                }
                
                itBehavesLike("edit link text presenter ended editing") { ["useCase": useCase] }
            }
            
            context("when end tap recognized") {
                
                beforeEach {
                    useCase.ui.onCancelTapRecognized?()
                }
                
                itBehavesLike("edit link text presenter ended editing") { ["useCase": useCase] }
            }
            
            context("when edit text control cancelled editing") {
                
                beforeEach {
                    useCase.ui.onTextViewCancelledEditing?()
                }
                
                itBehavesLike("edit link text presenter cancelled editing") { ["useCase": useCase] }
            }
        }
    }
}
