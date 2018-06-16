//
//  Deck.swift
//  Blackjack Coach
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

let ranks: [CARD_RANK] = [
    CARD_RANK.ACE, CARD_RANK.TWO, CARD_RANK.THREE,
    CARD_RANK.FOUR, CARD_RANK.FIVE, CARD_RANK.SIX,
    CARD_RANK.SEVEN, CARD_RANK.EIGHT, CARD_RANK.NINE,
    CARD_RANK.JACK, CARD_RANK.QUEEN, CARD_RANK.KING,
]

let suits: [CARD_SUIT] = [
    CARD_SUIT.CLUBS, CARD_SUIT.HEARTS, CARD_SUIT.DIAMONDS,
    CARD_SUIT.SPADES,
]

class Deck {
    var _cards: [Card] = []

    init() {
        _cards = []

        for suit in suits {
            for rank in ranks {
                let rankValue = CARD_RANK.getValue(rank)()
                let card = Card(rank: rank, value: rankValue, suit: suit)
                _cards.append(card)
            }
        }
        var cards = _cards
    }

    // regenerates the deck and shuffles
    func reloadDeck() {
        _cards = []

        for suit in suits {
            for rank in ranks {
                let rankValue = CARD_RANK.getValue(rank)()
                let card = Card(rank: rank, value: rankValue, suit: suit)
                _cards.append(card)
            }
        }
        var cards = _cards
        shuffleDeck()
    }

    // deals a card for a Player
    func dealCard(player: Player) -> Card {
        // get card at top of deck
        let card = _cards[0]

        // add card to Player's cards
        player._cards.append(card)

        // remove card from deck
        _cards.remove(at: 0)

        // assert that card is added to player's cards, and from deck
        if !player._cards.contains(card) {
            return card
        } else if _cards.contains(card) {
            return card
        }

        return card
    }

    // shuffles the deck
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
