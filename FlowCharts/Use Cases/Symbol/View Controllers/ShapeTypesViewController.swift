//
//  ShapeTypesViewController.swift
//  FlowCharts
//
//  Created by alex on 02/07/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

protocol ShapeTypesViewControllerDelegate: class {
    func shapeTypesViewController(_ controller: ShapeTypesViewController, didSelectShapePreset preset: ShapePreset)
}

class ShapeTypesViewController: UICollectionViewController {

    weak var delegate: ShapeTypesViewControllerDelegate?
    
    var shapePresets = [ShapePreset]() {
        didSet {
            if self.isViewLoaded {
                self.collectionView!.reloadData()
            }
        }
    }
    
    var selectedPreset: ShapePreset? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if selectedPreset != nil {
            let selectedIndexPath = IndexPath(row: shapePresets.index { $0 === selectedPreset }!, section: 0)
            collectionView!.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shapePresets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ShapeCollectionViewCell
        cell.shapePreset = shapePresets[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPreset = shapePresets[indexPath.row]
        delegate?.shapeTypesViewController(self, didSelectShapePreset: selectedPreset!)
    }
}
