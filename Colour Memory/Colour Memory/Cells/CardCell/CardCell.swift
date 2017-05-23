//
//  CardCell.swift
//  Colour Memory
//
//  Created by Vignesh on 10/05/17.
//  Copyright © 2017 Vigneshuvi. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet var cardImageView: UIImageView!
    
    func setImageName(_ name: String) {
        let imageName : String = name.characters.count > 0 ? "Card-\(name)" :  "Card-Bg";
        self.cardImageView.image = UIImage(named:imageName, in: Bundle(for: type(of: self)), compatibleWith: nil)
    }
}
