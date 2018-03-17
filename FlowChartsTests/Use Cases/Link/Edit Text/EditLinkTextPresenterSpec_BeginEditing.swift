//
//  EditLinkTextPresenterSpec_BeginEditing.swift
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

class EditLinkTextPresenterSpec_BeginEditing_Configuration: QuickConfiguration {

    override class func configure(_ configuration: Configuration) {

        sharedExamples("edit link text presenter began editing") { (sharedExampleContext: @escaping SharedExampleContext) in

            var useCase: TestEditLinkTextUseCase!
            
            beforeEach {
                useCase = sharedExampleContext()["useCase"] as! TestEditLinkTextUseCase
            }
            
            it("should hide text") {
                expect(useCase.interactor.text).to(beNil())
            }
            
            it("should set text") {
                expect(useCase.ui.text).to(equal("Original Text"))
            }
            
            it("should set font") {
                expect(useCase.ui.font).to(equal(UIFont.systemFont(ofSize: 42)))
            }
            
            it("should activate") {
                expect(useCase.presenter.isActivated).to(beTrue())
            }
            
            it("should dismiss button") {
                expect(useCase.ui.isButtonPresented).to(beFalse())
            }
            
            it("should dismiss double tap") {
                expect(useCase.ui.isDoubleTapPresented).to(beFalse())
            }
            
            it("should present edit text control") {
                expect(useCase.ui.isTextViewPresented).to(beTrue())
            }
            
            it("should present end tap") {
                expect(useCase.ui.isCancelTapPresented).to(beTrue())
            }
        }
    }
}

class EditLinkTextPresenterSpec_BeginEditing: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkTextPresenter") {
            
            var useCase: TestEditLinkTextUseCase!
            
            beforeEach {
                useCase = TestEditLinkTextUseCase()
                useCase.interactor.text = "Original Text"
                useCase.interactor.font = UIFont.systemFont(ofSize: 42)
                useCase.presenter.present(with: .instant())
            }
            
            context("when button pressed") {
                
                beforeEach {
                    useCase.ui.onButtonPressed?()
                }
                
                itBehavesLike("edit link text presenter began editing") { ["useCase": useCase] }
            }
            
            context("when double tap recognized") {
                
                beforeEach {
                    useCase.ui.onDoubleTapRecognized?()
                }
                
                itBehavesLike("edit link text presenter began editing") { ["useCase": useCase] }
            }
        }
    }
}
