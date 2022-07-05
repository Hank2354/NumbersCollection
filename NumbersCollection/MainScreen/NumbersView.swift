//
//  NumbersView.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import UIKit

protocol NumbersViewDelegate: AnyObject {
    func didSelectSegment(_ segment: Any)
    func didDisplayDetector()
}

protocol NumbersViewProtocol: UIView {
    var delegate: NumbersViewDelegate? { get set }
    
    func configure(with segmentIndex: Int)
    func display(_ numbers: [Int], animated: Bool)
}

final class NumbersView: UIView {

    // MARK: - Properties
    weak var delegate: NumbersViewDelegate?
    private let segmentItems: [SegmentItem]
    
    // MARK: - Views
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segmentItems.map { $0.rawValue })
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(handleSegment(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var numCollection: NumbersCollection = {
        let collection = NumbersCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Init
    init(frame: CGRect, segmentItems: [SegmentItem]) {
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
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(segmentedControl)
        addSubview(numCollection)
        setupConstranits()
    }
    
    private func setupConstranits() {
        segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.segmentedHorizontalOffset).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.segmentedHorizontalOffset).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: Constants.segmentedHeight).isActive = true
        
        numCollection.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.collectionTopInset).isActive = true
        numCollection.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        numCollection.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        numCollection.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
    
    func display(_ numbers: [Int], animated: Bool) {
        if animated {
            numCollection.showSelf(false, animated: true) { [weak self] _ in
                guard let self = self else { return }
                self.numCollection.setNumbers(numbers)
                self.numCollection.showSelf(true, animated: true, handler: nil)
            }
        } else {
            numCollection.setNumbers(numbers)
        }
    }
}

// MARK: - Collection delegate execution
extension NumbersView: NumbersCollectionDelegate {
    func didDisplayPaginatorDetectorCell() {
        delegate?.didDisplayDetector()
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


