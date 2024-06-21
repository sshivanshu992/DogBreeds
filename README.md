# Welcome to Dog Breeds app 👋

Dog Breeds App is a mobile application developed using Swift UIKit that serves as a catalog of dog breeds with images fetched from the [Dog API](https://dog.ceo/dog-api/documentation/). It allows users to explore various dog breeds, view images for each breed, and manage favorite images.

## Tech stack

- Swift: For iOS app development using UIKit.
- iOS Version: 15.0

## Packages used

| Package             | Version |
| ------------------- | ------- |
| Kingfisher          | 7.11.0  |

## Get started

1. Clone the repository

   ```bash
   git clone https://github.com/sshivanshu992/DogBreeds.git
   ```

2. Navigate to the project directory

   ```bash
    cd DogBreeds
   ```

3. Install dependencies using CocoaPods

   ```bash
    pod install
   ```

4. Open the `.xcworkspace` file in Xcode:

   ```bash
    open DogBreedsApp.xcworkspace
   ```

5. Build and run the project in Xcode.


## Features
- Dog Breeds List:
    - Displays a list of dog breeds.
    - Includes sub-breeds for some breeds.
    - Tap on a breed to view details and images for that breed.
- Dog Breed Details
    - Shows multiple images of a specific dog breed.
    - Like/unlike images to manage favorites.
- Favorite Images
    - Lists liked dog breed images.
    - Filter images by selecting a specific breed.
