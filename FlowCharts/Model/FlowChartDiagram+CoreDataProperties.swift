//
//  FlowChartDiagram+CoreDataProperties.swift
//  FlowCharts
//
//  Created by alex on 04/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreData


extension FlowChartDiagram {

    @nonobjc class func fetchRequest() -> NSFetchRequest<FlowChartDiagram> {
        return NSFetchRequest<FlowChartDiagram>(entityName: "Diagram");
    }

    @NSManaged var height: Double
    @NSManaged var width: Double
    @NSManaged var flowChartSymbols: NSOrderedSet!
    @NSManaged var flowChartLinks: NSOrderedSet!
}

// MARK: Generated accessors for flowChartSymbols
extension FlowChartDiagram {

    @objc(insertObject:inFlowChartSymbolsAtIndex:)
    @NSManaged func insertIntoFlowChartSymbols(_ value: FlowChartSymbol, at idx: Int)

    @objc(removeObjectFromFlowChartSymbolsAtIndex:)
    @NSManaged func removeFromFlowChartSymbols(at idx: Int)

    @objc(insertFlowChartSymbols:atIndexes:)
    @NSManaged func insertIntoFlowChartSymbols(_ values: [FlowChartSymbol], at indexes: NSIndexSet)

    @objc(removeFlowChartSymbolsAtIndexes:)
    @NSManaged func removeFromFlowChartSymbols(at indexes: NSIndexSet)

    @objc(replaceObjectInFlowChartSymbolsAtIndex:withObject:)
    @NSManaged func replaceFlowChartSymbols(at idx: Int, with value: FlowChartSymbol)

    @objc(replaceFlowChartSymbolsAtIndexes:withFlowChartSymbols:)
    @NSManaged func replaceFlowChartSymbols(at indexes: NSIndexSet, with values: [FlowChartSymbol])

    @objc(addFlowChartSymbolsObject:)
    @NSManaged func addToFlowChartSymbols(_ value: FlowChartSymbol)

    @objc(removeFlowChartSymbolsObject:)
    @NSManaged func removeFromFlowChartSymbols(_ value: FlowChartSymbol)

    @objc(addFlowChartSymbols:)
    @NSManaged func addToFlowChartSymbols(_ values: NSOrderedSet)

    @objc(removeFlowChartSymbols:)
    @NSManaged func removeFromFlowChartSymbols(_ values: NSOrderedSet)

}

// MARK: Generated accessors for flowChartLinks
extension FlowChartDiagram {

    @objc(insertObject:inFlowChartLinksAtIndex:)
    @NSManaged func insertIntoFlowChartLinks(_ value: FlowChartLink, at idx: Int)

    @objc(removeObjectFromFlowChartLinksAtIndex:)
    @NSManaged func removeFromFlowChartLinks(at idx: Int)

    @objc(insertFlowChartLinks:atIndexes:)
    @NSManaged func insertIntoFlowChartLinks(_ values: [FlowChartLink], at indexes: NSIndexSet)

    @objc(removeFlowChartLinksAtIndexes:)
    @NSManaged func removeFromFlowChartLinks(at indexes: NSIndexSet)

    @objc(replaceObjectInFlowChartLinksAtIndex:withObject:)
    @NSManaged func replaceFlowChartLinks(at idx: Int, with value: FlowChartLink)

    @objc(replaceFlowChartLinksAtIndexes:withFlowChartLinks:)
    @NSManaged func replaceFlowChartLinks(at indexes: NSIndexSet, with values: [FlowChartLink])

    @objc(addFlowChartLinksObject:)
    @NSManaged func addToFlowChartLinks(_ value: FlowChartLink)

    @objc(removeFlowChartLinksObject:)
    @NSManaged func removeFromFlowChartLinks(_ value: FlowChartLink)

    @objc(addFlowChartLinks:)
    @NSManaged func addToFlowChartLinks(_ values: NSOrderedSet)

    @objc(removeFlowChartLinks:)
    @NSManaged func removeFromFlowChartLinks(_ values: NSOrderedSet)

}
