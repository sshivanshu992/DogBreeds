//
//  SubBreedsViewController.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import UIKit

class SubBreedsViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var breed: String?
    var subBreeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfiguration()
    }

    private func initialConfiguration() {
        title = Constants.ScreenTitle.kSubDogBreeds
        self.registerCell()
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
}

extension SubBreedsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subBreeds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogBreedCollectionViewCell.typeString, for: indexPath) as! DogBreedCollectionViewCell
        
        let breed = subBreeds[indexPath.row]
        
        cell.titleLabel.text = breed.capitalized
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subBreed = subBreeds[indexPath.row]
        let breedVC = DogBreedViewController()
        breedVC.breed = breed
        breedVC.subBreed = subBreed
        navigationController?.pushViewController(breedVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SubBreedsViewController: UICollectionViewDelegateFlowLayout {
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
