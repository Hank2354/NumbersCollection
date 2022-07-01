//
//  NumbersView.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import UIKit

protocol NumbersViewDelegate: AnyObject {
    func didSelectSegment(_ segment: Any)
    
    func loadMorePrimeNumbers(from lastNumber: Int)
    func loadMoreFibanacciNumbers(from lastNumber: Int)
}

protocol NumbersViewProtocol: UIView {
    var delegate: NumbersViewDelegate? { get set }
    
    func showPrimeCollection()
    func showFibanacciCollection()
    
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
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(handleSegment(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var numCollection: NumbersCollection = {
        let collection = NumbersCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout(), type: .prime)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var fibCollection: NumbersCollection = {
        let collection = NumbersCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout(), type: .fibanacci)
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
        numCollection.controlDelegate = self
        fibCollection.controlDelegate = self
        fibCollection.isUserInteractionEnabled = true
        fibCollection.alpha = 0
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(segmentedControl)
        addSubview(numCollection)
        addSubview(fibCollection)
        setupConstranits()
    }
    
    private func setupConstranits() {
        segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        numCollection.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        numCollection.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        numCollection.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        numCollection.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        fibCollection.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
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
    func showPrimeCollection() {
        fibCollection.showSelf(false, animated: true) { [weak self] state in
            guard let self = self else { return }
            self.numCollection.showSelf(true, animated: true, handler: nil)
        }
    }
    
    func showFibanacciCollection() {
        numCollection.showSelf(false, animated: true) { [weak self] state in
            guard let self = self else { return }
            self.fibCollection.showSelf(true, animated: true, handler: nil)
        }
    }
    
    func insertNewNumbers(_ numbers: [Int], into collection: CollectionType) {
        switch collection {
        case .prime: numCollection.insertNewNumbers(numbers); primeNumbers.append(contentsOf: numbers)
        case .fibanacci: fibCollection.insertNewNumbers(numbers); fibanacciNumbers.append(contentsOf: numbers)
        }
    }
}

// MARK: - Collection delegate execution
extension NumbersView: NumbersCollectionDelegate {
    func didDisplayPaginatorDetectorCell(_ type: CollectionType) {
        guard let lastNumber = type == .prime ? primeNumbers.last : fibanacciNumbers.last else { return }
        switch type {
        case .prime: delegate?.loadMorePrimeNumbers(from: lastNumber)
        case .fibanacci: delegate?.loadMoreFibanacciNumbers(from: lastNumber)
        }
    }
}

// MARK: - Constants
extension NumbersView {
    struct Constants {
        static var backgroundColor: UIColor { .lightGray }
    }
}


