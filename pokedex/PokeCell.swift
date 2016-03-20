//
//  PokeCell.swift
//  pokedex
//
//  Created by Leonard Loo on 3/20/16.
//  Copyright © 2016 leoloo. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    func configureCell(pokemonObj: Pokemon) {
        self.pokemon = pokemonObj
        self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        self.nameLbl.text = self.pokemon.name.capitalizedString
    }

}
