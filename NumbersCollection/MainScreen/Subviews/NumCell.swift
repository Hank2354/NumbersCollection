//
//  NumCell.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import Foundation
import UIKit

final class NumCell: UICollectionViewCell {
    
    // MARK: - Views
    private let numLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Open methods
    func setNum(_ value: Int) {
        numLabel.text = "\(value)"
    }
    
    // MARK: - Private methods
    private func setupCell() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        contentView.addSubview(numLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        numLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        numLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        numLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        numLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
