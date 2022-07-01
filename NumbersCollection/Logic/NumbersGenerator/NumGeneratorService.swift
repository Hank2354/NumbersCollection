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
    
    // MARK: - Properties
    var packageSize: Int = 30
}

extension NumGeneratorService: NumGeneratorInterface {
    
    func getPrimeNumbers(from initValue: Int) -> [Int] {
        return [1,2,3,4,5,6,7,8,9,0]
    }
    
    func getFibanacciNumbers(from initValue: Int) -> [Int] {
        return [15,24,33,42,52,61,76,83,94,09]
    }
    
    
}
