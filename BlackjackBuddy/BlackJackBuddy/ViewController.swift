//
//  ViewController.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/15/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import SnapKit
import UIKit

class ViewController: UIViewController {
    // LOCAL VARS
    var _player: Player?
    var _dealer: Dealer?
    var _deck: Deck?
    var _currentGameNumber: Int = 0

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
    @IBOutlet var playerCardsStack: UIStackView!
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
        addCardToHand(cardContainer: playerHandCardsContainer!, card: dealtCard, player: _player!)

        updateStats()

        checkIfGameIsOver()
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // UI FUNCTIONS
    ////////////////////////////////////////////////////////////////////////////////////////////////

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
        for v in playerHandCardsContainer.subViews(type: UIImageView.self) {
            v.removeFromSuperview()
        }
        for v in dealerHandCardsContainer.subViews(type: UIImageView.self) {
            v.removeFromSuperview()
        }
    }

    func initPlayerHandUI(player _: Player) {
        let playerNameOffsetY = 3

        // bind playerHandContainer to bottom of superView's safearea
        view.addSubview(playerHandContainer)
        playerHandContainer.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dealerHandContainer.snp.width)
            make.height.equalTo(dealerHandContainer.snp.height)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(middleView.snp.bottom)
        }

        // bind playerHandContainer to bottom of superView's safearea
        playerHandContainer.addSubview(playerHandCardsContainer)
        playerHandCardsContainer.snp.makeConstraints { (make) -> Void in

            make.bottom.equalTo(playerHandContainer.snp.bottom)
            make.left.equalTo(playerHandContainer.snp.left).offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(playerHandContainer.snp.right).offset(Configuration.CARD_CONTAINER_PADDING_X * -1)
        }

        // init player name label
        playerNameLabel.text = _player?._name.uppercased()
        playerNameLabel.sizeToFit()
        playerNameLabel.center.x = playerHandContainer.center.x
        playerNameLabel.frame.origin.y = playerHandCardsContainer.frame.origin.y - playerNameLabel.frame.height - CGFloat(Configuration.PLAYER_NAME_PADDING_Y)

        // init player score label
        playerScoreLabel.sizeToFit()
        playerScoreLabel.center.y = playerNameLabel.center.y + CGFloat(playerNameOffsetY)
        playerScoreLabel.frame.origin.x = playerNameLabel.frame.origin.x + playerNameLabel.frame.width + CGFloat(Configuration.PLAYER_SCORE_PADDING_X)
    }

    func initDealerHandUI(dealer _: Dealer) {
        let dealerNameOffsetY = 3
        // bind dealerHandContainer to top of superView's safeArea
        view.addSubview(dealerHandContainer)
        dealerHandContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(middleView.snp.top)
        }

        // bind dealerHandContainer to bottom of superView's safearea
        dealerHandContainer.addSubview(dealerHandCardsContainer)
        dealerHandCardsContainer.snp.makeConstraints { (make) -> Void in
            // make.bottom.equalTo(dealerHandContainer.snp.bottom)
            make.left.equalTo(dealerHandContainer.snp.left).offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(dealerHandContainer.snp.right).offset(Configuration.CARD_CONTAINER_PADDING_X * -1)
            make.top.equalTo(dealerHandContainer.snp.top)
        }

        // init dealer name label
        dealerNameLabel.text = _dealer?._name.uppercased()
        dealerNameLabel.sizeToFit()
        dealerNameLabel.center.x = dealerHandContainer.center.x
        dealerNameLabel.frame.origin.y = dealerHandContainer.frame.origin.y + playerNameLabel.frame.height + CGFloat(Configuration.PLAYER_NAME_PADDING_Y - dealerNameOffsetY)

        // init dealer score label
        dealerScoreLabel.sizeToFit()
        dealerScoreLabel.center.y = dealerNameLabel.center.y + CGFloat(dealerNameOffsetY)
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

    func setGameResultLabelPadding(labelPadding: CGFloat) {
        // left-padding
        gameResultLabel.frame.origin.x = gameResultContainer.frame.minX + labelPadding

        // right-padding
        gameResultLabel.frame.size.width = gameResultContainer.frame.width - labelPadding * 2
    }

    func initBaseUI() {
        // show borders on view edges for debugging
        if Configuration.SHOW_VIEW_OUTLINE_BORDERS {
            dealerHandContainer.layer.borderColor = UIColor.purple.cgColor
            dealerHandContainer.layer.borderWidth = 2
            middleView.layer.borderColor = UIColor.orange.cgColor
            middleView.layer.borderWidth = 4
            playerHandContainer.layer.borderColor = UIColor.purple.cgColor
            playerHandContainer.layer.borderWidth = 2
            statsContainer.layer.borderColor = UIColor.green.cgColor
            statsContainer.layer.borderWidth = 3
            playerControlsContainer.layer.borderColor = UIColor.green.cgColor
            playerControlsContainer.layer.borderWidth = 3
        }

        // bind middleView's subviews to top and bottom
        statsContainer.frame.origin.y = CGFloat(0)

        // set widths of inner containers to be that of the superView
        dealerHandContainer.frame.size.width = superView.frame.width
        middleView.frame.size.width = superView.frame.width
        playerControlsContainer.frame.size.width = middleView.frame.width
        playerHandContainer.frame.size.width = superView.frame.width
        statsContainer.frame.size.width = middleView.frame.width
        gameResultContainer.frame.size.width = superView.frame.width

        // fix padding of player control buttons to fit new width
        initplayerControlsContainerUI()
    }

    func bringGameResultViewToFront() {
        view.addSubview(gameResultContainer)
        gameResultContainer.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }
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
        restartGameLoadingCircle.center.y = restartGameButton.center.y
    }

    func addCardToHand(cardContainer: UIView, card: Card, player _: Player) {
        let newCardImage = UIImageView()

        let subviews = cardContainer.allSubViewsOf(type: UIImageView.self)
        let last = subviews.last

        cardContainer.addSubview(newCardImage)

        let leftAnchor = subviews.count > 1 ? last?.snp.right : last?.snp.left

        newCardImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(CGFloat(Configuration.CARD_WIDTH))
            make.height.equalTo(CGFloat(Configuration.CARD_HEIGHT))
            make.bottom.equalTo(cardContainer.snp.bottom).offset(Configuration.CARD_PADDING_Y * -1)
            make.top.equalTo(cardContainer.snp.top).offset(Configuration.CARD_PADDING_Y)
            make.left.equalTo(leftAnchor!).offset(Configuration.CARD_PADDING_X)
        }
        CardHelper.updateCardImage(card: card, image: newCardImage)
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // GAME FUNCTIONS
    ////////////////////////////////////////////////////////////////////////////////////////////////

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

    func initialDeal() {
        // deal card to player and check for a terminal state
        var dealtCard = (_deck?.dealCard(player: _player!))!
        addCardToHand(cardContainer: playerHandCardsContainer!, card: dealtCard, player: _player!)
        updateStats()

        // deal to Dealer
        dealtCard = (_deck?.dealCard(player: _dealer!))!
        addCardToHand(cardContainer: dealerHandCardsContainer!, card: dealtCard, player: _dealer!)
        updateStats()

        // deal to player again
        dealtCard = (_deck?.dealCard(player: _player!))!
        addCardToHand(cardContainer: playerHandCardsContainer!, card: dealtCard, player: _player!)
        updateStats()

        // deal face down card to dealer
        dealtCard = (_deck?.dealCard(player: _dealer!, isFaceUp: false))!
        addCardToHand(cardContainer: dealerHandCardsContainer!, card: dealtCard, player: _dealer!)
        updateStats()
    }

    func handlePlayerBust() {
        // hide restart game button from other view
        restartGameButton.isHidden = true

        // set game over status text
        gameResultLabel.text = "Dang, you busted."
        gameResultLabel.textColor = UIColor(named: "tomato")
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
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

    func handlePlayerBlackJack() {
        // hide restart game button from other view
        restartGameButton.isHidden = true

        // set game win status text
        gameResultLabel.text = "Blackjack!  You Win!"
        gameResultLabel.textColor = .green
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
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

    func initGame(firstGame _: Bool = false) {
        clearCardImages()
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
        bringGameResultViewToFront()

        // init deck
        if _deck == nil {
            _deck = Deck()
        }
        _deck?.shuffleDeck()

        initialDeal()
        _currentGameNumber += 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initBaseUI()

        initGame(firstGame: true)

        // check to see if user got blackjack or busted
        checkIfGameIsOver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
