//
//  CDLikeImage+Addition.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import Foundation

extension CDLikedImage {
    func convertToLikedImageModel() -> LikedImageModel {
        return LikedImageModel(breed: self.breed, subBreed: self.subBreed, imageURL: self.imageURL)
    }
}
