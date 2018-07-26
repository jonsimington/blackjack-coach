//
//  UserSetupViewController.swift
//  BlackjackBuddy
//
//  Created by CN117164 on 6/20/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import UIKit

struct User {
    var name = ""
    var numberOfDecks = 0
}

class UserSetupViewController: UIViewController {
    var _user: User?

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var numberOfDecksSlider: UISlider!
    @IBAction func numberOfDecksSliderValueDidChange(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        let deckPluralization = currentValue == 1 ? "Deck" : "Decks"
        numberOfDecksLabel.text = "\(currentValue) \(deckPluralization)"
    }

    @IBOutlet var numberOfDecksLabel: UILabel!
    @IBOutlet var numberOfDecksSliderDescription: UILabel!

    @IBOutlet var playButton: UIButton!
    @IBAction func playButtonOnClick(_: Any) {
//        _user = User(name: userNameTextField.text!, numberOfDecks: Int(numberOfDecksSlider.value))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        LayoutHelper.initBaseUserSetupUI(_view: view, _viewController: self)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let destinationViewController = segue.destination as? BlackJackViewController {
            _user = User(name: userNameTextField.text!, numberOfDecks: Int(numberOfDecksSlider.value))
            destinationViewController._user = _user
        }
    }
}
