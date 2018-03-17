//
//  BuildLinkHelper.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 12/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import CoreData

class BuildLinkHelper {
    
    @discardableResult
    static func buildLink(
        in diagram: FlowChartDiagram,
        from origin: FlowChartSymbolAnchor,
        to ending: FlowChartSymbolAnchor? = nil,
        lineTypePreset: LineTypePreset = .curved,
        lineDashPatternPreset: LineDashPatternPreset = .solid) -> FlowChartLink {
        
        guard let managedObjectContext = diagram.managedObjectContext else {
            fatalError("Can't create link in diagram without managed object context.")
        }
        
        let link = NSEntityDescription.insertNewObject(
            forEntityName: "Link",
            into: managedObjectContext) as! FlowChartLink
        
        link.lineTypePreset = .curved
        link.lineDashPatternPreset = .solid
        
        link.origin = NSEntityDescription.insertNewObject(
            forEntityName: "LinkAnchor",
            into: managedObjectContext) as! FlowChartLinkAnchor
        link.origin.x = origin.x
        link.origin.y = origin.y
        link.origin.pointerPreset = .empty
        link.origin.direction = origin.direction.opposite
        link.origin.symbolAnchor = origin
        
        link.ending = NSEntityDescription.insertNewObject(
            forEntityName: "LinkAnchor",
            into: managedObjectContext) as! FlowChartLinkAnchor
        link.ending.x = ending?.x ?? origin.x
        link.ending.y = ending?.y ?? origin.y
        link.ending.pointerPreset = .thinArrow
        link.ending.direction = ending?.direction.opposite ?? origin.direction
        link.ending.symbolAnchor = ending
        
        link.diagram = diagram
        
        return link
    }
}
