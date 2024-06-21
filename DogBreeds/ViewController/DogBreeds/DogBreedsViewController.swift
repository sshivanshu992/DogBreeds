//
//  DogBreedsViewController.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import UIKit

class DogBreedsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = BreedsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfiguration()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchBreeds()
    }
    private func initialConfiguration() {
        title = Constants.ScreenTitle.kDogBreeds
        self.registerCell()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.bindViewModel()
    }

    private func registerCell() {
        self.collectionView.register(DogBreedCollectionViewCell.cellNib, forCellWithReuseIdentifier: DogBreedCollectionViewCell.typeString)
    }

    private func bindViewModel() {
        viewModel.didUpdateBreeds = { [weak self] in
            self?.reloadCollectionView()
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
        return viewModel.breedList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogBreedCollectionViewCell.typeString, for: indexPath) as! DogBreedCollectionViewCell
        
        let breed = viewModel.breedList[indexPath.row]
        
        cell.titleLabel.text = breed.capitalized
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let breed = viewModel.breedList[indexPath.row]
        let subBreeds = viewModel.breeds[breed] ?? []
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
