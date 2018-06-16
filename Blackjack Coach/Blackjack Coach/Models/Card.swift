//
//  Card.swift
//  Blackjack Coach
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class Card {
    var _name: String = ""
    var _value: Int = 0
    var _suit: CARD_SUIT = CARD_SUIT.CLUBS

    public var description: String { return "\(_name) of \(_suit)" }
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs._name == rhs._name && lhs._value == rhs._value && lhs._suit == rhs._suit
    }
}
