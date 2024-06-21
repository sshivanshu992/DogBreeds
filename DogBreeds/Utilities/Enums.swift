//
//  Enums.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import Foundation

/// Define an enum for error domains
enum ErrorDomain: String {
    case network = "com.myapp.network"
    case data = "com.myapp.data"
    
    var description: String {
        return self.rawValue
    }
}
