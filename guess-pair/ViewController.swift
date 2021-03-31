//
//  ViewController.swift
//  guess-pair
//
//  Created by Nguyen Anh Tuan on 4/1/21.
//  Copyright © 2021 BVU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let path = Bundle.main.resourcePath {
            let imagePath = path + "/GameData/Images"
            let url = NSURL(fileURLWithPath: imagePath)
            let fileManager = FileManager.default

            let properties = [URLResourceKey.localizedNameKey,
                              URLResourceKey.creationDateKey,
                              URLResourceKey.localizedTypeDescriptionKey]

            do {
                let imageURLs = try fileManager.contentsOfDirectory(at: url as URL, includingPropertiesForKeys: properties, options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)

                print("image URLs: \(imageURLs)")
                // Create image from URL
                let firstImageURL = imageURLs[0]
                let firstImageData = try Data(contentsOf: firstImageURL)
                let firstImage = UIImage(data: firstImageData)

                // Do something with first image
                print(firstImage)

            } catch let error as NSError {
                print(error.description)
            }
        }

    }


}

