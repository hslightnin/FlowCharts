//
//  MoveSymbolInteractorSpec.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

//import Foundation

import Quick
import Nimble
import CoreData
import DiagramGeometry
@testable import FlowCharts

class MoveSymbolInteractorSpec: QuickSpec {
    
    override func spec() {
        
        describe("MoveSymbolInteractor") {
            
            var helper: TestDiagramHelper!
            var symbol: FlowChartSymbol!
            var interactor: MoveSymbolInteractor!
            
            beforeEach {
                helper = TestDiagramHelper()
                helper.diagram.width = 1000
                helper.diagram.height = 1000
                symbol = helper.createSymbol(x: 10, y: 10, width: 100, height: 100)
                helper.save()
                interactor = MoveSymbolInteractor(symbol: symbol)
            }
            
            context("when moved") {
                
                beforeEach {
                    interactor.begin()
                }
                
                it("should move symbol") {
                    interactor.move(by: Vector(20, 30))
                    expect(symbol.x).to(equal(30))
                    expect(symbol.y).to(equal(40))
                }
                
                it("should not move symbol outside left diagram bound") {
                    interactor.move(by: Vector(-20, 0))
                    expect(symbol.x).to(equal(0))
                }
                
                it("should not move symbol outside right diagram bound") {
                    interactor.move(by: Vector(2000, 0))
                    expect(symbol.x).to(equal(900))
                }
                
                it("should not move symbol outside top diagram bound") {
                    interactor.move(by: Vector(0, -20))
                    expect(symbol.y).to(equal(0))
                }
                
                it("should not move symbol outside bottom diagram bound") {
                    interactor.move(by: Vector(0, 2000))
                    expect(symbol.y).to(equal(900))
                }
                
                it("should remember previous translations") {
                    interactor.move(by: Vector(0, 2000))
                    interactor.move(by: Vector(0, -100))
                    interactor.move(by: Vector(0, -100))
                    expect(symbol.y).to(equal(900))
                    interactor.move(by: Vector(0, -1000))
                    expect(symbol.y).to(equal(810))
                }
            }
        }
    }
}
