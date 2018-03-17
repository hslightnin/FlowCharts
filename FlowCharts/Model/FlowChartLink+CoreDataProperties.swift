//
//  FlowChartLink+CoreDataProperties.swift
//  FlowCharts
//
//  Created by alex on 04/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import CoreData


extension FlowChartLink {

    @nonobjc class func fetchRequest() -> NSFetchRequest<FlowChartLink> {
        return NSFetchRequest<FlowChartLink>(entityName: "Link");
    }

    @NSManaged var lineTypePresetId: Int32
    @NSManaged var lineDashPatternPresetId: Int32
    @NSManaged var text: String?
    @NSManaged var origin: FlowChartLinkAnchor!
    @NSManaged var ending: FlowChartLinkAnchor!
    @NSManaged var diagram: FlowChartDiagram!
}
