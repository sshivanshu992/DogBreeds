//
//  DogBreedCollectionViewCell.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import UIKit

class DogBreedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    private let cornerRadius: CGFloat = 10.0
    private let masksToBounds: Bool = false
    
    var handler: ((Int)-> Void)?
    
    static var cellNib: UINib {
        return UINib(nibName: DogBreedCollectionViewCell.typeString, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.isHidden = true
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        self.containerView.layer.cornerRadius = self.cornerRadius
        self.imageView.layer.cornerRadius = self.cornerRadius
        self.likeButton.layer.cornerRadius = 4.0
        self.contentView.layer.cornerRadius = self.cornerRadius
        self.contentView.layer.masksToBounds = self.masksToBounds
        self.imageView.layer.masksToBounds = self.masksToBounds
        self.likeButton.layer.masksToBounds = self.masksToBounds
        self.imageView.clipsToBounds = true
        self.containerView.layer.masksToBounds = self.masksToBounds
        self.contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.contentView.layer.shadowOpacity = 1
        self.contentView.layer.shadowRadius = 20
        self.contentView.layer.shadowOffset.height = 2
    }
    @IBAction func likeButtonAction(_ sender: UIButton) {
        self.handler?(sender.tag)
    }
}
