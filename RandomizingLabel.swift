//
//  RandomizingLabel.swift
//  RandomizingLabel
//
//  Created by Evan Dekhayser on 5/1/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

/**
The characters used when generating random strings.
*/
public enum RandomizingCharacterOption{
	/// Contains the characters A-Z, a-z, 0-9.
	case Alphanumeric
	/// Contains the characters A-Z, 0-9.
	case AlphanumericUppercase
	/// Contains the characters A-Z, a-z.
	case Alphabetic
	/// Contains the characters A-Z.
	case AlphabeticUppercase
	
	private static let alphanumericChoices = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890".characters)
	private static let alphanumericUppercaseChoices = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".characters)
	private static let alphabeticChoices = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".characters)
	private static let alphabeticUppercaseChoices = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)
	
	/// Returns an array of the characters represented by the enum value.
	public var characterValues: [Character]{
		switch self{
		case .Alphanumeric: return RandomizingCharacterOption.alphanumericChoices
		case .AlphanumericUppercase: return RandomizingCharacterOption.alphanumericUppercaseChoices
		case .Alphabetic: return RandomizingCharacterOption.alphabeticChoices
		case .AlphabeticUppercase: return RandomizingCharacterOption.alphabeticUppercaseChoices
		}
	}
	
}

/**
Label that randomizes the characters of a label, and optionally settles upon a final title.

Spaces are preserved.
*/
public class RandomizingLabel: UILabel{
	
	// MARK: Public Properties
	
	/// The final string that is shown after the label is done randomizing.
	@IBInspectable public var finalText: String = ""
	/// The characters that are used to generate a random title.
	public var characterOption: RandomizingCharacterOption = .Alphanumeric
	/// The time between each changed title.
	public var timeIntervalLength = 0.05
	
	// MARK: Public Methods
	
	/**
	Randomize the label's title while revealng the final text one character at a time.
	
	- Parameter timeIntervalsPerLetter: The number of random strings that must be iterated through before each additional character is revealed.
	*/
	public func randomizeAndSettle(timeIntervalsPerLetter timeIntervalsPerLetter: Int = 5){
		shouldStopSettling = false
		stopRandomizing()
		updateText(timeIntervalsPassed: 0, timeIntervalsPerLetter: timeIntervalsPerLetter)
	}
	
	/// Begin randomizing
	public func randomizeIndefinitely(){
		shouldStopLoopingIndefinitely = false
		updateTextLoopingIndefinitely()
	}
	
	// MARK: Private
	
	private var shouldStopLoopingIndefinitely = false
	private var shouldStopSettling = false
	
	private func stopRandomizing(){
		shouldStopLoopingIndefinitely = true
	}
	
	private func updateTextLoopingIndefinitely(){
		let partitions = finalText.componentsSeparatedByString(" ")
		text = partitions.map{ randomString($0.characters.count)}.joinWithSeparator(" ")
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(timeIntervalLength * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
			guard let shouldStopLoopingIndefinitely = self?.shouldStopLoopingIndefinitely where shouldStopLoopingIndefinitely == false else { return }
			self?.updateTextLoopingIndefinitely()
		}
	}
	
	private func updateText(timeIntervalsPassed timeIntervalsPassed: Int, timeIntervalsPerLetter: Int){
		let numberOfCharacters = finalText.characters.count
		let numberOfFinalCharacters = timeIntervalsPassed / timeIntervalsPerLetter
		var characters = finalText[0..<numberOfFinalCharacters].characters
		
		let partitions = finalText.componentsSeparatedByString(" ")
		let randomTextWithSpaces = partitions.map{ randomString($0.characters.count)}.joinWithSeparator(" ")
		
		characters.appendContentsOf(randomTextWithSpaces[numberOfFinalCharacters..<numberOfCharacters].characters)
		text = String(characters)
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
			guard let shouldStopSettling = self?.shouldStopSettling where shouldStopSettling == false else { return }
			guard numberOfFinalCharacters != numberOfCharacters else { return }
			self?.updateText(timeIntervalsPassed: timeIntervalsPassed + 1, timeIntervalsPerLetter: timeIntervalsPerLetter)
		}
	}
	
	private func randomString(length: Int) -> String{
		var value = ""
		for _ in 0..<length{
			let characterValues = characterOption.characterValues
			value.append(characterValues[Int(arc4random_uniform(UInt32(characterValues.count)))])
		}
		return value
	}
	
}

private extension String {
	
	subscript (i: Int) -> Character {
		return self[self.startIndex.advancedBy(i)]
	}
	
	subscript (i: Int) -> String {
		return String(self[i] as Character)
	}
	
	subscript (r: Range<Int>) -> String {
		let start = startIndex.advancedBy(r.startIndex)
		let end = start.advancedBy(r.endIndex - r.startIndex)
		return self[Range(start ..< end)]
	}
}