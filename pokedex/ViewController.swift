//
//  ViewController.swift
//  pokedex
//
//  Created by Leonard Loo on 3/20/16.
//  Copyright © 2016 leoloo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var isInSearchMode = false
    var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        parsePokemonCSV()
        initAudio()
    }
    
    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows {
                if let pokeId = Int(row["id"]!), let name = row["identifier"] {
                    let poke = Pokemon(name: name, pokedexId: pokeId)
                    pokemons.append(poke)
                }
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // MARK: Search bar methods

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        isInSearchMode = !(searchBar.text == nil || searchText == "")
        print(isInSearchMode)
        if (isInSearchMode) {
            let lowerStr = searchText.lowercaseString
            filteredPokemons = pokemons.filter({$0.name.rangeOfString(lowerStr) != nil})
        } else {
            view.endEditing(true)
        }
        collectionView.reloadData()
    }

    
    // MARK: Audio methods
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        let url = NSURL(string: path)!
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: url)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func musicBtnPressed(sender: UIButton) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.25
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    // MARK: Collection view methods
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let pokemon = isInSearchMode ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
        
            cell.configureCell(pokemon)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let pokemon = isInSearchMode ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
        performSegueWithIdentifier("PokemonDetailVC", sender: pokemon)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isInSearchMode ? filteredPokemons.count : pokemons.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC, let pokemon = sender as? Pokemon {
                detailsVC.pokemon = pokemon
            }
        }
    }


}

