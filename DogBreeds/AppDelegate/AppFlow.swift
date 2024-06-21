//
//  AppFlow.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import UIKit

final class AppFlow {
    static let shared = AppFlow()
    private init() {}
    private let sceneDelegate = Utility.shared.getSceneDelegateReference
    
    func root() {
        let navigationController = UINavigationController(rootViewController: DogBreedsViewController())
        let favoritesButton = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(showFavorites))
        navigationController.navigationBar.topItem?.rightBarButtonItem = favoritesButton
        self.sceneDelegate?.window?.rootViewController = navigationController
        self.sceneDelegate?.window?.makeKeyAndVisible()
    }

    @objc private func showFavorites() {
        let favouriteVC = FavouriteImagesViewController()
        if let navigationController = self.sceneDelegate?.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(favouriteVC, animated: true)
        }
    }
}
