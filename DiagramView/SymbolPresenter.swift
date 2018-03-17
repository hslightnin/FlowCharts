//
//  SymbolPresenter.swift
//  FlowCharts
//
//  Created by alex on 11/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry

public extension NSNotification.Name {
    static let symbolPresenterDidLayout = NSNotification.Name("symbolPresenterDidLayout")
}

public class SymbolPresenter: FreePresenter, SymbolDataSourceDelegate {
    
    let dataSource: SymbolDataSource
    private let symbolsView: UIView
    private unowned let coordinatesConverter: DiagramCoordinatesConverter

    init(dataSource: SymbolDataSource,
         symbolsView: UIView,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.dataSource = dataSource
        self.symbolsView = symbolsView
        self.coordinatesConverter = coordinatesConverter
    }
    
    var contentScaleFactor: CGFloat = 1.0 {
        didSet {
            symbolView.contentScaleFactor = contentScaleFactor
        }
    }
    
    // MARK: - Presenter items
    
    public lazy var symbolView: SymbolView = {
        let symbolView = SymbolView(frame: .zero)
        symbolView.strokeColor = .black
        return symbolView
    }()
    
    // MARK: - Lifecycle
    
    public override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        
        transition.add(beginning: {
            self.symbolsView.addSubview(self.symbolView)
            self.updatePath()
            self.symbolView.fillColor = self.dataSource.fillColor
            self.symbolView.strokeColor = self.dataSource.strokeColor
            self.dataSource.delegate = self
            self.symbolView.alpha = 0.0
        }, animation: {
            self.symbolView.alpha = 1.0
        })
    }
    
    public override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        
        transition.add(beginning: {
            self.dataSource.delegate = nil
        }, animation: {
            self.symbolView.alpha = 0.0
        }, completion: { finished in
            self.symbolView.removeFromSuperview()
        })
    }
    
    // MARK: - Symbol data source delegate
    
    public func symbolWillChangeShape(_ dataSource: SymbolDataSource, withIn transition: Transition) {
        transition.addBeginning {
            self.updatePath()
        }
    }
    
    public func symbolWillChangeStrokeColor(_ dataSource: SymbolDataSource, withIn transition: Transition) {
        transition.addAnimation {
            self.symbolView.strokeColor = dataSource.strokeColor
        }
    }
    
    public func symbolWillChangeFillColor(_ dataSource: SymbolDataSource, withIn transition: Transition) {
        transition.addAnimation {
            self.symbolView.fillColor = dataSource.fillColor
        }
    }
    
    // MARK: - Presentation
    
    private func updatePath() {
        
        let shape = dataSource.shape
        
        symbolView.frame = coordinatesConverter.viewRect(for: shape.frame, in: symbolsView)
        NotificationCenter.default.post(name: .symbolPresenterDidLayout, object: self)
        
        let pathOnDiagram = shape.path
        let pathInDiagramView = coordinatesConverter.viewPath(forDiagramPath: pathOnDiagram, in: symbolView.superview!)
        let pathInSymbolView = CGMutablePath()
        let frame = symbolView.frame
        pathInSymbolView.addPath(pathInDiagramView, transform: CGAffineTransform(translationX: -frame.minX, y: -frame.minY))
        symbolView.path = pathInSymbolView
        
        if let textPathOnDiagram = shape.textPath {
            let textPathInDiagramView = coordinatesConverter.viewPath(forDiagramPath: textPathOnDiagram, in: symbolView.superview!)
            let textPathInSymbolView = CGMutablePath()
            textPathInSymbolView.addPath(textPathInDiagramView, transform: CGAffineTransform(translationX: -frame.minX, y: -frame.minY))
            symbolView.text = shape.visibleText
            symbolView.textPath = textPathInSymbolView
        } else {
            symbolView.text = nil
            symbolView.textPath = nil
        }
    }
}
