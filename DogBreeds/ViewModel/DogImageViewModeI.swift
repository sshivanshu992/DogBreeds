//
//  DogImageViewModel.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import Foundation

/// `DogImageViewModel` handles fetching dog images, managing liked images, and notifying the view controller of updates.
class DogImageViewModel {
    private let likeImageRepository = LikeImageRepository()
    /// Array of fetched dog image URLs.
    private(set) var images: [URL] = []
    /// Set of liked image URLs.
    private(set) var likedImages: Set<URL> = []
    var didUpdateImages: (() -> Void)?
    /// Current breed and sub-breed for the fetched images.
    var breed: String?
    var subBreed: String?

    /// Fetches dog images for the specified breed and sub-breed.
    /// - Parameters:
    ///   - breed: The breed to fetch images for
    ///   - subBreed: The sub-breed to fetch images for (optional)
    func fetchDogImages(for breed: String, subBreed: String? = nil  ) {
        self.breed = breed
        self.subBreed = subBreed

        let breedPath = subBreed != nil ? "\(breed)/\(subBreed!)" : breed
        
        Loader.shared.startLoading()

        fetchData(endpoint: "/breed/\(breedPath)/images", type: DogImageModel.self) { [weak self] result in
            Loader.shared.stopLoading()

            guard let self = self else { return }

            switch result {
                case .success(let responseData):
                    self.images = responseData.urls ?? []
                    self.updateLikedImages(for: breed, subBreed: subBreed)
                case .failure(let error):
                    AlertController.alert(message: error.localizedDescription)
                    print(error)
            }
        }
    }
    
    /// Updates the liked images for the current breed and sub-breed.
    private func updateLikedImages(for breed: String, subBreed: String?) {
        likeImageRepository.getLikedImages { [weak self] likedImages in
            guard let self = self else { return }
            self.likedImages = Set(likedImages.filter { $0.breed == breed && $0.subBreed == subBreed }.compactMap { $0.imageURL?.toURL() })
            self.didUpdateImages?()
        }
    }
    
    /// Toggles the like status for the given image URL.
    /// - Parameter imageURL: The URL of the image to toggle like status for.
    func toggleLike(for imageURL: URL) {
        if likedImages.contains(imageURL) {
            likedImages.remove(imageURL)
            likeImageRepository.removeLikedImage(imageURL: imageURL.toString()) {
                print("Image unliked successfully")
            }
        } else {
            likedImages.insert(imageURL)
            likeImageRepository.saveLikedImage(breed: breed, subBreed: subBreed, imageURL: imageURL.toString()) {
                print("Image liked successfully")
            }
        }
        didUpdateImages?()
    }
}
