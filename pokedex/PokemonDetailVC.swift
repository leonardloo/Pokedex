//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Leonard Loo on 3/20/16.
//  Copyright © 2016 leoloo. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name.capitalizedString
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        pokedexLbl.text = "\(pokemon.pokedexId)"
        pokemon.downloadPokemonDetails { () -> () in
            print("DID WE GET HERE")
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        if (pokemon.nextEvolutionTxt == "") {
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
        } else {
            evoLbl.text = pokemon.nextEvolutionTxt
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            nextEvoImg.hidden = false
        }

        
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
