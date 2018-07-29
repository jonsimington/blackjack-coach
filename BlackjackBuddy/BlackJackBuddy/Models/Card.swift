//
//  Card.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class Card {
    var _rank: CARD_RANK
    var _value: Int
    var _suit: CARD_SUIT
    var _isFaceUp: Bool

    init(rank: CARD_RANK = CARD_RANK.ACE, value: Int = 0, suit: CARD_SUIT = CARD_SUIT.CLUBS, isFaceUp: Bool = true) {
        _rank = rank
        _value = value
        _suit = suit
        _isFaceUp = isFaceUp
    }

    public var description: String { return "\(_rank) of \(_suit)" }
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs._rank == rhs._rank && lhs._value == rhs._value && lhs._suit == rhs._suit
    }
}
