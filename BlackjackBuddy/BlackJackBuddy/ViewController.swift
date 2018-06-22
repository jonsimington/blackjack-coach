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
    @IBOutlet var dealerNameLabel: UILabel!

    // PLAYER VIEWS
    @IBOutlet var playerHandContainer: UIView!
    @IBOutlet var playerHandCardsContainer: UIImageView!
    @IBOutlet var playerNameLabel: UILabel!

    // STATS VIEWS
    @IBOutlet var statsContainer: UIView!
    @IBOutlet var deckCountLabel: UILabel!
    @IBOutlet var cardsInDeckLabel: UILabel!
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
        dealerScoreLabel.text = "\(_dealer?.score() ?? 0)"
        deckCountLabel.text = "\(_deck?._cards.count ?? 52) CARDS REMAINING IN DECK"
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
        // bind playerHandContainer to bottom of superView's safearea
        view.addSubview(playerHandContainer)
        playerHandContainer.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
        }

        // bind playerHandContainer to bottom of superView's safearea
        playerHandContainer.addSubview(playerHandCardsContainer)
        playerHandCardsContainer.snp.makeConstraints { (make) -> Void in

            make.bottom.equalTo(playerHandContainer.snp.bottom)
            make.left.equalTo(playerHandContainer.snp.left).offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(playerHandContainer.snp.right).offset(Configuration.CARD_CONTAINER_PADDING_X * -1)
            make.height.equalTo(view.snp.height).multipliedBy(0.12)
            make.bottom.equalTo(playerHandContainer.snp.bottom)
        }

        // init player name label
        playerNameLabel.text = _player?._name.uppercased()
        playerNameLabel.sizeToFit()
        playerHandContainer.addSubview(playerNameLabel)
        playerNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playerHandContainer.snp.top)
                .offset(Configuration.PLAYER_NAME_PADDING_Y)
            make.bottom.equalTo(playerHandCardsContainer.snp.top)
                .offset(Configuration.PLAYER_NAME_PADDING_Y * -1)
            make.edges.lessThanOrEqualTo(playerHandContainer)
                .inset(Configuration.LABEL_PADDING_X)
            make.width.equalTo(playerNameLabel.frame.width * 2.5)

            make.height.equalTo(dealerNameLabel)
        }

        // init player score label
        playerHandContainer.addSubview(playerScoreLabel)
        playerScoreLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(playerNameLabel.snp.centerY)
            make.left.equalTo(playerNameLabel.snp.right)
            make.height.equalTo(playerNameLabel)
            make.right.equalTo(playerHandContainer).inset(Configuration.LABEL_PADDING_X)
        }

        // bind dealerHandContainer to top of superView's safeArea
        view.addSubview(dealerHandContainer)
        dealerHandContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        // bind dealerHandContainer to bottom of superView's safearea
        dealerHandContainer.addSubview(dealerHandCardsContainer)
        dealerHandCardsContainer.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(dealerHandContainer.snp.left)
                .offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(dealerHandContainer.snp.right)
                .offset(Configuration.CARD_CONTAINER_PADDING_X * -1)
            make.top.equalTo(dealerHandContainer.snp.top)
            make.height.equalTo(view.snp.height).multipliedBy(0.12)
        }

        // init dealer name label
        dealerNameLabel.text = _dealer?._name.uppercased()
        dealerNameLabel.sizeToFit()

        dealerHandContainer.addSubview(dealerNameLabel)
        dealerNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dealerHandCardsContainer.snp.bottom)
                .offset(Configuration.PLAYER_NAME_PADDING_Y)
            make.bottom.equalTo(dealerHandContainer.snp.bottom)
                .offset(Configuration.PLAYER_NAME_PADDING_Y * -1)
            make.width.equalTo(dealerNameLabel.frame.width * 1.3)
            make.left.equalTo(dealerHandContainer).offset(Configuration.LABEL_PADDING_X)
        }

        // init dealer score label
        dealerHandContainer.addSubview(dealerScoreLabel)

        dealerScoreLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(dealerNameLabel.snp.centerY)
            make.left.equalTo(dealerNameLabel.snp.right)
            make.height.equalTo(dealerNameLabel)
            make.right.equalTo(dealerHandContainer).inset(Configuration.LABEL_PADDING_X)
        }

        // bind middle view between card hands containers
        view.addSubview(middleView)
        middleView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(playerHandContainer.snp.top)
            make.top.equalTo(dealerHandContainer.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }

        // init player controls view
        middleView.addSubview(playerControlsContainer)
        middleView.addSubview(statsContainer)

        statsContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(middleView)
            make.centerX.equalTo(middleView)
            print("stats \(statsContainer.center.x) middle \(middleView.center.x)")
        }

        statsContainer.addSubview(deckCountLabel)

        deckCountLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(middleView).inset(Configuration.LABEL_PADDING_X)
            make.left.equalTo(middleView).inset(Configuration.LABEL_PADDING_X)
            make.top.equalTo(dealerHandContainer.snp.bottom)
            make.bottom.equalTo(playerControlsContainer.snp.top)
        }

        playerControlsContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(middleView).offset(statsContainer.frame.size.height)
            make.bottom.equalTo(middleView.snp.bottom)
            make.width.equalTo(middleView)
        }

        playerControlsContainer.isUserInteractionEnabled = true
        playerControlsContainer.addSubview(playerInsuranceButton)
        playerControlsContainer.addSubview(playerSurrenderButton)
        playerControlsContainer.addSubview(playerSplitButton)
        playerControlsContainer.addSubview(playerDoubleDownButton)
        playerControlsContainer.addSubview(playerHitButton)
        playerControlsContainer.addSubview(playerStandButton)
        playerControlsContainer.addSubview(restartGameButton)

        playerInsuranceButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.left.equalTo(playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
            make.width.lessThanOrEqualTo((middleView.frame.width - (3.0 * CGFloat(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X))) / 2.0)
        }

        playerSurrenderButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.right.equalTo(playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X * -1)
            make.width.equalTo(playerInsuranceButton)
        }

        playerSplitButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playerInsuranceButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.width.equalTo(playerInsuranceButton)
            make.left.equalTo(playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
        }

        playerDoubleDownButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playerSurrenderButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.width.equalTo(playerInsuranceButton)
            make.right.equalTo(playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X * -1)
        }

        playerHitButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playerSplitButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.width.equalTo(playerInsuranceButton)
            make.left.equalTo(playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
        }

        playerStandButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playerDoubleDownButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.width.equalTo(playerInsuranceButton)
            make.right.equalTo(playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X * -1)
        }

        restartGameButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playerHitButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.left.equalTo(middleView).offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
            make.right.equalTo(middleView).inset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
        }
        playerControlsContainer.addSubview(restartGameLoadingCircle)

        restartGameLoadingCircle.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(restartGameButton)
                .offset(Configuration.DEAL_AGAIN_LOADING_CIRCLE_PADDING_X)
            make.centerY.equalTo(restartGameButton)
            make.height.equalTo(restartGameLoadingCircle.frame.size.height * 0.95)
            make.width.equalTo(restartGameLoadingCircle.frame.size.width * 0.95)
        }

        // show borders on view edges for debugging
        if Configuration.SHOW_VIEW_OUTLINE_BORDERS {
            // dealer hand
            dealerHandContainer.layer.borderColor = UIColor.purple.cgColor
            dealerHandContainer.layer.borderWidth = 2
            dealerNameLabel.layer.borderColor = UIColor.green.cgColor
            dealerNameLabel.layer.borderWidth = 2
            dealerScoreLabel.layer.borderColor = UIColor.red.cgColor
            dealerScoreLabel.layer.borderWidth = 2
            dealerHandCardsContainer.layer.borderColor = UIColor.red.cgColor
            dealerHandCardsContainer.layer.borderWidth = 2

            // middleview
            middleView.layer.borderColor = UIColor.orange.cgColor
            middleView.layer.borderWidth = 2
            statsContainer.layer.borderColor = UIColor.magenta.cgColor
            statsContainer.layer.borderWidth = 4
            deckCountLabel.layer.borderColor = UIColor.magenta.cgColor
            deckCountLabel.layer.borderWidth = 2
            playerControlsContainer.layer.borderColor = UIColor.cyan.cgColor
            playerControlsContainer.layer.borderWidth = 4

            // player buttons
            playerInsuranceButton.layer.borderColor = UIColor.purple.cgColor
            playerInsuranceButton.layer.borderWidth = 3
            playerSurrenderButton.layer.borderColor = UIColor.purple.cgColor
            playerSurrenderButton.layer.borderWidth = 3
            playerSplitButton.layer.borderColor = UIColor.purple.cgColor
            playerSplitButton.layer.borderWidth = 3
            playerDoubleDownButton.layer.borderColor = UIColor.purple.cgColor
            playerDoubleDownButton.layer.borderWidth = 3
            playerHitButton.layer.borderColor = UIColor.purple.cgColor
            playerHitButton.layer.borderWidth = 3
            playerStandButton.layer.borderColor = UIColor.purple.cgColor
            playerStandButton.layer.borderWidth = 3
            restartGameButton.layer.borderColor = UIColor.purple.cgColor
            restartGameButton.layer.borderWidth = 3
            restartGameLoadingCircle.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
            restartGameLoadingCircle.layer.borderWidth = 2

            // player hand
            playerHandContainer.layer.borderColor = UIColor.purple.cgColor
            playerHandContainer.layer.borderWidth = 2
            playerNameLabel.layer.borderColor = UIColor.green.cgColor
            playerNameLabel.layer.borderWidth = 2
            playerScoreLabel.layer.borderColor = UIColor.red.cgColor
            playerScoreLabel.layer.borderWidth = 2
            playerHandCardsContainer.layer.borderColor = UIColor.red.cgColor
            playerHandCardsContainer.layer.borderWidth = 2
        }
    }

    func bringGameResultViewToFront() {
        view.addSubview(gameResultContainer)
        gameResultContainer.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }

        gameResultRestartButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.width.equalTo(restartGameButton)
            make.height.equalTo(gameResultRestartButton.snp.width)
                .multipliedBy(CGFloat(1) / CGFloat(4))
        }

        gameResultLabel.sizeToFit()
    }

    func addCardToHand(cardContainer: UIView, card: Card, player _: Player) {
        let newCardImage = UIImageView()

        let subviews = cardContainer.allSubViewsOf(type: UIImageView.self)
        let last = subviews.last

        cardContainer.addSubview(newCardImage)

        let leftAnchor = subviews.count > 1 ? last?.snp.right : last?.snp.left

        newCardImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(newCardImage.snp.height)
                .multipliedBy(CGFloat(Configuration.CARD_WIDTH) / CGFloat(Configuration.CARD_HEIGHT))
            make.bottom.equalTo(cardContainer.snp.bottom)
                .offset(Configuration.CARD_PADDING_Y * -1)
            make.top.equalTo(cardContainer.snp.top).offset(Configuration.CARD_PADDING_Y)
            make.left.equalTo(leftAnchor!).offset(Configuration.CARD_PADDING_X)
        }

        if Configuration.SHOW_VIEW_OUTLINE_BORDERS {
            newCardImage.layer.borderColor = UIColor.red.cgColor
            newCardImage.layer.borderWidth = 2
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
        restartGameLoadingCircle.isHidden = true

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
        restartGameLoadingCircle.isHidden = true

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
        // init players
        _player = Player(name: "DR VAN NOSTRAND", chips: 0, cards: [])
        _dealer = Dealer(name: "DEALER", chips: 0, cards: [], settings: PlayerSettings())
        playerNameLabel.text = _player?._name.uppercased()
        dealerNameLabel.text = _dealer?._name.uppercased()

        clearCardImages()
        resetPlayerControlButtonStates()

        // hide gameResultContainer
        gameResultContainer.isHidden = true
        gameResultContainer.isUserInteractionEnabled = false

        // unhide the deal again button from this view
        restartGameButton.isHidden = false
        restartGameLoadingCircle.isHidden = false

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

        // init players
        _player = Player(name: "DR VAN NOSTRAND", chips: 0, cards: [])
        _dealer = Dealer(name: "DEALER", chips: 0, cards: [], settings: PlayerSettings())

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
