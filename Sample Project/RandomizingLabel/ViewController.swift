//
//  ViewController.swift
//  RandomizingLabel
//
//  Created by Evan Dekhayser on 5/1/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var helloWorldLabel: RandomizingLabel!
	@IBOutlet weak var foreverRandomLabel: RandomizingLabel!
	@IBOutlet weak var stoppableLabel: RandomizingLabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		helloWorldLabel.randomizeAndSettle()
		foreverRandomLabel.randomizeIndefinitely()
		stoppableLabel.randomizeIndefinitely()
	}
	
	@IBAction func buttonTapped(sender: UIButton) {
		if sender.currentTitle == "Stop"{
			sender.setTitle("Restart", forState: .Normal)
			stoppableLabel.randomizeAndSettle()
		} else {
			sender.setTitle("Stop", forState: .Normal)
			stoppableLabel.randomizeIndefinitely()
		}
	}
	
	@IBAction func segmentDidChange(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex{
		case 0:
			helloWorldLabel.characterOption = .Alphanumeric
			foreverRandomLabel.characterOption = .Alphanumeric
			stoppableLabel.characterOption = .Alphanumeric
		case 1:
			helloWorldLabel.characterOption = .AlphanumericUppercase
			foreverRandomLabel.characterOption = .AlphanumericUppercase
			stoppableLabel.characterOption = .AlphanumericUppercase
		case 2:
			helloWorldLabel.characterOption = .Alphabetic
			foreverRandomLabel.characterOption = .Alphabetic
			stoppableLabel.characterOption = .Alphabetic
		case 3:
			helloWorldLabel.characterOption = .AlphabeticUppercase
			foreverRandomLabel.characterOption = .AlphanumericUppercase
			stoppableLabel.characterOption = .AlphanumericUppercase
		default: break
		}
	}

}

