//
//  PlayerRecord.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 7/29/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class PlayerRecord {
    var _wins: Int
    var _losses: Int
    var _ties: Int

    var _ratio: Float {
        if _losses > 0 {
            return Float(_wins) / Float(_losses)
        }
        if _wins > 0 && _losses == 0 {
            return Float(_wins)
        }
        return Float(0.000)
    }

    public var toString: String {
        return "\(_wins) - \(_losses) - \(_ties) (\(String(format: "%.3f", _ratio)))"
    }

    init(wins: Int = 0, losses: Int = 0, ties: Int = 0) {
        _wins = wins
        _losses = losses
        _ties = ties
    }
}
