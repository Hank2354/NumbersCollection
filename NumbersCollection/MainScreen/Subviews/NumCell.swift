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
    @IBOutlet weak var numLabel: UILabel!
    
    // MARK: - Open methods
    func setNum(_ value: Int) {
        numLabel.text = "\(value)"
    }
}
