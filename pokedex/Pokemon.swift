//
//  Pokemon.swift
//  pokedex
//
//  Created by Leonard Loo on 3/20/16.
//  Copyright © 2016 leoloo. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _pokemonUrl: String!
        
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                } else {
                    self._weight = ""
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                } else {
                    self._height = ""
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                } else {
                    self._attack = ""
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                } else {
                    self._defense = ""
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] {
                    var typeTxt = ""
                    for type in types {
                        if let typeName = type["name"] {
                            typeTxt += "\(typeName.capitalizedString) / "
                        }
                    }
                    if (typeTxt == "") {
                        self._type = "None"
                    } else {
                        self._type = String(typeTxt.characters.dropLast().dropLast())
                    }
                } else {
                    self._type = "None"
                }
                
                self._description = ""
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON(completionHandler: { (response) in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                                print(self._description)
                            }
                            completed()
                        })
                    }
                }
                
                self._nextEvolutionTxt = ""
                if let evoArr = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evoArr.count > 0 {
                    let evo = evoArr[0]
                    if let level = evo["level"] as? Int, let nextEvo = evo["to"] as? String, let nextEvoUri = evo["resource_uri"] as? String  {
                        if nextEvo.lowercaseString.rangeOfString("mega") == nil { // Can't support mega pokemon as of now
                            let nextEvoId = nextEvoUri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "").stringByReplacingOccurrencesOfString("/", withString: "")
                            self._nextEvolutionId = nextEvoId
                            self._nextEvolutionTxt = "Next Evolution: \(nextEvo) LVL \(level)"
                        }
                    }
                    
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                print(self._type)
            }
        }
        
        
    }
    
    
    var name: String {
        get {
            if (_name == nil) {
                 _name = ""
            }
            return _name
        }
    }
    
    var pokedexId: Int {
        get {
            if (_pokedexId == nil) {
                _pokedexId = -1
            }
            return _pokedexId
        }
    }
    
    var description: String {
        get {
            if (_description == nil) {
                _description = ""
            }
            return _description
        }
    }
    
    var type: String {
        get {
            if (_type == nil) {
                _type = "None"
            }
            return _type
        }
    }
    
    var defense: String {
        get {
            if (_defense == nil) {
                _defense = ""
            }
            return _defense
        }
    }
    
    var height: String {
        get {
            if (_height == nil) {
                _height = ""
            }
            return _height
        }
    }
    
    var weight: String {
        get {
            if (_weight == nil) {
                _weight = ""
            }
            return _weight
        }
    }
    
    var attack: String {
        get {
            if (_attack == nil) {
                _attack = ""
            }
            return _attack
        }
    }
    
    var nextEvolutionTxt: String {
        get {
            if (_nextEvolutionTxt == nil) {
                _nextEvolutionTxt = ""
            }
            return _nextEvolutionTxt
        }
    }
    
    var nextEvolutionId: String {
        get {
            if (_nextEvolutionId == nil) {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
    }
    
    var pokemonUrl: String {
        get {
            if (_pokemonUrl == nil) {
                _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)"
            }
            return _pokemonUrl
        }
    }
    
    
}
