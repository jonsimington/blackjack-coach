//
//  Player.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class Player {
    var _cards: [Card]
    var _chips: Int
    var _name: String
    var _settings: PlayerSettings
    var _record: PlayerRecord

    init(name: String = "", chips: Int = 0, cards: [Card] = [], settings: PlayerSettings = PlayerSettings(), record: PlayerRecord = PlayerRecord()) {
        _name = name
        _chips = chips
        _cards = cards
        _settings = settings
        _record = record
    }

    public var toString: String { return "\(_name): \(_cards), \(_chips)" }

    func canSplit() -> Bool {
        var lastCardRank = _cards.first?._rank

        // if every card in the player's hand is the same rank, then the player can split
        // if any arent the same rank, they can't split
        for card in _cards {
            if card._rank != lastCardRank {
                return false
            }
            lastCardRank = card._rank
        }

        return true
    }

    // calculates the player's score
    func score() -> (value: Int, type: HAND_VALUE_TYPE) {
        var total = 0

        let acesInHand = _cards.filter { $0._rank == CARD_RANK.ACE }
        let nonAcesInHand = _cards.filter { $0._rank != CARD_RANK.ACE }
        let hiddenAces = acesInHand.filter { $0._isFaceUp == false }
        let faceUpCards = _cards.filter { $0._isFaceUp == true }

        var handValueType = HAND_VALUE_TYPE.HARD

        // if there are 2 cards in hand, and one of them is an ace, then the hand is soft
        if _cards.count == 2 && acesInHand.count > 0 && (hiddenAces.count == 0 || hiddenAces.count == 2) {
            handValueType = HAND_VALUE_TYPE.SOFT
        }

        // if there are aces in hand, we should check if counting the aces as 11 would bust the player
        if acesInHand.count > 0 {
            let elevatedAcesInHand = Array(acesInHand.map { (card: Card) -> Card in
                let item = Card(rank: card._rank, value: card._value * 11, suit: card._suit, isFaceUp: card._isFaceUp)
                return item
            })

            // merge array of non-aces with array of 11-valued aces
            let elevatedHand = nonAcesInHand + elevatedAcesInHand

            // get score including elevated Aces
            for c in elevatedHand {
                if c._isFaceUp {
                    total += c._value
                }
            }

            // if we are still below 21, count the ace as 11
            if total <= 21 {
                return (total, handValueType)
            }
            // elevatedAcesInHand.forEach { card in print(card) }
        }

        total = 0
        for c in faceUpCards {
            total += c._value
        }

        return (total, handValueType)
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
