//
//  FavouriteImagesViewModel.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import Foundation

/// `FavouriteImagesViewModel` manages favorite images, including fetching, filtering, and removing liked images.
class FavouriteImagesViewModel {
    private let likeImageRepository = LikeImageRepository()
    /// Array of all favorite images.
    private(set) var favoriteImages: [LikedImageModel] = []
    /// Array of filtered favorite images.
    private(set) var filteredImages: [LikedImageModel] = []
    /// List of unique breeds from the favorite images.
    private(set) var breeds: [String] = []
    
    var didUpdateImages: (() -> Void)?
    var didUpdateBreeds: (() -> Void)? // not in use
    
    /// Loads favorite images from the repository, updates properties, and triggers update closures.
    func loadFavoriteImages() {
        likeImageRepository.getLikedImages { [weak self] likedImages in
            guard let self = self else { return }
            self.favoriteImages = likedImages
            self.filteredImages = likedImages
            self.breeds = Array(Set(likedImages.compactMap { $0.breed })).sorted()
            self.didUpdateImages?()
            self.didUpdateBreeds?()
        }
    }
    
    /// Filters favorite images by the specified breed.
    /// - Parameter breed: The breed to filter images by (optional).
    func filterImages(by breed: String?) {
        if let breed = breed {
            self.filteredImages = self.favoriteImages.filter { $0.breed == breed }
        } else {
            self.filteredImages = self.favoriteImages
        }
        self.didUpdateImages?()
    }

    /// Removes a liked image at the specified index from the filtered images.
    /// - Parameter index: The index of the image to remove.
    func removeImage(at index: Int) {
        let likedImage = filteredImages[index]
        likeImageRepository.removeLikedImage(imageURL: likedImage.imageURL ?? "") {
            self.loadFavoriteImages()
        }
    }
}
