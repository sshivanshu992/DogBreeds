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
    private var images: [URL] = []
    private var likedImages: Set<URL> = []
    private let likeImageRepository = LikeImageRepository()
    private let viewModel = DogImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfiguration()
    }
    private func initialConfiguration() {
        title = subBreed != nil ? "\(breed?.capitalized ?? "") \(subBreed?.capitalized ?? "")" : breed?.capitalized
        self.registerCell()
        self.callApi()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCell() {
        self.collectionView.register(DogBreedCollectionViewCell.cellNib, forCellWithReuseIdentifier: DogBreedCollectionViewCell.typeString)
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    private func callApi() {
        viewModel.fetchDogImages (for: breed ?? "", subBreed: subBreed) { [weak self] in
            guard let self else { return }
            
            let model = self.viewModel.model
            
            if let images = model.message {
                self.images = images
            } else {
                self.images = []
            }
            self.likeImageRepository.getLikedImages { [weak self] likedImages in
                
                guard let self else { return }
                
                self.likedImages = Set(likedImages.filter { $0.breed == self.breed && $0.subBreed == self.subBreed }.compactMap({$0.imageURL?.toURL()}))
                self.reloadCollectionView()
            }
           
        }
    }
}
extension DogBreedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogBreedCollectionViewCell.typeString, for: indexPath) as! DogBreedCollectionViewCell
        
        let index = indexPath.row
        
        let url = images[index]
        
        cell.imageView.tag = index
        cell.likeButton.tag = index
        
        cell.containerView.isHidden = false
        
        cell.imageView.setImage(with: url)
        
        let image = likedImages.contains(url) ? UIImage(systemName: Constants.Image.kHeartFill): UIImage(systemName: Constants.Image.kHeart)
        cell.likeButton.setImage(image, for: .normal)
        
        cell.handler = { tag in
            let image = self.images[tag]
            if self.likedImages.contains(image) {
                self.likedImages.remove(image)
                cell.likeButton.setImage(UIImage(systemName: Constants.Image.kHeart), for: .normal)
                self.likeImageRepository.removeLikedImage(imageURL: image.toString()) {
                    print("Image unliked successfully")
                }
            } else {
                self.likedImages.insert(image)
                cell.likeButton.setImage(UIImage(systemName: Constants.Image.kHeartFill), for: .normal)
                self.likeImageRepository.saveLikedImage(breed: self.breed, subBreed: self.subBreed, imageURL: image.toString()) {
                    print("Image liked successfully")
                }
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
