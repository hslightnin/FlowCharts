//
//  FlowChartSymbol+CoreDataProperties.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 11/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//
//

import UIKit
import CoreData


extension FlowChartSymbol {

    @nonobjc class func fetchRequest() -> NSFetchRequest<FlowChartSymbol> {
        return NSFetchRequest<FlowChartSymbol>(entityName: "Symbol")
    }

    @NSManaged var color: UIColor
    @NSManaged var height: Double
    @NSManaged var shapePresetId: Int32
    @NSManaged var string: String?
    @NSManaged var width: Double
    @NSManaged var x: Double
    @NSManaged var y: Double
    @NSManaged var anchors: Set<FlowChartSymbolAnchor>
    @NSManaged var diagram: FlowChartDiagram!

}

// MARK: Generated accessors for anchors
extension FlowChartSymbol {

    @objc(addAnchorsObject:)
    @NSManaged func addToAnchors(_ value: FlowChartSymbolAnchor)

    @objc(removeAnchorsObject:)
    @NSManaged func removeFromAnchors(_ value: FlowChartSymbolAnchor)

    @objc(addAnchors:)
    @NSManaged func addToAnchors(_ values: NSSet)

    @objc(removeAnchors:)
    @NSManaged func removeFromAnchors(_ values: NSSet)

}
