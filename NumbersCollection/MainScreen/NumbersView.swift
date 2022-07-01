//
//  NumbersView.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import UIKit

protocol NumbersViewProtocol: UIView {
    
}

final class NumbersView: UIView {

    // MARK: - Properties
    // MARK: - Views
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Простые", "Фибоначи"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var numCollection: NumbersCollection = {
        let collection = NumbersCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private methods
    private func setupView() {
        
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(segmentedControl)
        addSubview(numCollection)
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
    }
}

// MARK: - Protocol execution
extension NumbersView: NumbersViewProtocol {
    
}

// MARK: - Constants
extension NumbersView {
    struct Constants {
        static var backgroundColor: UIColor { .lightGray }
    }
}


