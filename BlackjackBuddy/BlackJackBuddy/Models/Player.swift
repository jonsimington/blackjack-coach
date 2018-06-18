//
//  Player.swift
//  BlackjackBuddy
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

        let acesInHand = _cards.filter { $0._rank == CARD_RANK.ACE }
        let nonAcesInHand = _cards.filter { $0._rank != CARD_RANK.ACE }

        // if there are aces in hand, we should check if counting the aces as 11 would bust the player
        if acesInHand.count > 0 {
            let elevatedAcesInHand = Array(acesInHand.map { (card: Card) -> Card in
                let item = Card(rank: card._rank, value: card._value * 11, suit: card._suit)
                return item
            })

            // merge array of non-aces with array of 11-valued aces
            let elevatedHand = nonAcesInHand + elevatedAcesInHand

            // get score including elevated Aces
            for c in elevatedHand {
                total += c._value
            }

            // if we are still below 21, count the ace as 11
            if total < 21 {
                return total
            }
            // elevatedAcesInHand.forEach { card in print(card) }
        }

        total = 0
        for c in _cards {
            total += c._value
        }

        return total
    }

    // prints the player's hand to the console for debugging
    func printHand() {
        var output = "Your Hand: "

        for c in _cards {
            output += " (\(c.description)),"
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
