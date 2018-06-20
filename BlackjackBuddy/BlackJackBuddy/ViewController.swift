//
//  ViewController.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/15/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // LOCAL VARS
    var _player: Player?
    var _dealer: Dealer?
    var _deck: Deck?

    @IBOutlet var superView: UIView!
    @IBOutlet var middleView: UIView!

    // DEALER VIEWS
    @IBOutlet var dealerHandContainer: UIView!
    @IBOutlet var dealerHandCardsContainer: UIImageView!
    @IBOutlet var dealerCard1: UIImageView!
    @IBOutlet var dealerCard2: UIImageView!
    @IBOutlet var dealerNameLabel: UILabel!

    // PLAYER VIEWS
    @IBOutlet var playerHandContainer: UIView!
    @IBOutlet var playerHandCardsContainer: UIImageView!
    @IBOutlet var playerCard1: UIImageView!
    @IBOutlet var playerCard2: UIImageView!
    @IBOutlet var playerNameLabel: UILabel!

    // STATS VIEWS
    @IBOutlet var statsContainer: UIView!
    @IBOutlet var deckCountLabel: UILabel!
    @IBOutlet var playerScoreLabel: UILabel!
    @IBOutlet var dealerScoreLabel: UILabel!

    // RESTART GAME VIEWS
    @IBOutlet var restartGameButton: UIButton!
    @IBOutlet var restartGameLoadingCircle: UIImageView!

    @IBAction func restartGameButtonOnClick(_: Any) {
        initGame()
    }

    // GAME RESULT VIEWS
    @IBOutlet var gameResultContainer: UIView!
    @IBOutlet var gameResultLabel: UILabel!
    @IBOutlet var gameResultRestartButton: UIButton!

    @IBAction func gameResultRestartButtonOnClick(_: Any) {
        initGame()
    }

    // PLAYER CONTROLS VIEWS
    @IBOutlet var playerControlsContainer: UIView!
    @IBOutlet var playerHitStandContainer: UIView!
    @IBOutlet var playerStandButton: UIButton!
    @IBOutlet var playerSplitButton: UIButton!
    @IBOutlet var playerDoubleDownButton: UIButton!
    @IBOutlet var playerInsuranceButton: UIButton!
    @IBOutlet var playerSurrenderButton: UIButton!
    @IBOutlet var playerHitButton: UIButton!

    @IBAction func playerHitButtonOnClick(_: Any) {
        // disable hit and stand buttons
        playerHitButton.isEnabled = false
        playerStandButton.isEnabled = false

        // reload deck and shuffle it
        if _deck?._cards.count == 0 {
            _deck?.reloadDeck()
        }

        // deal card to player and check for a terminal state
        let dealtCard = (_deck?.dealCard(player: _player!))!
        CardHelper.updateCardImage(card: dealtCard, image: playerCard2, imageViewName: "playerCard2")
        updateStats()

        checkIfGameIsOver()
    }

    // Updates label text for player scores, remaining cards in deck
    func updateStats() {
        playerScoreLabel.text = "\(_player?.score() ?? 0)"
        playerScoreLabel.sizeToFit()
        dealerScoreLabel.text = "\(_dealer?.score() ?? 0)"
        dealerScoreLabel.sizeToFit()
        deckCountLabel.text = "\(_deck?._cards.count ?? 52) cards"
    }

    // sets the UIImageViews associated with the player's hand and the dealer's hand
    func clearCardImages() {
        playerCard1.image = nil
        playerCard2.image = nil
        dealerCard1.image = nil
        dealerCard2.image = nil
    }

    func initPlayerHandUI(player: Player) {
        // orient cards container
        playerHandCardsContainer.frame.origin.x = CGFloat(Configuration.CARD_CONTAINER_PADDING_X)
        playerHandCardsContainer.frame.size.width = playerHandContainer.frame.width - CGFloat(Configuration.CARD_CONTAINER_PADDING_X * 2)

        // orient first card
        CardHelper.orientCardInHand(card: playerCard1, elementToPadFrom: playerHandCardsContainer, firstCard: true)

        // orient second card to the right of first card
        CardHelper.orientCardInHand(card: playerCard2, elementToPadFrom: playerCard1)

        // init player name label
        playerNameLabel.text = player._name.uppercased()
        playerNameLabel.sizeToFit()
        playerNameLabel.center.x = playerHandContainer.center.x
        playerNameLabel.frame.origin.y = playerHandCardsContainer.frame.origin.y - playerNameLabel.frame.height - CGFloat(Configuration.PLAYER_NAME_PADDING_Y)

        // init player score label
        playerScoreLabel.sizeToFit()
        playerScoreLabel.center.y = playerNameLabel.center.y
        playerScoreLabel.frame.origin.x = playerNameLabel.frame.origin.x + playerNameLabel.frame.width + CGFloat(Configuration.PLAYER_SCORE_PADDING_X)
    }

    func initDealerHandUI(dealer: Dealer) {
        // orient cards container
        dealerHandCardsContainer.frame.origin.x = CGFloat(Configuration.CARD_CONTAINER_PADDING_X)
        dealerHandCardsContainer.frame.size.width = dealerHandContainer.frame.width - CGFloat(Configuration.CARD_CONTAINER_PADDING_X * 2)

        // orient first card
        CardHelper.orientCardInHand(card: dealerCard1, elementToPadFrom: playerHandCardsContainer, firstCard: true)

        // orient second card
        CardHelper.orientCardInHand(card: dealerCard2, elementToPadFrom: dealerCard1)

        // init dealer name label
        dealerNameLabel.text = dealer._name.uppercased()
        dealerNameLabel.sizeToFit()
        dealerNameLabel.center.x = dealerHandContainer.center.x
        dealerNameLabel.frame.origin.y = dealerHandCardsContainer.frame.origin.y + dealerHandCardsContainer.frame.height + CGFloat(Configuration.PLAYER_NAME_PADDING_Y)

        // init dealer score label
        dealerScoreLabel.sizeToFit()
        dealerScoreLabel.center.y = dealerNameLabel.center.y
        dealerScoreLabel.frame.origin.x = dealerNameLabel.frame.origin.x + dealerNameLabel.frame.width + CGFloat(Configuration.PLAYER_SCORE_PADDING_X)
    }

    func resetPlayerControlButtonStates() {
        playerInsuranceButton.isEnabled = false
        playerSplitButton.isEnabled = false
        playerHitButton.isEnabled = true
        playerSurrenderButton.isEnabled = false
        playerDoubleDownButton.isEnabled = false
        playerStandButton.isEnabled = true
    }

    func initGame() {
        resetPlayerControlButtonStates()

        // hide gameResultContainer
        gameResultContainer.isHidden = true
        gameResultContainer.isUserInteractionEnabled = false

        // unhide the deal again button from this view
        restartGameButton.isHidden = false

        // init players
        _player = Player(name: "DR VAN NOSTRAND", chips: 0, cards: [])
        _dealer = Dealer(name: "DEALER", chips: 0, cards: [], settings: PlayerSettings())

        initPlayerHandUI(player: _player!)
        initDealerHandUI(dealer: _dealer!)

        // init deck
        if _deck == nil {
            _deck = Deck()
        }
        _deck?.shuffleDeck()

        initialDeal()
    }

    func initialDeal() {
        // deal to player
        var dealtCard = ((_deck?.dealCard(player: _player!)))!
        CardHelper.updateCardImage(card: dealtCard, image: playerCard1, imageViewName: "playerCard1")
        updateStats()

        // deal to Dealer
        dealtCard = (_deck?.dealCard(player: _dealer!))!
        CardHelper.updateCardImage(card: dealtCard, image: dealerCard1, imageViewName: "dealerCard1")
        updateStats()

        // deal to player again
        dealtCard = (_deck?.dealCard(player: _player!))!
        CardHelper.updateCardImage(card: dealtCard, image: playerCard2, imageViewName: "playerCard2")
        updateStats()

        // deal face down card to dealer
        dealtCard = (_deck?.dealCard(player: _dealer!, isFaceUp: false))!
        CardHelper.updateCardImage(card: dealtCard, image: dealerCard2, imageViewName: "dealerCard2")
        updateStats()
    }

    func handlePlayerBlackJack() {
        // hide restart game button from other view
        restartGameButton.isHidden = true

        // set game win status text
        gameResultLabel.text = "Blackjack!  You Win!"
        gameResultLabel.textColor = UIColor.green
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.green.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false
    }

    func setGameResultLabelPadding(labelPadding: CGFloat) {
        // left-padding
        gameResultLabel.frame.origin.x = gameResultContainer.frame.minX + labelPadding

        // right-padding
        gameResultLabel.frame.size.width = gameResultContainer.frame.width - labelPadding * 2
    }

    func handlePlayerBust() {
        // hide restart game button from other view
        restartGameButton.isHidden = true

        // set game over status text
        gameResultLabel.text = "Dang, broheim, you busted."
        gameResultLabel.textColor = UIColor.red
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.red.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false
    }

    // determines if user busted or got blackjack and updates the UI accordingly
    func checkIfGameIsOver() {
        // check if user busted
        if (_player?.score())! > 21 {
            handlePlayerBust()
        } else if _player?.score() == 21 {
            handlePlayerBlackJack()
        } else {
            // enable hit and stand buttons
            playerHitButton.isEnabled = true
            playerStandButton.isEnabled = true
        }
    }

    func initBaseUI() {
        // attach superView's frame to the base view
        superView.frame.origin.x = view.frame.origin.x
        superView.frame.origin.y = view.safeAreaInsets.top + view.safeAreaInsets.bottom

        // set widths of inner containers to be that of the superView
        dealerHandContainer.frame.size.width = superView.frame.width
        middleView.frame.size.width = superView.frame.width
        playerControlsContainer.frame.size.width = middleView.frame.width
        playerHandContainer.frame.size.width = superView.frame.width
        statsContainer.frame.size.width = middleView.frame.width
        gameResultContainer.frame.size.width = superView.frame.width

        // fix padding of player control buttons to fit new width
        initplayerControlsContainerUI()

        // attach dealer hand to top of screen
        dealerHandContainer.frame.origin.y = superView.frame.origin.y

        // attach player hand to botton of screen
        playerHandContainer.frame.origin.y = superView.frame.height - playerHandContainer.frame.height
    }

    func initplayerControlsContainerUI() {
        // set left padding for insurance, split and hit buttons
        PaddingHelper.leftPadButton(button: playerInsuranceButton, elementToPadFrom: playerControlsContainer)
        PaddingHelper.leftPadButton(button: playerSplitButton, elementToPadFrom: playerControlsContainer)
        PaddingHelper.leftPadButton(button: playerHitButton, elementToPadFrom: playerControlsContainer)

        // set right padding for surrender, double down, stand buttons
        PaddingHelper.rightPadButton(button: playerSurrenderButton, elementToPadFrom: playerControlsContainer)
        PaddingHelper.rightPadButton(button: playerDoubleDownButton, elementToPadFrom: playerControlsContainer)
        PaddingHelper.rightPadButton(button: playerStandButton, elementToPadFrom: playerControlsContainer)

        // set top padding for split, doubledown, hit, stand, deal again buttons
        PaddingHelper.topPadButton(button: playerSplitButton, elementToPadFrom: playerInsuranceButton)
        PaddingHelper.topPadButton(button: playerDoubleDownButton, elementToPadFrom: playerSurrenderButton)
        PaddingHelper.topPadButton(button: playerHitButton, elementToPadFrom: playerSplitButton)
        PaddingHelper.topPadButton(button: playerStandButton, elementToPadFrom: playerDoubleDownButton)
        PaddingHelper.topPadButton(button: restartGameButton, elementToPadFrom: playerHitButton)

        // vertically center deal again button
        restartGameButton.center.x = playerControlsContainer.center.x
        restartGameLoadingCircle.frame.origin.x = restartGameButton.frame.origin.x + CGFloat(Configuration.DEAL_AGAIN_LOADING_CIRCLE_PADDING_X)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initBaseUI()

        initGame()

        // check to see if user got blackjack or busted
        checkIfGameIsOver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
