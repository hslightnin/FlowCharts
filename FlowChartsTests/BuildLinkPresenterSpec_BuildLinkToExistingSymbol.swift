//
//  BuildLinkPresenterSpec_BuildLinkToExistingSymbol.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class BuildLinkPresenterSpec_BuildLinkToExistingSymbol: QuickSpec {
    
    override func spec() {
        
        describe("BuildLinkPresenter") {
            
            var useCase: TestBuildLinkUseCase!
            
            beforeEach {
                useCase = TestBuildLinkUseCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onPanBegan?()
                useCase.interactor.hasAddedLink = true
                useCase.interactor.hasAddedSymbol = false
                useCase.interactor.canSave = true
            }
            
            context("when pan ended") {
                
                beforeEach {
                    useCase.ui.onPanEnded?()
                }
                
                it("should save") {
                    expect(useCase.interactor.hasSaved).to(beTrue())
                    expect(useCase.interactor.hasRolledBack).to(beFalse())
                }
                
                it("should fire onEnded") {
                    expect(useCase.hasEnded).to(beTrue())
                    expect(useCase.error).to(beNil())
                }
                
                it("should not deactivate") {
                    expect(useCase.presenter.isActivated).to(beTrue())
                }
                
                it("should not dismiss button") {
                    expect(useCase.ui.isButtonPresented).to(beTrue())
                }
                
                it("should not dismiss direction zones control") {
                    expect(useCase.ui.isDirectionZonesControlPresented).to(beTrue())
                }
                
                it("should not present symbol presets popover") {
                    expect(useCase.ui.isSymbolPresetsPopoverPresented).to(beFalse())
                }
            }
        }
    }
}
