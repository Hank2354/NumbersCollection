//
//  NumGeneratorInterface.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import Foundation

protocol NumGeneratorInterface: AnyObject {
    
    var packageSize: Int { get set }
    
    func getPrimeNumbers(from initValue: Int) -> [Int]
    
    func getFibanacciNumbers(from initPair: (Int, Int)) -> [Int]
}

