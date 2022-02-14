//
//  colTestCell.swift
//  NewToy
//
//  Created by mun on 2022/01/28.
//

import Foundation
import UIKit
class WineInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var back: UIView!
    @IBOutlet private var img: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet weak var labelMore: UILabel!
    
    internal var wineInfo: WineInfo? {
        didSet{ updateUI() }
    }
    
    internal func setBackgroundColor() {
        self.layer.cornerRadius = 12
        self.back.layer.cornerRadius = 12
        self.back.backgroundColor = .clear
        self.name.backgroundColor = .clear
        self.img.layer.cornerRadius = 12
        self.img.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        name.isHidden = false
        name.textColor = Theme.blacktext.color
        img.layer.cornerRadius = 12
        img.layer.borderWidth = 1
        img.layer.borderColor = Theme.gray.color.cgColor
    }
    
    private func updateUI() {
        guard let wineInfo = wineInfo else {
            return
        }
        img.isHidden = false
        img.image = wineInfo.img
        img.contentMode = .scaleAspectFit
        name.text = wineInfo.korName
    }
    
    internal func setMoreView(_ cnt: Int) {
        labelMore.isHidden = false
        labelMore.backgroundColor = Theme.black.color.withAlphaComponent(0.5)
        labelMore.layer.cornerRadius = 12
        labelMore.clipsToBounds = true
        labelMore.font = UIFont.boldSystemFont(ofSize: 11)
        labelMore.textColor = .white
        labelMore.numberOfLines = 0
        labelMore.text = "더보기\n" + "+ \(cnt)"
    }
}
