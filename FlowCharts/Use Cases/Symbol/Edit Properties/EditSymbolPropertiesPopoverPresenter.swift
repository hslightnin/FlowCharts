//
//  EditSymbolPropertiesPopoverPresenter.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 06/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

//protocol EditSymbolPropertiesPopoverPresenterInteractionsDelegate: class {
//    func editSymbolPropertiesPopoverPresenter(_ presenter: EditSymbolPropertiesPopoverPresenter, didSelectShapePreset preset: ShapePreset)
//    func editSymbolPropertiesPopoverPresenter(_ presenter: EditSymbolPropertiesPopoverPresenter, didSelectColor color: UIColor)
//    func editSymbolPropertiesPopoverPresenterDidCancel(_ presenter: EditSymbolPropertiesPopoverPresenter)
//}

class EditSymbolPropertiesPopoverPresenter: PopoverPresenter,
                                            ShapeTypesViewControllerDelegate,
                                            ShapeColorsViewControllerDelegate {
    
//    weak var interactionsDelegate: EditSymbolPropertiesPopoverPresenterInteractionsDelegate?
    
    var onSelectedShapePresetChanged: ((ShapePreset) -> Void)?
    var onSelectedColorChanged: ((UIColor) -> Void)?
    
    // MARK: - Properties
    
    var shapePresets = [ShapePreset]() {
        didSet {
            shapeTypesViewController.shapePresets = shapePresets
        }
    }
    
    var colors = [UIColor]() {
        didSet {
            shapeColorsViewController.colors = colors
        }
    }
    
    var selectedShapePreset: ShapePreset? {
        get {
            return shapeTypesViewController.selectedPreset
        }
        set {
            shapeTypesViewController.selectedPreset = newValue
        }
    }
    
    var selectedColor: UIColor? {
        get {
            return shapeColorsViewController.selectedColor
        }
        set {
            shapeColorsViewController.selectedColor = newValue
        }
    }
    
    // MARK: - Presented items
    
    private lazy var shapeTypesViewController: ShapeTypesViewController = {
        let shapeTypesStoryboard = UIStoryboard(name: "ShapeTypes", bundle: nil)
        let shapeTypesViewController = shapeTypesStoryboard.instantiateInitialViewController() as! ShapeTypesViewController
        shapeTypesViewController.shapePresets = self.shapePresets
        shapeTypesViewController.delegate = self
        return shapeTypesViewController
    }()
    
    private lazy var shapeColorsViewController: ShapeColorsViewController = {
        let shapeColorsStoryboard = UIStoryboard(name: "ShapeColors", bundle: nil)
        let shapeColorsViewController = shapeColorsStoryboard.instantiateInitialViewController() as! ShapeColorsViewController
        shapeColorsViewController.colors = self.colors
        shapeColorsViewController.delegate = self
        return shapeColorsViewController
    }()
    
    private lazy var navigationController: UINavigationController = {
        let switchViewController = SwitchViewController(viewControllers: [self.shapeTypesViewController, self.shapeColorsViewController])
        let navigationController = UINavigationController(rootViewController: switchViewController)
        return navigationController
    }()
    
    override func loadContentViewController() -> UIViewController {
        return navigationController
    }
    
    // MARK: - Interactions
    
    // MARK: ShapeTypesViewControllerDelegate
    
    func shapeTypesViewController(_ controller: ShapeTypesViewController, didSelectShapePreset preset: ShapePreset) {
        shapeColorsViewController.shapePreset = preset
        onSelectedShapePresetChanged?(preset)
//        interactionsDelegate?.editSymbolPropertiesPopoverPresenter(self, didSelectShapePreset: preset)
    }
    
    // MARK: ShapeColorsViewControllerDelegate
    
    func shapeColorsViewController(_ controller: ShapeColorsViewController, didSelectColor color: UIColor) {
//        interactionsDelegate?.editSymbolPropertiesPopoverPresenter(self, didSelectColor: color)
        onSelectedColorChanged?(color)
    }
    
    // MARL: UIPopoverPresentationControllerDelegate
    
//    override func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
//        interactionsDelegate?.editSymbolPropertiesPopoverPresenterDidCancel(self)
//        return false
//    }
}

