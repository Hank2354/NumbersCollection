//
//  NumbersView.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import UIKit

protocol NumbersViewDelegate: AnyObject {
    func didSelectSegment(_ segment: Any)
    func loadMoreNumbers(_ initValues: NumGeneratorInitValue)
}

protocol NumbersViewProtocol: UIView {
    var delegate: NumbersViewDelegate? { get set }
    
    func configure(with segmentIndex: Int)
    func showCollection(_ type: CollectionType)
    func insertNewNumbers(_ numbers: [Int], into collection: CollectionType)
}

final class NumbersView: UIView {

    // MARK: - Properties
    weak var delegate: NumbersViewDelegate?
    
    private let segmentItems: [CollectionType]
    private var primeNumbers = [Int]()
    private var fibanacciNumbers = [Int]()
    
    // MARK: - Views
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segmentItems.map { $0.rawValue })
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(handleSegment(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var primeCollection: NumbersCollection = {
        let collection = NumbersCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout(), type: .prime)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var fibCollection: NumbersCollection = {
        let collection = NumbersCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout(), type: .fibonacci)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Init
    init(frame: CGRect, segmentItems: [CollectionType]) {
        self.segmentItems = segmentItems
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupView() {
        primeCollection.controlDelegate = self
        fibCollection.controlDelegate = self
        
        fibCollection.isUserInteractionEnabled = true
        fibCollection.alpha = 0
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(segmentedControl)
        addSubview(primeCollection)
        addSubview(fibCollection)
        setupConstranits()
    }
    
    private func setupConstranits() {
        segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.segmentedHorizontalOffset).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.segmentedHorizontalOffset).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: Constants.segmentedHeight).isActive = true
        
        primeCollection.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.collectionTopInset).isActive = true
        primeCollection.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        primeCollection.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        primeCollection.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        fibCollection.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.collectionTopInset).isActive = true
        fibCollection.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        fibCollection.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        fibCollection.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: - Selectors
    @objc
    private func handleSegment(_ sender: UISegmentedControl) {
        delegate?.didSelectSegment(segmentItems[sender.selectedSegmentIndex])
    }
}

// MARK: - Protocol execution
extension NumbersView: NumbersViewProtocol {
    func configure(with segmentIndex: Int) {
        segmentedControl.selectedSegmentIndex = segmentIndex
        guard !segmentItems.isEmpty else { return }
        delegate?.didSelectSegment(segmentItems[segmentIndex])
    }
    
    func showCollection(_ type: CollectionType) {
        switch type {
        case .prime:
            fibCollection.showSelf(false, animated: true) { [weak self] state in
                guard let self = self else { return }
                self.primeCollection.showSelf(true, animated: true, handler: nil)
            }
        case .fibonacci:
            primeCollection.showSelf(false, animated: true) { [weak self] state in
                guard let self = self else { return }
                self.fibCollection.showSelf(true, animated: true, handler: nil)
            }
        }
    }
    
    func insertNewNumbers(_ numbers: [Int], into collection: CollectionType) {
        switch collection {
        case .prime: primeCollection.insertNewNumbers(numbers); primeNumbers.append(contentsOf: numbers)
        case .fibonacci: fibCollection.insertNewNumbers(numbers); fibanacciNumbers.append(contentsOf: numbers)
        }
    }
}

// MARK: - Collection delegate execution
extension NumbersView: NumbersCollectionDelegate {
    func didDisplayPaginatorDetectorCell(_ type: CollectionType) {
        switch type {
        case .prime:
            guard let lastNumber = primeNumbers.last else { return }
            delegate?.loadMoreNumbers(.prime(lastNumber))
        case .fibonacci:
            if fibanacciNumbers.count >= 2 {
                let pair = (fibanacciNumbers[fibanacciNumbers.count - 1], fibanacciNumbers[fibanacciNumbers.count - 2])
                delegate?.loadMoreNumbers(.fibonacci(pair.0, pair.1))
            }
        }
    }
    
    func didAppear(_ type: CollectionType) {
        switch type {
        case .prime:
            if primeNumbers.isEmpty { delegate?.loadMoreNumbers(.prime(0)) }
        case .fibonacci:
            if fibanacciNumbers.isEmpty { delegate?.loadMoreNumbers(.fibonacci(0, 1)) }
        }
    }
}

// MARK: - Constants
extension NumbersView {
    struct Constants {
        static var backgroundColor: UIColor { .lightGray }
        static var segmentedHeight: CGFloat { 50 }
        static var segmentedHorizontalOffset: CGFloat { 16 }
        static var collectionTopInset: CGFloat { 8 }
    }
}


