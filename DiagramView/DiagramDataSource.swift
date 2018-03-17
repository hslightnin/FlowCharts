//
//  DiagramViewModel.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 09/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry

public protocol DiagramDataSourceDelegate: class {
    func diagramWillChangeSize(_ diagramDataSource: DiagramDataSource, withIn trasition: Transition)
    func diagram(_ dataSource: DiagramDataSource, willAddSymbols symbolDataSources: [SymbolDataSource], withIn transition: Transition)
    func diagram(_ dataSource: DiagramDataSource, willRemoveSymbols symbolDataSources: [SymbolDataSource], withIn transition: Transition)
    func diagram(_ dataSource: DiagramDataSource, willAddLinks linkDataSources: [LinkDataSource], withIn transition: Transition)
    func diagram(_ dataSource: DiagramDataSource, willRemoveLinks linkDataSources: [LinkDataSource], withIn transition: Transition)
}

public protocol DiagramDataSource: DiagramItemDataSource {
    
    weak var delegate: DiagramDataSourceDelegate? { get set }
    
    var size: Size { get }
    var symbolDataSources: [SymbolDataSource] { get }
    var linkDataSources: [LinkDataSource] { get }
}
