//
//  UIImageView+Addition.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    public func setImage(with url: URL?) {
        guard let url = url else { return }
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}
