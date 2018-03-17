//
//  EditLinkPropertiesPresenterSpec_General.swift
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

class EditLinkPropertiesPresenterSpec_General: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkPropertiesPresenter") {
            
            var useCase: TestEditLinkPropertiesUseCase!
            
            beforeEach {
                useCase = TestEditLinkPropertiesUseCase()
            }
            
            it("should not create reference cycles") {
                weak var weakPresenter = useCase.presenter
                useCase.presenter = nil
                expect(weakPresenter).to(beNil())
            }
            
            context("when presented") {
                
                beforeEach {
                    useCase.presenter.present(with: .instant())
                }
                
                it("should present button") {
                    expect(useCase.ui.isButtonPresented).to(beTrue())
                }
                
                it("should not present popover") {
                    expect(useCase.ui.isPropertiesPopoverPresented).to(beFalse())
                }
                
                context("when dismissed") {
                    
                    beforeEach {
                        useCase.presenter.dismiss(with: .instant())
                    }
                    
                    it("should dismiss button") {
                        expect(useCase.ui.isButtonPresented).to(beFalse())
                    }
                    
                    it("should not present popover") {
                        expect(useCase.ui.isPropertiesPopoverPresented).to(beFalse())
                    }
                }
            }
        }
    }
}
