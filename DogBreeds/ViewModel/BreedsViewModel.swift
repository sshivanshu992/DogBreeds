//
//  BreedsViewModel.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import Foundation

/// `BreedsViewModel` handles fetching and managing dog breed data, notifying the view controller when the data updates.
class BreedsViewModel {
    private(set) var breeds: [String: [String]] = [:]
    /// Sorted list of breed names.
    private(set) var breedList: [String] = []
    /// Closure called when breed data is updated.
    var didUpdateBreeds: (() -> Void)?
    var model: DogBreedsAllList = DogBreedsAllList()

    /// Fetches the list of dog breeds from the API and updates properties. Triggers `didUpdateBreeds` on success.
    func fetchBreeds() {
        Loader.shared.startLoading()

        fetchData(endpoint: "/breeds/list/all", type: DogBreedsAllList.self) { [weak self] result in
            Loader.shared.stopLoading()
            
            guard let self = self else { return }

            switch result {
                case .success(let responseData):
                    self.model = responseData
                    if let breeds = responseData.breedList {
                        self.breeds = breeds
                        self.breedList = breeds.keys.sorted()
                        self.didUpdateBreeds?()
                    }
                case .failure(let error):
                    AlertController.alert(message: error.localizedDescription)
                    print(error)
            }
        }
    }
}
