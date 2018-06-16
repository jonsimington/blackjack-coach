//
//  Card.swift
//  Blackjack Coach
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class Card {
    var _rank: CARD_RANK = CARD_RANK.ACE
    var _value: Int = 0
    var _suit: CARD_SUIT = CARD_SUIT.CLUBS

    init(rank: CARD_RANK, value: Int, suit: CARD_SUIT) {
        _rank = rank
        _value = value
        _suit = suit
    }

    public var description: String { return "\(_rank) of \(_suit)" }
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs._rank == rhs._rank && lhs._value == rhs._value && lhs._suit == rhs._suit
    }
}
