//
//  PointerPresetsViewController.swift
//  FlowCharts
//
//  Created by alex on 14/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

protocol PointerPresetsViewControllerDelegate: class {
    func pointerPresetsViewController(_ viewController: PointerPresetsViewController, didSelect preset: PointerPreset)
}

class PointerPresetsViewController: UICollectionViewController {

    weak var delegate: PointerPresetsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var pointerDirection = Vector(1, 0) {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var pointerPresets = [PointerPreset]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var selectedPointerPreset: PointerPreset? {
        didSet {

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if selectedPointerPreset != nil {
            let selectedIndexPath = IndexPath(row: pointerPresets.index { $0 === selectedPointerPreset }!, section: 0)
            collectionView!.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pointerPresets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PointerPresetCollectionViewCell
        let preset = pointerPresets[indexPath.row]
        cell.pointerDirection = pointerDirection
        cell.pointerPreset = preset
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pointerPresetsViewController(self, didSelect: pointerPresets[indexPath.row])
    }
}
