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
    @IBOutlet var dealerNameLabel: UILabel!

    // PLAYER VIEWS
    @IBOutlet var playerHandContainer: UIView!
    @IBOutlet var playerCard1: UIImageView!
    @IBOutlet var playerCard2: UIImageView!

    @IBOutlet var playerControlsContainer: UIView!
    @IBOutlet var playerHitButton: UIButton!
    @IBAction func playerHitButtonOnClick(_: Any) {
        // accept user input here
        let userAction = USER_ACTION.HIT

        // continue dealing to player until they either bust or stop hitting
        while (_player?.score())! < 22 && userAction != USER_ACTION.STAND {
            // reload deck and shuffle it
            if _deck?._cards.count == 0 {
                _deck?.reloadDeck()
            }

            let dealtCard = (_deck?.dealCard(player: _player!))!
            updateCardImage(card: dealtCard, image: playerCard2, imageViewName: "playerCard2")
            updateStats()
            _player?.printHand()
        }
    }

    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerStandButton: UIButton!
    @IBOutlet var playerSplitButton: UIButton!
    @IBOutlet var playerDoubleDownButton: UIButton!
    @IBOutlet var playerInsuranceButton: UIButton!
    @IBOutlet var playerSurrenderButton: UIButton!

    // STATS VIEWS
    @IBOutlet var statsContainer: UIView!
    @IBOutlet var deckCountLabel: UILabel!
    @IBOutlet var playerScoreLabel: UILabel!
    @IBOutlet var dealerScoreLabel: UILabel!

    // RESTART GAME VIEWS
    @IBOutlet var restartGameButton: UIButton!
    @IBAction func restartGameButtonOnClick(_: Any) {
        initGame()
    }

    var _player: Player?
    var _dealer: Dealer?
    var _deck: Deck?

    func updateStats() {
        playerScoreLabel.text = "\(_player?.score() ?? 0)"
        dealerScoreLabel.text = "\(_dealer?.score() ?? 0)"
        deckCountLabel.text = "\(_deck?._cards.count ?? 52) cards"
    }

    func updateCardImage(card: Card, image: UIImageView, imageViewName: String) {
        let cardImageName = getCardImageName(card: card)
        image.image = UIImage(named: cardImageName)
        print("Updated \(imageViewName) to \(cardImageName)")
    }

    func initGame() {
        // clear card images
        playerCard1.image = nil
        playerCard2.image = nil
        dealerCard1.image = nil
        dealerCard2.image = nil

        // init players
        _player = Player(name: "JON", chips: 0, cards: [])
        _dealer = Dealer(name: "DEALER", chips: 0, cards: [])

        // init player name labels
        playerNameLabel.text = _player?._name
        dealerNameLabel.text = _dealer?._name

        // init deck
        if _deck == nil {
            _deck = Deck()
        }
        _deck?.shuffleDeck()

        // deal to player
        var dealtCard = ((_deck?.dealCard(player: _player!)))!
        updateCardImage(card: dealtCard, image: playerCard1, imageViewName: "playerCard1")
        updateStats()

        // deal to Dealer
        dealtCard = (_deck?.dealCard(player: _dealer!))!
        updateCardImage(card: dealtCard, image: dealerCard1, imageViewName: "dealerCard1")
        updateStats()

        // deal to player again
        dealtCard = (_deck?.dealCard(player: _player!))!
        updateCardImage(card: dealtCard, image: playerCard2, imageViewName: "playerCard2")
        updateStats()

        // check if user busted on first deal
        if (_player?.score())! > 21 {
            // HANDLE GAMEOVER LOGIC HERE
        } else if _player?.score() == 21 {
            // HANDLE GAME WIN - BLACKJACK LOGIC HERE
        } else {
            // enable hit and stand buttons
            playerHitButton.isEnabled = true
            playerStandButton.isEnabled = true
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
