//
//  RoundedButton.swift
//  guess-pair
//
//  Created by Nguyen Anh Tuan on 4/1/21.
//  Copyright © 2021 BVU. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton:UIButton {
    private var originalBackgroundColor: UIColor!
    private var originalTitleColor: UIColor!
    
    
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = radius
        }
    }
    
    override func didMoveToSuperview() {
        originalBackgroundColor = self.backgroundColor
        originalTitleColor = self.titleColor(for: .normal)
    }
    
    
    func disable() {
        self.isEnabled = false
        self.backgroundColor = .lightGray
        self.setTitleColor(.gray, for: .normal)
    }
    
    func enable() {
        self.isEnabled = true
        self.backgroundColor = originalBackgroundColor
        self.setTitleColor(originalTitleColor, for: .normal)
    }
}



@IBDesignable class AnimalButton:RoundedButton {
    var isQuestion = false
    var rowIndex = 0
    var columnIndex = 0
    var animalName = ""
    
    func toQuestion() {
        isQuestion = true
        
        self.backgroundColor = .white
        self.setImage(UIImage(named: "question-mark"), for: .normal)
    }
}
