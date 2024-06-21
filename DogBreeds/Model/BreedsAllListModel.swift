//
//  BreedsAllListModel.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import Foundation

// MARK: - Basic naming conventions

struct DogBreedsAllList: Codable {
    let breedList: [String: [String]]?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case breedList = "message"
        case status
    }

    init(breedList: [String : [String]]? = nil, status: String? = nil) {
        self.breedList = breedList
        self.status = status
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.breedList = try container.decodeIfPresent([String : [String]].self, forKey: .breedList)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
}

