//
//  ShapeColorsViewController.swift
//  FlowCharts
//
//  Created by alex on 02/07/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

protocol ShapeColorsViewControllerDelegate: class {
    func shapeColorsViewController(_ controller: ShapeColorsViewController, didSelectColor color: UIColor)
}

class ShapeColorsViewController: UICollectionViewController {

    weak var delegate: ShapeColorsViewControllerDelegate?
    
    var shapePreset: ShapePreset = .rect {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var colors = [UIColor]() {
        didSet {
            if isViewLoaded {
                collectionView!.reloadData()
            }
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if selectedColor != nil {
            let selectedIndexPath = IndexPath(row: colors.index { $0 === selectedColor }!, section: 0)
            collectionView!.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ShapeCollectionViewCell
        cell.shapePreset = shapePreset
        cell.shapeColor = colors[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors[indexPath.row]
        delegate?.shapeColorsViewController(self, didSelectColor: selectedColor!)
    }
}
