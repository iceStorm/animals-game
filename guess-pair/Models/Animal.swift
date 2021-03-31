//
//  Animal.swift
//  guess-pair
//
//  Created by Nguyen Anh Tuan on 3/31/21.
//  Copyright © 2021 BVU. All rights reserved.
//

import Foundation

class Animal {
    var name: String
    var imageName: String
    var soundName: String
    
    init(name: String, imageName: String, soundName: String) {
        self.name = name
        self.imageName = imageName
        self.soundName = soundName
    }
}
