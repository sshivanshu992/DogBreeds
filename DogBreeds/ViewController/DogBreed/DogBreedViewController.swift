//
//  DogBreedViewController.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import UIKit

class DogBreedViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var breed: String?
    var subBreed: String?
    private let viewModel = DogImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfiguration()
        self.bindViewModel()
    }

    private func initialConfiguration() {
        title = subBreed != nil ? "\(breed?.capitalized ?? "") \(subBreed?.capitalized ?? "")" : breed?.capitalized
        self.registerCell()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.viewModel.fetchDogImages(for: breed ?? "", subBreed: subBreed)
    }
    
    private func registerCell() {
        self.collectionView.register(DogBreedCollectionViewCell.cellNib, forCellWithReuseIdentifier: DogBreedCollectionViewCell.typeString)
    }
    
    private func bindViewModel() {
        viewModel.didUpdateImages = { [weak self] in
            self?.reloadCollectionView()
        }
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
extension DogBreedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogBreedCollectionViewCell.typeString, for: indexPath) as! DogBreedCollectionViewCell
        
        let url = viewModel.images[indexPath.row]
        
        cell.imageView.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        cell.containerView.isHidden = false
        cell.imageView.setImage(with: url)
        
        let isContains = viewModel.likedImages.contains(url)
        let image = UIImage(systemName: isContains ? Constants.Image.kHeartFill : Constants.Image.kHeart)
        cell.likeButton.setImage(image, for: .normal)
        
        cell.handler = { [weak self] tag in
            guard let self = self else { return }
            let imageURL = self.viewModel.images[tag]
            self.viewModel.toggleLike(for: imageURL)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DogBreedViewController: UICollectionViewDelegateFlowLayout {
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
