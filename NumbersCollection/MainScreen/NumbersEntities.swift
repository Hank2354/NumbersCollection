//
//  NumbersEntities.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import Foundation

enum SegmentItem: String {
    case prime = "Простые"
    case fibonacci = "Фибоначчи"
}

enum NumGeneratorInitValue {
    case prime(Int)
    case fibonacci(Int, Int)
}
