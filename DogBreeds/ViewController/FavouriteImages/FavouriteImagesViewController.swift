//
//  FavouriteImagesViewController.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import UIKit

class FavouriteImagesViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var noFavouritesStackView: UIStackView!
    
    private var favoriteImages: [LikedImageModel] = [] {
        didSet {
            if self.favoriteImages.count == 0 {
                self.noFavouritesStackView.isHidden = false
            } else {
                self.noFavouritesStackView.isHidden = true
            }
        }
    }
    private var filteredImages: [LikedImageModel] = []
    private var breeds: [String] = []

    private let likeImageRepository = LikeImageRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfiguration()
    }
    private func initialConfiguration() {
        title = Constants.ScreenTitle.kFavouritePictures
        self.registerCell()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.loadFavoriteImages()
        self.setupFilterButton()
    }
    private func registerCell() {
        self.collectionView.register(DogBreedCollectionViewCell.cellNib, forCellWithReuseIdentifier: DogBreedCollectionViewCell.typeString)
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    private func loadFavoriteImages() {
        self.likeImageRepository.getLikedImages { [weak self] likedImages in

            guard let self else { return }

            self.favoriteImages = likedImages
            self.filteredImages = self.favoriteImages
            self.breeds = Array(Set(self.favoriteImages.compactMap { $0.breed })).sorted()
            
            self.reloadCollectionView()
        }
    }
    private func setupFilterButton() {
        let filterButton = UIBarButtonItem(title: Constants.kFilter, style: .plain, target: self, action: #selector(filterTapped))
        navigationItem.rightBarButtonItem = filterButton
    }
    @objc private func filterTapped() {
        let alert = UIAlertController(title: Constants.kFilterBy, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.kAll, style: .default) { _ in
            self.filteredImages = self.favoriteImages
            self.reloadCollectionView()
        })
        for breed in breeds {
            alert.addAction(UIAlertAction(title: breed.capitalized, style: .default) { _ in
                self.filteredImages = self.favoriteImages.filter { $0.breed == breed }
                self.reloadCollectionView()
            })
        }
        alert.addAction(UIAlertAction(title: Constants.kAll, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
extension FavouriteImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogBreedCollectionViewCell.typeString, for: indexPath) as! DogBreedCollectionViewCell
        
        let index = indexPath.row
        
        let likedImage = filteredImages[index]
        cell.containerView.isHidden = false
        
        cell.imageView.setImage(with: likedImage.imageURL?.toURL())
        cell.likeButton.setImage(UIImage(systemName: Constants.Image.kHeartFill), for: .normal)
        
        cell.handler = { [ weak self] tag in
            
            guard let self else { return }
            
            self.likeImageRepository.removeLikedImage(imageURL: likedImage.imageURL ?? "") {
                self.loadFavoriteImages()
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension FavouriteImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacingBetweenCells: CGFloat = 10.0
        let totalSpacing = (2 - 1) * spacingBetweenCells
        let itemWidth = (collectionViewWidth - totalSpacing) / 2
        return CGSize(width: itemWidth - 10, height: 140)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing: CGFloat = 10.0
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}
