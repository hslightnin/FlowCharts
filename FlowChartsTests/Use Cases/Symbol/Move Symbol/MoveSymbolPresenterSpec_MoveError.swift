//
//  MoveSymbolPresenterSpec_MoveError.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

import Quick
import Nimble
import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class MoveSymbolPresenterSpec_MoveError: QuickSpec {
    
    override func spec() {
        
        describe("MoveSymbolPresenter") {
            
            var useCase: TestMoveSymbolUseCase!
            
            beforeEach {
                useCase = TestMoveSymbolUseCase()
                useCase.presenter.present(with: .instant())
                useCase.ui.onPanBegan?()
                useCase.interactor.saveFails = true
            }
            
            context("when pan ended and save fails") {
                
                beforeEach {
                    useCase.ui.onPanEnded?()
                }
                
                it("should not deactivate") {
                    expect(useCase.presenter.isDeactivated).to(beFalse())
                }
                
                it("should fire onError") {
                    expect(useCase.error).notTo(beNil())
                }
                
                it("should save") {
                    expect(useCase.interactor.hasSaved).to(beTrue())
                }
                
                it("should rollback") {
                    expect(useCase.interactor.hasRolledBack).to(beTrue())
                }
                
                context("when dismissed") {
                    
                    beforeEach {
                        useCase.presenter.dismiss(with: .instant())
                    }
                    
                    it("should dismiss pan") {
                        expect(useCase.ui.isPanPresented).to(beFalse())
                    }
                }
            }
        }
    }
}



