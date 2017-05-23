//
//  UserCell.swift
//  Colour Memory
//
//  Created by Vignesh on 10/05/17.
//  Copyright © 2017 Vigneshuvi. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
