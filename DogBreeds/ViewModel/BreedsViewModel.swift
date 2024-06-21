//
//  BreedsViewModel.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import Foundation

class BreedsViewModel {
    var model: DogBreedsAllList = DogBreedsAllList()

    func fetchBreeds(completion: @escaping () -> Void) {
        Loader.shared.startLoading()
        fetchData(endpoint: "/breeds/list/all", type: DogBreedsAllList.self) { result in
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
