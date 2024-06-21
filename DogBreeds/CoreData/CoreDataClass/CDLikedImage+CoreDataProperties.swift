//
//  CDLikedImage+CoreDataProperties.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 21/06/24.
//
//

import Foundation
import CoreData


extension CDLikedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDLikedImage> {
        return NSFetchRequest<CDLikedImage>(entityName: "CDLikedImage")
    }

    @NSManaged public var breed: String?
    @NSManaged public var subBreed: String?
    @NSManaged public var imageURL: String?

}

extension CDLikedImage : Identifiable {

}
