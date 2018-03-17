//
//  LinkUseCasesButtonsLayoutManager.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 01/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramView


class LinkButtonsLayoutManager: LinkButtonsLayoutManagerProtocol {
    
    let link: FlowChartLink
    let diagramViewController: DiagramViewController
    let interButtonSpace: CGFloat = 0
    
    init(link: FlowChartLink, diagramViewController: DiagramViewController) {
        self.link = link
        self.diagramViewController = diagramViewController
    }
    
    func deleteButtonLocation(in view: UIView) -> CGPoint {
        if let textRect = textRect(in: view) {
            return CGPoint(x: textRect.minX - buttonWidth / 2 - interButtonSpace, y: textRect.midY)
        } else {
            let center = arrowCenter(in: view)
            return CGPoint(x: center.x - buttonWidth - interButtonSpace, y: center.y)
        }
    }
    
    func editPropertiesButtonLocation(in view: UIView) -> CGPoint {
        if let textRect = textRect(in: view) {
            return CGPoint(x: textRect.maxX + 1.5 * buttonWidth + 2 * interButtonSpace, y: textRect.midY)
        } else {
            let center = arrowCenter(in: view)
            return CGPoint(x: center.x + buttonWidth + interButtonSpace, y: center.y)
        }
    }
    
    func editTextButtonLocation(in view: UIView) -> CGPoint {
        if let textRect = textRect(in: view) {
            return CGPoint(x: textRect.maxX + buttonWidth / 2 + interButtonSpace, y: textRect.midY)
        } else {
            return arrowCenter(in: view)
        }
    }
    
    func buttonLocation(for anchor: FlowChartLinkAnchor, in view: UIView) -> CGPoint {
        if anchor === link.origin {
            return originButtonLocation(in: view)
        } else if anchor === link.ending {
            return endingButtonLocation(in: view)
        } else {
            fatalError("Anchor does not belong to link")
        }
    }
    
    func originButtonLocation(in view: UIView) -> CGPoint {
        
        var editOriginButtonLocation = arrowOrigin(in: view)
        
        let editOriginButtonFrame = CGRect(center: editOriginButtonLocation, size: buttonSize)
        let deletePropertiesFrame = CGRect(center: deleteButtonLocation(in: view), size: buttonSize)
        let editPropertiesFrame = CGRect(center: editPropertiesButtonLocation(in: view), size: buttonSize)
        let centerButtonsFrame = deletePropertiesFrame.union(editPropertiesFrame)
        
        if editOriginButtonFrame.intersects(centerButtonsFrame) {
            let intersection = editOriginButtonFrame.intersection(centerButtonsFrame)
            let intersectionSize = intersection.size
            editOriginButtonLocation.x += (intersectionSize.width + interButtonSpace) * arrowOriginVector.dx
            editOriginButtonLocation.y += (intersectionSize.height + interButtonSpace) * arrowOriginVector.dy
        }
        
        return editOriginButtonLocation
    }
    
    func endingButtonLocation(in view: UIView) -> CGPoint {
        
        var editEndingButtonLocation = arrowEnding(in: view)
        
        let editEndingButtonFrame = CGRect(center: editEndingButtonLocation, size: buttonSize)
        let deletePropertiesFrame = CGRect(center: deleteButtonLocation(in: view), size: buttonSize)
        let editPropertiesFrame = CGRect(center: editPropertiesButtonLocation(in: view), size: buttonSize)
        let centerButtonsFrame = deletePropertiesFrame.union(editPropertiesFrame)
        
        if editEndingButtonFrame.intersects(centerButtonsFrame) {
            let intersection = editEndingButtonFrame.intersection(centerButtonsFrame)
            let intersectionSize = intersection.size
            editEndingButtonLocation.x += (intersectionSize.width + interButtonSpace) * arrowEndingVector.dx
            editEndingButtonLocation.y += (intersectionSize.height + interButtonSpace) * arrowEndingVector.dy
        }
        
        return editEndingButtonLocation
    }
    
    func textViewLocation(in view: UIView) -> CGPoint {
        return arrowCenter(in: view)
    }
    
    private func textRect(in view: UIView) -> CGRect? {
        if let textRectOnDiagram = link.arrow.textRect {
            return diagramViewController.viewRect(for: textRectOnDiagram, in: view)
        } else {
            return nil
        }
    }
    
    private func arrowOrigin(in view: UIView) -> CGPoint {
        return diagramViewController.viewPoint(for: link.arrow.point1, in: view)
    }
    
    private func arrowEnding(in view: UIView) -> CGPoint {
        return diagramViewController.viewPoint(for: link.arrow.point2, in: view)
    }
    
    private func arrowCenter(in view: UIView) -> CGPoint {
        return diagramViewController.viewPoint(for: link.arrow.center, in: view)
    }
    
    private var arrowOriginVector: CGVector {
        return CGVector(link.arrow.direction1.vector)
    }
    
    private var arrowEndingVector: CGVector {
        return CGVector(link.arrow.direction2.vector)
    }
    
    private var buttonSize: CGSize {
        return DiagramButton.defaultSize
    }
    
    private var buttonWidth: CGFloat {
        return buttonSize.width
    }
    
    private var buttonHeight: CGFloat {
        return buttonSize.height
    }
}

