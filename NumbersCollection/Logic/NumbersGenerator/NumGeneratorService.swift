//
//  NumGeneratorService.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import Foundation

final class NumGeneratorService {
    // MARK: - Singleton
    static let shared: NumGeneratorInterface = NumGeneratorService()
    private init() {}
}

extension NumGeneratorService: NumGeneratorInterface {
    
}
