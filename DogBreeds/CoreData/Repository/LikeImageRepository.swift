//
//  LikeImageRepository.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import Foundation

class LikeImageRepository {
    func saveLikedImage(breed: String?, subBreed: String?, imageURL: String?, onSuccess: @escaping () -> Void) {
        /// Create a new background managed object context
        let context = PersistentStorage.shared.persistentContainer.newBackgroundContext()
        
        context.perform {
            do {
                /// Create a new object of `CDLikedImage`
                let cdLikedImage = CDLikedImage(context: context)
                
                /// Configure object properties
                cdLikedImage.breed = breed
                cdLikedImage.subBreed = subBreed
                cdLikedImage.imageURL = imageURL
                
                /// Save the data in background context
                try context.save()

                DispatchQueue.main.async {
                    onSuccess()
                }
            } catch let error {
                print("Error while saving background context: \(error.localizedDescription)")
            }
        }
    }
    func removeLikedImage(imageURL: String, onSuccess: @escaping () -> Void) {
        let context = PersistentStorage.shared.persistentContainer.newBackgroundContext()
        
        context.perform {
            let fetchRequest = CDLikedImage.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "imageURL == %@", imageURL)
            
            do {
                let images = try context.fetch(fetchRequest)
                for image in images {
                    context.delete(image)
                }
                try context.save()
                
                DispatchQueue.main.async {
                    onSuccess()
                }
            } catch {
                print("Failed to delete image: \(error)")
            }
        }
    }
    func getLikedImages(onSuccess: @escaping ( _ likedImages: [LikedImageModel]) -> Void) {
        let context = PersistentStorage.shared.persistentContainer.viewContext
        context.perform {
            do {
                let images = try context.fetch(CDLikedImage.fetchRequest())
                
                let likedImageModelList = images.map({$0.convertToLikedImageModel()})
                
                DispatchQueue.main.async {
                    onSuccess(likedImageModelList)
                }
            } catch {
                print("Failed to fetch images: \(error)")
            }
        }
    }
}
