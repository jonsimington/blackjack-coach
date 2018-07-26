//
//  Deck.swift
//  BlackjackBuddy
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

    // constructor
    init(numberOfDecks: Int) {
        _cards = []

        for _ in 1...numberOfDecks {
            for suit in suits {
                for rank in ranks {
                    let rankValue = CARD_RANK.getValue(rank)()
                    let card = Card(rank: rank, value: rankValue, suit: suit)
                    _cards.append(card)
                }
            }
        }

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
        shuffleDeck()
    }

    // deals a card for a Player
    func dealCard(player: Player, isFaceUp: Bool = true) -> Card {
        // if deck is empty, we need to build a new deck
        if _cards.count == 0 {
            reloadDeck()
        }

        // get card at top of deck
        let card = _cards[0]

        // make card face down if appropriate
        card._isFaceUp = isFaceUp

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

        let currentPlayerScore = player.score()

        print("Dealt (\(card.description)) to (\(player._name)) --> \(currentPlayerScore)")

        return card
    }

    // shuffles the deck
    func shuffleDeck() {
        let originalDeck = _cards

        var last = _cards.count - 1

        while last > 0 {
            let rand = Int(arc4random_uniform(UInt32(last)))

            _cards.swapAt(last, rand)

            last -= 1
        }

        if _cards == originalDeck {
            print("Shuffled deck is the same as original!")
        }
    }
}
