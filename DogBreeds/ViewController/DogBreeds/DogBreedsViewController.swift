//
//  DogBreedsViewController.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import UIKit

class DogBreedsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel: BreedsViewModel = BreedsViewModel()
    private var breeds: [String: [String]] = [:]
    private var breedList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfiguration()
    }
    private func initialConfiguration() {
        title = Constants.ScreenTitle.kDogBreeds
        self.registerCell()
        self.callApi()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCell() {
        self.collectionView.register(DogBreedCollectionViewCell.cellNib, forCellWithReuseIdentifier: DogBreedCollectionViewCell.typeString)
    }
    private func callApi() {
        viewModel.fetchBreeds { [weak self] in

            guard let self else { return }

            if let breeds = self.viewModel.model.message {
                self.breeds = breeds
                self.breedList = breeds.keys.sorted()
                self.reloadCollectionView()
            }
        }
    }

    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension DogBreedsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogBreedCollectionViewCell.typeString, for: indexPath) as! DogBreedCollectionViewCell
        
        let breed = breedList[indexPath.row]
        
        cell.titleLabel.text = breed.capitalized
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let breed = breedList[indexPath.row]
        let subBreeds = breeds[breed] ?? []
        if subBreeds.isEmpty {
            let breedVC = DogBreedViewController()
            breedVC.breed = breed
            navigationController?.pushViewController(breedVC, animated: true)
        } else {
            let subBreedsVC = SubBreedsViewController()
            subBreedsVC.breed = breed
            subBreedsVC.subBreeds = subBreeds
            navigationController?.pushViewController(subBreedsVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DogBreedsViewController: UICollectionViewDelegateFlowLayout {
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
