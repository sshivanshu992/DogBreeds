//
//  DogImageModel.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import Foundation

struct DogImageModel: Decodable {
    let urls: [URL]?
    let status: String?

    init(message: [URL]? = nil, status: String? = nil) {
        self.urls = message
        self.status = status
    }
}
extension DogImageModel {
    enum CodingKeys: String, CodingKey {
        case breedImagesUrl = "message"
        case status
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.urls = try container.decodeIfPresent([URL].self, forKey: .breedImagesUrl)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
}
