//
//  DeleteSymbolInteractor.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 08/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

class DeleteSymbolHelper {
    
    let symbol: FlowChartSymbol
    
    init(symbol: FlowChartSymbol) {
        self.symbol = symbol
    }
    
    func delete() {
        let context = symbol.managedObjectContext!
        for symbolAnchor in symbol.anchors {
            for linkAnchor in symbolAnchor.linkAnchors {
                context.delete(linkAnchor.link)
            }
        }
        context.delete(symbol)
    }
    
    static func delete(symbol: FlowChartSymbol) {
        DeleteSymbolHelper(symbol: symbol).delete()
    }
}
