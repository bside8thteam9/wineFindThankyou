//
//  WalkthroughResulViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/04/02.
//

import Foundation
import UIKit

class WalkthroughResulViewController: UIViewController {
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var labelIntroduce: UILabel!
    @IBOutlet weak private var hashTags: UILabel!
    
    @IBAction private func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction private func nextStep(_ sender: UIButton) {
        
    }
    private var grapeCase: GrapeCase!
    internal var question2Answer: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        updateUI(getGrapeCase())
    }
    
    private func updateUI(_ answers: [String]) {
        imgView.image = grapeCase.grapeImage
        labelIntroduce.text = "나는야\n" + grapeCase.grapeName
        guard answers.count > 0 else { return }
        
        var hashTags: String = ""
        answers.forEach {
            hashTags += "#" + $0 + "\n"
        }
        self.hashTags.text = hashTags
    }
    
    private func getGrapeCase() -> [String] {
        guard let answer0 = question2Answer[QuestionList.question0.rawValue],
              let answer1 = question2Answer[QuestionList.question1.rawValue],
              let answer2 = question2Answer[QuestionList.question2.rawValue]
        else { return [] }
        
        if answer0 == WhenDoSelect.cost.str
            || answer1 == PriceOfWine.one2Two.str
            || answer1 == PriceOfWine.thr2Four.str {
            self.grapeCase = GrapeCase.costGrape
            return [answer0, answer1, answer2]
        } else if answer0 == WhenDoSelect.brand.str
                    || answer0 == WhenDoSelect.loc.str
                    || answer0 == WhenDoSelect.grape.str
                    || answer1 == PriceOfWine.quality.str {
            self.grapeCase = GrapeCase.artistGrape
            return [answer0, answer1, answer2]
        } else if answer2 == ReasonOfBought.forParty.str
                    || answer2 == ReasonOfBought.forMe.str {
            self.grapeCase = GrapeCase.dionysusGrape
            return [answer0, answer1, answer2]
        } else if answer0.contains("기타") {
            self.grapeCase = GrapeCase.analystGrape
            return [answer0, answer1, answer2]
        } else if answer2 == ReasonOfBought.forPresent.str {
            self.grapeCase = GrapeCase.childGrape
            return [answer0, answer1, answer2]
        } else {
            self.grapeCase = GrapeCase.analystGrape
            return [answer0, answer1, answer2]
        }
    }
    
    private func setUI() {
        labelIntroduce.numberOfLines = 0
        hashTags.numberOfLines = 0
        
        labelIntroduce.textColor = UIColor(rgb: 0x7B61FF)
        labelIntroduce.textAlignment = .center
        labelIntroduce.font = UIFont(name: "Gaegu-Regular", size: 32) ?? .systemFont(ofSize: 32)
        
        hashTags.textColor = UIColor(rgb: 0x424242)
        hashTags.textAlignment = .center
        hashTags.font = .systemFont(ofSize: 13)
    }
}
