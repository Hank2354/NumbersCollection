//
//  NumbersCollection.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import Foundation
import UIKit

protocol NumbersCollectionDelegate: AnyObject {
    func didDisplayPaginatorDetectorCell()
}

protocol NumbersCollectionProtocol: UICollectionView {
    var controlDelegate: NumbersCollectionDelegate? { get set }
    
    func showSelf(_ isShow: Bool, animated: Bool, handler: ((Bool) -> ())?)
}

final class NumbersCollection: UICollectionView {
    // MARK: - Properties
    weak var controlDelegate: NumbersCollectionDelegate?
    
    private var numbers = [Int]()
    
    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureCollection()
        numbers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func configureCollection() {
        backgroundColor = Constants.backgroundColor
        register(NumCell.self, forCellWithReuseIdentifier: Constants.cellID)
        dataSource = self
        delegate = self
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = Constants.minimumLineSpacing
            layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
            layout.scrollDirection = .vertical
        }
        
    }
}

// MARK: - Protocol execution
extension NumbersCollection: NumbersCollectionProtocol {
    func showSelf(_ isShow: Bool, animated: Bool, handler: ((Bool) -> ())?) {
        if animated {
            UIView.animate(withDuration: Constants.defaultAnimationDuration) { [weak self] in
                guard let self = self else { return }
                self.alpha = isShow ? 1 : 0
            } completion: { [weak self] state in
                guard let self = self else { return }
                self.isUserInteractionEnabled = isShow
                handler?(state)
            }
        }
    }
}

// MARK: - Delegate
extension NumbersCollection: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? NumCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        let isEvenIndex = indexPath.row % 2 == 0
        let isEvenRow = indexPath.row / 2 % 2 == 0
        
        if isEvenRow && isEvenIndex { cell.backgroundColor = Constants.lightCellColor }
        else if isEvenRow && !isEvenIndex { cell.backgroundColor = Constants.darkCellColor }
        else if !isEvenRow && isEvenIndex { cell.backgroundColor = Constants.darkCellColor }
        else { cell.backgroundColor = Constants.lightCellColor }
        
        cell.setNum(numbers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:100)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == numbers.count - Constants.paginationDetectorPreset { controlDelegate?.didDisplayPaginatorDetectorCell() }
    }
    
}

// MARK: - Constants
extension NumbersCollection {
    struct Constants {
        static var minimumLineSpacing: CGFloat { 0 }
        static var minimumInteritemSpacing: CGFloat { 0 }
        
        static var lightCellColor: UIColor { .lightGray }
        static var darkCellColor: UIColor { .darkGray }
        
        static var backgroundColor: UIColor { .clear }
        
        static var cellID: String { .init(describing: NumCell.self) }
        
        static var paginationDetectorPreset: Int { 6 }
        static var defaultAnimationDuration: CGFloat { 0.3 }
    }
}
