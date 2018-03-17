//
//  Mission.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit
import DiagramGeometry
import DiagramView

class FlowChartMission: FlowChartMissionProtocol {
    
    let diagram: FlowChartDiagram
    let diagramViewController: DiagramViewController
    
    init(diagram: FlowChartDiagram, diagramViewController: DiagramViewController) {
        self.diagram = diagram
        self.diagramViewController = diagramViewController
    }
    
    func createBuildSybolUseCase(location: Point) -> BuildSymbolUseCaseProtocol {
        return BuildSymbolUseCase(
            diagram: diagram,
            location: location,
            diagramViewController: diagramViewController)
    }
    
    func createMission(for link: FlowChartLink) -> LinkMissionProtocol {
        return LinkMission(link: link, diagramViewController: diagramViewController)
    }
    
    func createMission(for symbol: FlowChartSymbol) -> SymbolMissionProtocol {
        return SymbolMission(symbol: symbol, diagramViewController: diagramViewController)
    }
}
