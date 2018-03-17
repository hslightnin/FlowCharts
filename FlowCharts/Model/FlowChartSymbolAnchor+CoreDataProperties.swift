//
//  FlowChartSymbolAnchor+CoreDataProperties.swift
//  FlowCharts
//
//  Created by alex on 11/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreData
import DiagramGeometry

extension FlowChartSymbolAnchor {

    @nonobjc class func fetchRequest() -> NSFetchRequest<FlowChartSymbolAnchor> {
        return NSFetchRequest<FlowChartSymbolAnchor>(entityName: "SymbolAnchor");
    }

    @NSManaged var x: Double
    @NSManaged var y: Double
    @NSManaged var directionValue: Int32
    @NSManaged var linkAnchors: Set<FlowChartLinkAnchor>
    @NSManaged var symbol: FlowChartSymbol!

}

// MARK: Generated accessors for linkAnchors
extension FlowChartSymbolAnchor {

    @objc(addLinkAnchorsObject:)
    @NSManaged func addToLinkAnchors(_ value: FlowChartLinkAnchor)

    @objc(removeLinkAnchorsObject:)
    @NSManaged func removeFromLinkAnchors(_ value: FlowChartLinkAnchor)

    @objc(addLinkAnchors:)
    @NSManaged func addToLinkAnchors(_ values: NSSet)

    @objc(removeLinkAnchors:)
    @NSManaged func removeFromLinkAnchors(_ values: NSSet)

}
