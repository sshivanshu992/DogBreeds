//
//  Lodder.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//

import UIKit


class Loader {
    static let shared = Loader()
    private var activityIndicator: UIActivityIndicatorView?
    private var overlayView: UIView?
    
    private init() {
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator?.color = .systemGray
        self.overlayView = UIView(frame: UIScreen.main.bounds)
        /// Light gray with some transparency
        self.overlayView?.backgroundColor = UIColor(white: 0, alpha: 0.3)
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            guard let window = Utility.shared.keyWindow else { return }
            self.activityIndicator?.center = window.center
            window.addSubview(self.overlayView!)
            window.addSubview(self.activityIndicator!)
            self.activityIndicator?.startAnimating()
            /// Disable user interaction while loading
            window.isUserInteractionEnabled = false
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            self.overlayView?.removeFromSuperview()
            guard let window = Utility.shared.keyWindow else { return }
            /// Enable user interaction after loading
            window.isUserInteractionEnabled = true
        }
    }
}
