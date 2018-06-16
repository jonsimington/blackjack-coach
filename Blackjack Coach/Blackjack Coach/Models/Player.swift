//
//  Player.swift
//  Blackjack Coach
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class Player {
    var _cards: [Card] = []
    var _chips: Int = 0
    var _name: String = ""

    init(name: String, chips: Int, cards: [Card]) {
        _name = name
        _chips = chips
        _cards = cards
    }

    public var description: String { return "\(_name): \(_cards), \(_chips)" }

    // calculates the player's score
    func score() -> Int {
        var total = 0

        for c in _cards {
            total += c._value
        }

        return total
    }

    // prints the player's hand to the console for debugging
    func printHand() {
        var output = "Your Hand: "

        for c in _cards {
            output += " \(c)"
        }

        output += " Total: \(score())"
        print(output)
    }
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs._name == rhs._name && lhs._cards == rhs._cards && lhs._chips == rhs._chips
    }
}
