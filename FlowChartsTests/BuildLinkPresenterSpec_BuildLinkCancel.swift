//
//  BuildLinkPresenterSpec_BuildLinkCancel.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class BuildLinkPresenterSpec_BuildLinkCancel: QuickSpec {
    
    override func spec() {
        
        describe("BuildLinkPresenter") {
            
            var useCase: TestBuildLinkUseCase!
            
            beforeEach {
                useCase = TestBuildLinkUseCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onPanBegan?()
            }
            
            context("when pan ended and can't save link") {
                
                beforeEach {
                    useCase.interactor.canSave = false
                    useCase.ui.onPanEnded?()
                }
                
                itBehavesLike("build link presenter cancelled building link") { ["useCase": useCase] }
            }
            
            context("when pan cancelled") {
                
                beforeEach {
                    useCase.interactor.canSave = true
                    useCase.ui.onPanCancelled?()
                }
                
                itBehavesLike("build link presenter cancelled building link") { ["useCase": useCase] }
            }
        }
    }
}

class BuildLinkPresenterSpec_BuildLinkCancel_Configuration: QuickConfiguration {
    
    override class func configure(_ configuration: Configuration) {
        
        sharedExamples("build link presenter cancelled building link") { (sharedExampleContext: @escaping SharedExampleContext) in
            
            var useCase: TestBuildLinkUseCase!
            
            beforeEach {
                useCase = sharedExampleContext()["useCase"] as! TestBuildLinkUseCase
            }
            
            it("should deactivate") {
                expect(useCase.presenter.isActivated).to(beFalse())
            }
            
            it("should rollback") {
                expect(useCase.interactor.hasSaved).to(beFalse())
                expect(useCase.interactor.hasRolledBack).to(beTrue())
            }
            
            it("should not dismiss button") {
                expect(useCase.ui.isButtonPresented).to(beTrue())
            }
            
            it("should dismiss direction zones control") {
                expect(useCase.ui.isDirectionZonesControlPresented).to(beFalse())
            }
            
            it("should not present symbol presets popover") {
                expect(useCase.ui.isSymbolPresetsPopoverPresented).to(beFalse())
            }
            
//            it("should layout ui") {
//
//            }
        }
    }
}
