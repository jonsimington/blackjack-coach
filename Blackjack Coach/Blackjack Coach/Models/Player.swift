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
        print("Your hand:")

        for c in _cards {
            print(c)
        }

        print("Total: \(score())")
    }
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs._name == rhs._name && lhs._cards == rhs._cards && lhs._chips == rhs._chips
    }
}
