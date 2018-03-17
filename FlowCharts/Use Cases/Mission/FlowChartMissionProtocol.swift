//
//  MissionContextProtocol.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 05/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry
import PresenterKit

protocol BuildSymbolUseCaseProtocol: class {
    var presenter: FlexiblePresenter & UseCasePresenterProtocol { get }
    var onEnded: ((FlowChartSymbol) -> Void)? { get set }
    var onCancelled: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}

protocol FlowChartMissionProtocol: class {
    func createBuildSybolUseCase(location: Point) -> BuildSymbolUseCaseProtocol
    func createMission(for link: FlowChartLink) -> LinkMissionProtocol
    func createMission(for symbol: FlowChartSymbol) -> SymbolMissionProtocol
}
