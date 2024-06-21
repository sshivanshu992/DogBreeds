//
//  String+Addition.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import Foundation

extension CustomStringConvertible {
    /// Returns a string representation of the type.
    static var typeString: String {
        return String(describing: self)
    }
}
extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}
