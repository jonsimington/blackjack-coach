//
//  UserSetupViewController.swift
//  BlackjackBuddy
//
//  Created by CN117164 on 6/20/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import UIKit

class UserSetupViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var numberOfDecksSlider: UISlider!
    @IBAction func numberOfDecksSliderValueDidChange(_ sender: UISlider) {
        let currentValue = Int((sender).value)
        numberOfDecksLabel.text = "\(currentValue) Decks"
    }
    @IBOutlet weak var numberOfDecksLabel: UILabel!
    
    
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonOnClick(_ sender: Any) {
        performSegue(withIdentifier: "View", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
