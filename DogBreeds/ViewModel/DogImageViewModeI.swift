//
//  DogImageViewModel.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import Foundation

class DogImageViewModel {
    var model: DogImageModel = DogImageModel()
    
    func fetchDogImages(for breed: String, subBreed: String? = nil, completion: @escaping () -> Void) {
        let breedPath = subBreed != nil ? "\(breed)/\(subBreed!)" : breed
        
        Loader.shared.startLoading()
        
        fetchData(endpoint: "/breed/\(breedPath)/images", type: DogImageModel.self) { result in
            
            Loader.shared.stopLoading()

            switch result {
                case .success(let responseData):
                    self.model = responseData
                    completion()
                case .failure(let error):
                    AlertController.alert(message: error.localizedDescription)
                    print(error)
            }
        }
    }
}
