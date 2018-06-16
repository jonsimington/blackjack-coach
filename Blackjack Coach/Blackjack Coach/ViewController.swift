//
//  ViewController.swift
//  Blackjack Coach
//
//  Created by Jon Simington on 6/15/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // DEALER VIEWS
    @IBOutlet var dealerHandContainer: UIView!
    @IBOutlet var dealerCard1: UIImageView!
    @IBOutlet var dealerCard2: UIImageView!

    // PLAYER VIEWS
    @IBOutlet var playerHandContainer: UIView!
    @IBOutlet var playerCard1: UIImageView!
    @IBOutlet var playerCard2: UIImageView!

    @IBOutlet var playerControlsContainer: UIView!
    @IBOutlet var playerHitButton: UIButton!
    @IBOutlet var playerStandButton: UIButton!
    @IBOutlet var playerSplitButton: UIButton!
    @IBOutlet var playerDoubleDownButton: UIButton!
    @IBOutlet var playerInsuranceButton: UIButton!
    @IBOutlet var playerSurrenderButton: UIButton!

    var _player: Player?
    var _dealer: Dealer?
    var _deck: Deck?

    func initGame() {
        // init players
        _player = Player(name: "Jon", chips: 0, cards: [])
        _dealer = Dealer(name: "DEALER", chips: 0, cards: [])

        // init deck
        _deck = Deck()
        _deck?.shuffleDeck()

        // deal to player
        var dealtCard = ((_deck?.dealCard(player: _player!)))!
        var cardImageName = getCardImageName(card: dealtCard)
        playerCard1.image = UIImage(named: cardImageName)

        // deal to Dealer
        dealtCard = (_deck?.dealCard(player: _dealer!))!
        cardImageName = getCardImageName(card: dealtCard)
        dealerCard1.image = UIImage(named: cardImageName)

        // deal to player again
        dealtCard = (_deck?.dealCard(player: _player!))!
        _player?.printHand()


        // check if user busted on first deal
        if (_player?.score())! > 21 {
            // HANDLE GAMEOVER LOGIC HERE
        }
            // check if user got blackjack on first deal
        else if _player?.score() == 21 {
            // HANDLE GAME WIN - BLACKJACK LOGIC HERE
        }
        else {
            // accept user input here
            let userAction = USER_ACTION.HIT


            // continue dealing to player until they either bust or stop hitting
            while (_player?.score())! < 22 && userAction != USER_ACTION.STAND {
                // reload deck and shuffle it
                if _deck?._cards.count == 0 {
                    _deck?.reloadDeck()
                }

                dealtCard = (_deck?.dealCard(player: _player!))!
                _player?.printHand()
            }
        }

    }

    func getCardImageName(card: Card) -> String {
        let dealtRank = card._rank.getImageName()
        let dealtSuit = card._suit.getImageName()
        let cardImageName = "\(dealtRank)_\(dealtSuit)"

        return cardImageName
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        initGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
