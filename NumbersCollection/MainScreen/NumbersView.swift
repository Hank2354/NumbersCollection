//
//  NumbersView.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import UIKit

protocol NumbersViewDelegate: AnyObject {
    func didSelectSegment(_ segment: Any)
}

protocol NumbersViewProtocol: UIView {
    var delegate: NumbersViewDelegate? { get set }
    
    func showPrimeCollection()
    func showFibanacciCollection()
}

final class NumbersView: UIView {

    // MARK: - Properties
    weak var delegate: NumbersViewDelegate?
    
    private let segmentItems: [CollectionType]
    
    // MARK: - Views
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segmentItems.map { $0.rawValue })
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(handleSegment(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var numCollection: NumbersCollection = {
        let collection = NumbersCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var fibCollection: NumbersCollection = {
        let collection = NumbersCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
}

extension NumbersView: NumbersCollectionDelegate {
    func didDisplayPaginatorDetectorCell() {
        print("Detector displayed")
    }
}

// MARK: - Constants
extension NumbersView {
    struct Constants {
        static var backgroundColor: UIColor { .lightGray }
        static var defaultAnimationDuration: CGFloat { 0.3 }
    }
}


