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
    
    private let viewModel = FavouriteImagesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfiguration()
        self.bindViewModel()
    }

    private func initialConfiguration() {
        title = Constants.ScreenTitle.kFavouritePictures
        self.registerCell()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.setupFilterButton()
    }

    private func registerCell() {
        self.collectionView.register(DogBreedCollectionViewCell.cellNib, forCellWithReuseIdentifier: DogBreedCollectionViewCell.typeString)
    }

    private func bindViewModel() {
        self.viewModel.loadFavoriteImages()
        self.viewModel.didUpdateImages = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.noFavouritesStackView.isHidden = self.viewModel.filteredImages.count > 0
            }
        }
    }

    private func setupFilterButton() {
        let filterButton = UIBarButtonItem(title: Constants.kFilter, style: .plain, target: self, action: #selector(filterTapped))
        navigationItem.rightBarButtonItem = filterButton
    }

    @objc private func filterTapped() {
        let alert = UIAlertController(title: Constants.kFilterBy, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.kAll, style: .default) { [weak self] _ in
            self?.viewModel.filterImages(by: nil)
        })
        for breed in viewModel.breeds {
            alert.addAction(UIAlertAction(title: breed.capitalized, style: .default) { [weak self] _ in
                self?.viewModel.filterImages(by: breed)
            })
        }
        alert.addAction(UIAlertAction(title: Constants.kCancel, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension FavouriteImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogBreedCollectionViewCell.typeString, for: indexPath) as! DogBreedCollectionViewCell
        
        let likedImage = viewModel.filteredImages[indexPath.row]
        cell.containerView.isHidden = false
        cell.imageView.tag = indexPath.row
        cell.imageView.setImage(with: likedImage.imageURL?.toURL())
        cell.likeButton.tag = indexPath.row
        cell.likeButton.setImage(UIImage(systemName: Constants.Image.kHeartFill), for: .normal)

        cell.handler = { [weak self] tag in
            guard let self = self else { return }
            self.viewModel.removeImage(at: indexPath.row)
        }
        
        return cell
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
