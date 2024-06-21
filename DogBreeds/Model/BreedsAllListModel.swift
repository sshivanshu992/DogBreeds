//
//  BreedsAllListModel.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import Foundation

// MARK: - Basic naming conventions

struct DogBreedsAllList: Codable {
    let message: [String: [String]]?
    let status: String?
    
    enum CodingKeys: CodingKey {
        case message
        case status
    }
    init(message: [String : [String]]? = nil, status: String? = nil) {
        self.message = message
        self.status = status
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent([String : [String]].self, forKey: .message)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
}

