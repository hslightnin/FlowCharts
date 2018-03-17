//
//  DiagramViewController.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 09/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

public extension NSNotification.Name {
    static let diagramViewControllerDidZoom = NSNotification.Name("diagramViewControllerDidZoom")
}

public class DiagramViewController: UIViewController, UIScrollViewDelegate, DiagramCoordinatesConverter {

    public private(set) var diagramPresenter: DiagramPresenter?
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle
    
    override public func loadView() {
        let scrollView = DiagramScrollView(frame: UIScreen.main.bounds)
        scrollView.accessibilityIdentifier = "diagram_scroll_view"
        scrollView.backgroundColor = .lightGray
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 10
        scrollView.delegate = self
        self.view = scrollView
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateContentScaleFactor()
    }
    
    private func updateContentScaleFactor() {
        diagramPresenter!.contentScaleFactor = diagramScrollView.zoomScale * UIScreen.main.scale
    }
    
    // MARK: Diagram
    
    public var diagram: DiagramDataSource? {
        
        willSet {
            diagramPresenter?.dismiss(with: .instant())
            diagramPresenter = nil
        }
        
        didSet {
            if diagram != nil {
                
                diagramPresenter = DiagramPresenter(diagram: diagram!, presentingView: view, coordinatesConverter: self)
                diagramPresenter!.present(with: .instant())
                
                let horizontalZoomScale = view.bounds.width / diagramPresenter!.diagramView.frame.width
                let verticalZoomScale = view.bounds.height / diagramPresenter!.diagramView.frame.height
                let zoomScale = max(horizontalZoomScale, verticalZoomScale) * 1.2
                diagramScrollView.setZoomScale(zoomScale, animated: false)
                diagramScrollView.setContentOffset(CGPoint(x: (diagramScrollView.contentSize.width - diagramScrollView.frame.size.width) / 2, y: 0), animated: false)
            }
        }
    }
    
    // MARK: - Views and presenters
    
    public var diagramScrollView: UIScrollView {
        return view as! UIScrollView
    }
    
    public var diagramContentView: UIView? {
        return diagramPresenter?.diagramView
    }
    
    public func presenter(for dataSource: SymbolDataSource) -> SymbolPresenter? {
        return diagramPresenter?.symbolPresenters.first { $0.dataSource === dataSource }
    }
    
    public func presenter(for dataSource: LinkDataSource) -> LinkPresenter? {
        return diagramPresenter?.linkPresenters.first { $0.dataSource === dataSource }
    }
    
    // MARK: - Coordinates converter
    
    public func diagramPoint(for viewPoint: CGPoint, in view: UIView) -> Point {
        return Point(diagramContentView!.convert(viewPoint, from: view))
    }
    
    public func viewPoint(for diagramPoint: Point, in view: UIView) -> CGPoint {
        return diagramContentView!.convert(CGPoint(diagramPoint), to: view)
    }
    
    public func viewRect(for diagramRect: Rect, in view: UIView) -> CGRect {
        return diagramPresenter!.diagramView.convert(CGRect(diagramRect), to: view)
    }
    
    public func diagramRect(for viewRect: CGRect, in view: UIView) -> Rect {
        return Rect(view.convert(viewRect, to: diagramPresenter!.diagramView))
    }
    
    public func diagramVector(for viewVector: CGVector, in view: UIView) -> Vector {
        let viewPoint1 = CGPoint.zero
        let viewPoint2 = CGPoint(x: viewVector.dx, y: viewVector.dy)
        let diagramPoint1 = Point(diagramContentView!.convert(viewPoint1, from: view))
        let diagramPoint2 = Point(diagramContentView!.convert(viewPoint2, from: view))
        return Vector(diagramPoint2.x - diagramPoint1.x, diagramPoint2.y - diagramPoint1.y)
    }
    
    public func viewVector(for diagramVector: Vector, in view: UIView) -> CGVector {
        let diagramPoint = Point(diagramVector.x, diagramVector.y)
        let viewPoint = diagramContentView!.convert(CGPoint(diagramPoint), to: view)
        return CGVector(dx: viewPoint.x, dy: viewPoint.y)
    }
    
    public func viewPath(forDiagramPath path: BezierPath, in view: UIView) -> CGPath {
        
        let testRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let transformedTestRect = diagramContentView!.convert(testRect, to: view)
        
        let translation = CGAffineTransform(translationX: transformedTestRect.minX, y: transformedTestRect.minY)
//        let scale = CGAffineTransform(scaleX: transformedTestRect.width, y: transformedTestRect.height)
        
        var transform = CGAffineTransform.identity
        transform = transform.concatenating(translation)
//        transform = transform.concatenating(scale)
        
        let viewPath = CGMutablePath()
        viewPath.addPath(CGPath(path), transform: transform)
        return viewPath
    }
    
    // MARK: - Hit test
    
    public func hitTest(_ gesture: UIGestureRecognizer) -> DiagramItemDataSource? {
        
        let hitView = view.hitTest(gesture.location(in: view), with: nil)
        
        if hitView == nil {
            return nil
        }
        
        if hitView === diagramContentView {
            return diagramPresenter!.diagram
        }
        
        if let symbolPresenter = diagramPresenter?.symbolPresenters.first(where: { $0.symbolView === hitView }) {
            return symbolPresenter.dataSource
        }
        
        if let linkPresenter = diagramPresenter?.linkPresenters.first(where: { $0.linkView === hitView }) {
            return linkPresenter.dataSource
        }
        
        return nil
    }
    
    // MARK: - Scroll view delegate
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.diagramPresenter?.diagramView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if !scrollView.isZooming {
            NotificationCenter.default.post(name: .diagramViewControllerDidZoom, object: self)
        }
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        updateContentScaleFactor()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if diagramScrollView.isZooming {
            NotificationCenter.default.post(name: .diagramViewControllerDidZoom, object: self)
        }
    }
}
