//
//  Animal.swift
//  guess-pair
//
//  Created by Nguyen Anh Tuan on 3/31/21.
//  Copyright © 2021 BVU. All rights reserved.
//

import Foundation
import UIKit

class Animal {
    var name: String
    var imageURL: URL
    var soundURL: URL?
    
    init(name: String, imageURL: URL, soundURL: URL?) {
        self.name = name
        self.imageURL = imageURL
        self.soundURL = soundURL
    }
}
