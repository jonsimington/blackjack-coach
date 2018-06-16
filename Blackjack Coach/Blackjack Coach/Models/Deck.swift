//
//  Deck.swift
//  Blackjack Coach
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class Deck {
    var _cards: [Card] = []

    // deals a card for a Player
    func dealCard(player: Player) -> Bool {
        // get card at top of deck
        let card = _cards[0]

        // add card to Player's cards
        player._cards.append(card)

        // remove card from deck
        _cards.remove(at: 0)

        // assert that card is added to player's cards, and from deck
        if !player._cards.contains(card) {
            return false
        } else if _cards.contains(card) {
            return false
        }

        return true
    }

    func shuffleDeck() {
        var last = _cards.count - 1

        while last > 0 {
            let rand = Int(arc4random_uniform(UInt32(last)))

            print("swap items[\(last)] = \(_cards[last]) with items[\(rand)] = \(_cards[rand])")

            _cards.swapAt(last, rand)

            print(_cards)

            last -= 1
        }
    }
}
