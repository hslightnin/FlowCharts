//
//  BuildSymbolPropertiesPopoverPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 26/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

class BuildSymbolPropertiesPopoverPresenter: PopoverPresenter,
                                             ShapeTypesViewControllerDelegate,
                                             ShapeColorsViewControllerDelegate {
    
    var onPresetsSelected: ((ShapePreset, UIColor) -> Void)?
//    var onPresetsSelectionCancelled: (() -> Void)?
    
    // MARK: - Properties
    
    var selectedShapePreset: ShapePreset? {
        return shapeTypesViewController.selectedPreset
    }
    
    var selectedColor: UIColor? {
        return shapeColorsViewController.selectedColor
    }
    
    // MARK: - Presenter items
    
    override func loadContentViewController() -> UIViewController {
        return navigaionController
    }
    
    private lazy var navigaionController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: self.shapeTypesViewController)
        navigationController.modalPresentationStyle = .popover
        return navigationController
    }()
    
    private lazy var shapeTypesViewController: ShapeTypesViewController = {
        let shapeTypesStoryboard = UIStoryboard(name: "ShapeTypes", bundle: nil)
        let shapeTypesViewController = shapeTypesStoryboard.instantiateInitialViewController() as! ShapeTypesViewController
        shapeTypesViewController.delegate = self
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        shapeTypesViewController.navigationItem.backBarButtonItem = backItem
        shapeTypesViewController.shapePresets = ShapePreset.all
        return shapeTypesViewController
    }()
    
    private lazy var shapeColorsViewController: ShapeColorsViewController = {
        let shapeColorsStoryboard = UIStoryboard(name: "ShapeColors", bundle: nil)
        let shapeColorsViewController = shapeColorsStoryboard.instantiateInitialViewController() as! ShapeColorsViewController
        shapeColorsViewController.delegate = self
        shapeColorsViewController.colors = SymbolColorPresets.all
        return shapeColorsViewController
    }()
    
    // MARK: - Interactions
    
    func shapeTypesViewController(_ controller: ShapeTypesViewController, didSelectShapePreset preset: ShapePreset) {
        shapeColorsViewController.shapePreset = preset
        navigaionController.pushViewController(shapeColorsViewController, animated: true)
    }
    
    func shapeColorsViewController(_ controller: ShapeColorsViewController, didSelectColor color: UIColor) {
        onPresetsSelected?(controller.shapePreset, color)
    }
}
