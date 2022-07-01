//
//  NumbersCollection.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import Foundation
import UIKit

protocol NumbersCollectionDelegate: AnyObject {
    func didDisplayPaginatorDetectorCell(_ type: CollectionType)
}

protocol NumbersCollectionProtocol: UICollectionView {
    var controlDelegate: NumbersCollectionDelegate? { get set }
    var collectionType: CollectionType { get }
    
    func showSelf(_ isShow: Bool, animated: Bool, handler: ((Bool) -> ())?)
    
    func insertNewNumbers(_ numbers: [Int])
}

final class NumbersCollection: UICollectionView {
    // MARK: - Properties
    weak var controlDelegate: NumbersCollectionDelegate?
    internal var collectionType: CollectionType
    private var numbers = [Int]()
    
    // MARK: - Init
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, type: CollectionType) {
        self.collectionType = type
        super.init(frame: frame, collectionViewLayout: layout)
        configureCollection()
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
    
    func insertNewNumbers(_ numbers: [Int]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.numbers.append(contentsOf: numbers)
            self.reloadData()
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
        if indexPath.row + 1 == numbers.count - Constants.paginationDetectorPreset {
            controlDelegate?.didDisplayPaginatorDetectorCell(collectionType)
        }
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
        
        static var paginationDetectorPreset: Int { 12 }
        static var defaultAnimationDuration: CGFloat { 0.2 }
    }
}
