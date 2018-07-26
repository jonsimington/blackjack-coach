//
//  PlayerSettings.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/17/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class PlayerSettings {
    var SUGGESTED_PLAYS_ENABLED = false
    var NUMBER_OF_DECKS = 1
    var NAME = "DR VAN NOSTRAND"

    init(suggestionsEnabled: Bool = false, numberOfDecks: Int = 1, name: String = "DR VAN VOSTRAND") {
        SUGGESTED_PLAYS_ENABLED = suggestionsEnabled
        NUMBER_OF_DECKS = numberOfDecks
        NAME = name
    }
}
