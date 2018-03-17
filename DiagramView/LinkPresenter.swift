//
//  LinkPresenter.swift
//  FlowCharts
//
//  Created by alex on 04/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry

public extension NSNotification.Name {
    static let linkPresenterDidLayout = NSNotification.Name("linkPresenterDidLayout")
}

public class LinkPresenter: FreePresenter, LinkDataSourceDelegate {
    
    let dataSource: LinkDataSource
    private let linksView: UIView
    private let pointersView: UIView
    private unowned let coordinatesConverter: DiagramCoordinatesConverter
    
    init(dataSource: LinkDataSource,
         linksView: UIView,
         pointersView: UIView,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.dataSource = dataSource
        self.linksView = linksView
        self.pointersView = pointersView
        self.coordinatesConverter = coordinatesConverter
    }
    
    var contentScaleFactor: CGFloat = 1.0 {
        didSet {
            linkView.contentScaleFactor = contentScaleFactor
            originView.contentScaleFactor = contentScaleFactor
            endingView.contentScaleFactor = contentScaleFactor
        }
    }
    
    // MARK: - Presented items 
    
    public lazy var linkView: LinkView = {
        let view = LinkView(frame: .zero)
        view.contentScaleFactor = self.contentScaleFactor
        return view
    }()
    
    private lazy var originView: PointerView = {
        let view = PointerView(frame: .zero)
        view.contentScaleFactor = self.contentScaleFactor
        return view
    }()
    
    private lazy var endingView: PointerView = {
        let view = PointerView(frame: .zero)
        view.contentScaleFactor = self.contentScaleFactor
        return view
    }()
    
    // MARK: - Lifecycle
    
    public override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        
        transition.add(beginning: {
            self.linksView.addSubview(self.linkView)
            self.updateArrow()
            self.updateDashPattern()
            self.updateColors()
            self.dataSource.delegate = self
            self.linkView.alpha = 0.0
            self.originView.alpha = 0.0
            self.endingView.alpha = 0.0
        }, animation: {
            self.linkView.alpha = 1.0
            self.originView.alpha = 1.0
            self.endingView.alpha = 1.0
        })
    }
    
    public override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        
        transition.add(beginning: {
            self.dataSource.delegate = nil
        }, animation: {
            self.linkView.alpha = 0.0
            self.originView.alpha = 0.0
            self.endingView.alpha = 0.0
        }, completion: {
            self.linkView.removeFromSuperview()
            self.originView.removeFromSuperview()
            self.endingView.removeFromSuperview()
        })
    }
    
    // MARK: - Link data source delegate
    
    public func linkWillChangeArrow(_ dataSource: LinkDataSource, withIn transition: Transition) {
        transition.addBeginning {
            self.updateArrow()
        }
    }
    
    public func linkWillChangeStrokeColor(_ dataSource: LinkDataSource, withIn transition: Transition) {
        transition.addAnimation {
            self.linkView.strokeColor = self.dataSource.strokeColor
            self.originView.strokeColor = self.dataSource.strokeColor
            self.endingView.strokeColor = self.dataSource.strokeColor
        }
    }
    
    public func linkWillChangeOriginFillColor(_ dataSource: LinkDataSource, withIn transition: Transition) {
        transition.addAnimation {
            self.originView.fillColor = self.dataSource.originFillColor
        }
    }
    
    public func linkWillChangeEndingFillColor(_ dataSource: LinkDataSource, withIn transition: Transition) {
        transition.addAnimation {
            self.endingView.fillColor = self.dataSource.endingFillColor
        }
    }
    
    public func linkWillChangeLineDashPattern(_ dataSource: LinkDataSource, withIn transition: Transition) {
        transition.addBeginning {
            self.updateDashPattern()
        }
    }
    
    public func linkWillChangeOriginDashPattern(_ dataSource: LinkDataSource, withIn transition: Transition) {
        transition.addBeginning {
            self.updateDashPattern()
        }
    }
    
    public func linkWillChangeEndingDashPattern(_ dataSource: LinkDataSource, withIn transition: Transition) {
        transition.addBeginning {
            self.updateDashPattern()
        }
    }
    
    // MARK: - Presentation
    
    private func updateArrow() {
        
        let arrow = dataSource.arrow
        
        let linkPath = arrow.linePath

        let linkPathInDiagramView = coordinatesConverter.viewPath(forDiagramPath: linkPath, in: linksView)
        let linkFrame = linkPathInDiagramView.boundingBoxOfPath
        linkView.frame = linkFrame
        
        let linkPathInLinkView = CGMutablePath()
        linkPathInLinkView.addPath(
            linkPathInDiagramView,
            transform: CGAffineTransform(translationX: -linkFrame.minX, y: -linkFrame.minY))
        linkView.path = linkPathInLinkView
        
        linkView.text = dataSource.arrow.text
        if dataSource.arrow.textRect != nil {
            linkView.textFrame = coordinatesConverter.viewRect(for: dataSource.arrow.textRect!, in: linkView)
        } else {
            linkView.textFrame = .zero
        }
        
        if dataSource.arrow.pointer1Type is EllipsisPointerType && originView.superview != pointersView {
            originView.removeFromSuperview()
            pointersView.addSubview(originView)
        } else if !(dataSource.arrow.pointer1Type is EllipsisPointerType) && originView.superview != linksView {
            originView.removeFromSuperview()
            linksView.addSubview(originView)
        }
        
        let originPath = arrow.pointer1Path
        
        let originPathInDiagramView = coordinatesConverter.viewPath(forDiagramPath: originPath, in: pointersView)
        let originFrame = originPathInDiagramView.boundingBoxOfPath
        
        let originPathInPointerView = CGMutablePath()
        originPathInPointerView.addPath(
            originPathInDiagramView,
            transform: CGAffineTransform(translationX: -originFrame.minX, y: -originFrame.minY))
        
        originView.frame = originFrame
        originView.path = originPathInPointerView
        
        if dataSource.arrow.pointer2Type is EllipsisPointerType && endingView.superview != pointersView {
            endingView.removeFromSuperview()
            pointersView.addSubview(endingView)
        } else if !(dataSource.arrow.pointer2Type is EllipsisPointerType) && endingView.superview != linksView {
            endingView.removeFromSuperview()
            linksView.addSubview(endingView)
        }
        
        let endingPath = arrow.pointer2Path
        
        let endingPathInDiagramView = coordinatesConverter.viewPath(forDiagramPath: endingPath, in: pointersView)
        let endingFrame = endingPathInDiagramView.boundingBoxOfPath
        
        let endingPathPathInPointerView = CGMutablePath()
        endingPathPathInPointerView.addPath(
            endingPathInDiagramView,
            transform: CGAffineTransform(translationX: -endingFrame.minX, y: -endingFrame.minY))
        
        endingView.frame = endingFrame
        endingView.path = endingPathPathInPointerView
        
        NotificationCenter.default.post(name: .linkPresenterDidLayout, object: self)
    }
    
    private func updateDashPattern() {
        linkView.lineDashPattern = dataSource.lineDashPattern.map { NSNumber(value: $0) }
        originView.lineDashPattern = dataSource.originDashPattern.map { NSNumber(value: $0) }
        endingView.lineDashPattern = dataSource.endingDashPattern.map { NSNumber(value: $0) }
    }
    
    private func updateColors() {
        linkView.strokeColor = dataSource.strokeColor
        originView.strokeColor = dataSource.strokeColor
        endingView.strokeColor = dataSource.strokeColor
        originView.fillColor = dataSource.originFillColor
        endingView.fillColor = dataSource.endingFillColor
    }
}
