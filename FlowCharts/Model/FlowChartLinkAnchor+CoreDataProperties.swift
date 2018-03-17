//
//  FlowChartLinkAnchor+CoreDataProperties.swift
//  FlowCharts
//
//  Created by alex on 04/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreData

extension FlowChartLinkAnchor {

    @nonobjc class func fetchRequest() -> NSFetchRequest<FlowChartLinkAnchor> {
        return NSFetchRequest<FlowChartLinkAnchor>(entityName: "LinkAnchor");
    }

    @NSManaged var x: Double
    @NSManaged var y: Double
    @NSManaged var pointerPresetId: Int32
    @NSManaged var directionValue: Int32
    @NSManaged var endingLink: FlowChartLink?
    @NSManaged var originLink: FlowChartLink?
    @NSManaged var symbolAnchor: FlowChartSymbolAnchor!

}
