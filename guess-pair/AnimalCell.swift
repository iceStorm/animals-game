//
//  AnimalCell.swift
//  guess-pair
//
//  Created by Nguyen Anh Tuan on 4/1/21.
//  Copyright © 2021 BVU. All rights reserved.
//

import UIKit

class AnimalCell: UITableViewCell {

    
    @IBOutlet var columns: [AnimalButton]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
