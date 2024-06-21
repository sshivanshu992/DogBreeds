//
//  Extensions.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import Foundation

extension NSError {
    /// Extension to create NSError with a custom description
    static func customError(domain: ErrorDomain, description: String) -> NSError {
        return NSError(domain: domain.description, code: 0, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
