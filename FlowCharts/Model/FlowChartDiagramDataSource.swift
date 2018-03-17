//
//  FlowChartDiagramDataSource.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 15/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit
import DiagramGeometry
import DiagramView

class FlowChartDiagramDataSource: DiagramDataSource {
    
    unowned let diagram: FlowChartDiagram
    
    var delegate: DiagramDataSourceDelegate?
    
    private(set) var size: Size
    private(set) var symbolDataSources: [SymbolDataSource]
    private(set) var linkDataSources: [LinkDataSource]
    
    init(diagram: FlowChartDiagram) {
        self.diagram = diagram
        self.size = diagram.size
        self.symbolDataSources = diagram.symbolDataSources
        self.linkDataSources = diagram.flowChartLinks.array
            .map { $0 as! FlowChartLink }
            .map { $0.dataSource }
    }
    
    func updateSize(withIn transition: Transition) {
        changeSize(diagram.size, withIn: transition)
    }
    
    private func changeSize(_ size: Size, withIn transition: Transition) {
        transition.addBeginning {
            self.size = size
        }
        delegate?.diagramWillChangeSize(self, withIn: transition)
    }
    
    func addSymbolDataSources(_ dataSources: [SymbolDataSource], withIn transition: Transition) {
        transition.addBeginning {
            self.symbolDataSources.append(contentsOf: dataSources)
        }
        delegate?.diagram(self, willAddSymbols: dataSources, withIn: transition)
    }
    
    func removeSymbolDataSources(_ dataSources: [SymbolDataSource], withIn transition: Transition) {
        transition.addBeginning {
            for dataSource in dataSources {
                self.symbolDataSources.remove(at: self.symbolDataSources.index(where: { $0 === dataSource })!)
            }
        }
        delegate?.diagram(self, willRemoveSymbols: dataSources, withIn: transition)
    }
    
    func addLinkDataSources(_ dataSources: [LinkDataSource], withIn transition: Transition) {
        transition.addBeginning {
            self.linkDataSources.append(contentsOf: dataSources)
        }
        delegate?.diagram(self, willAddLinks: dataSources, withIn: transition)
    }
    
    func removeLinkDataSources(_ dataSources: [LinkDataSource], withIn transition: Transition) {
        transition.addBeginning {
            for dataSource in dataSources {
                self.linkDataSources.remove(at: self.linkDataSources.index(where: { $0 === dataSource })!)
            }
        }
        delegate?.diagram(self, willRemoveLinks: dataSources, withIn: transition)
    }
}
