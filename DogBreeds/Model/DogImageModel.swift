//
//  DogImageModel.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import Foundation

struct DogImageModel: Decodable {
    let message: [URL]?
    let status: String?
    init(message: [URL]? = nil, status: String? = nil) {
        self.message = message
        self.status = status
    }
}
extension DogImageModel {
    enum CodingKeys: CodingKey {
        case message
        case status
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent([URL].self, forKey: .message)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
}
