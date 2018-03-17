//
//  DebugMissionContext.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 05/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
import DiagramView

class DebugBuildSymbolInteractor: BuildSymbolInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateBuildSymbolErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugBuildSymbolUseCase: BuildSymbolUseCase {
    override lazy var interactor: BuildSymbolInteractor = {
        return DebugBuildSymbolInteractor(diagram: self.diagram, location: self.location)
    }()
}

class DebugFlowChartMission: FlowChartMission {
    
    override func createBuildSybolUseCase(location: Point) -> BuildSymbolUseCaseProtocol {
        return DebugBuildSymbolUseCase(
            diagram: diagram,
            location: location,
            diagramViewController: diagramViewController)
    }
    
    override func createMission(for link: FlowChartLink) -> LinkMissionProtocol {
        return DebugLinkMission(link: link, diagramViewController: diagramViewController)
    }
    
    override func createMission(for symbol: FlowChartSymbol) -> SymbolMissionProtocol {
        return DebugSymbolMission(symbol: symbol, diagramViewController: diagramViewController)
    }
}
