//
//  AlertController.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import UIKit

class AlertController {
    // MARK: - Singleton
    static let instance = AlertController()

    // MARK: - Private Functions
    private func topViewController(controller: UIViewController? = Utility.shared.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    // MARK: - Class Functions
    open class func alert(title: String = "", message: String = "", acceptMessage: String = "Ok", acceptBlock: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: acceptMessage, style: .default) { _ in
                acceptBlock?()
            })
            self.instance.topViewController()?.present(alert, animated: true)
        }
    }
}
