//
//  Utility.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import UIKit

final class Utility: NSObject {
    static let shared = Utility()

    /// Reference of the Scene delegate
    /// - Returns: SceneDelegate if available, otherwise nil
    var getSceneDelegateReference: SceneDelegate? {
        return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    }

    /// Retrieves the root view controller of the application's key window.
    ///
    /// - Returns: The root view controller of the key window if available, otherwise nil.
    var rootViewController: UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            return rootViewController
        }
        return nil
    }

    var keyWindow: UIWindow? {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return windowScene.windows.first(where: { $0.isKeyWindow })
        }
        return nil
    }
}
