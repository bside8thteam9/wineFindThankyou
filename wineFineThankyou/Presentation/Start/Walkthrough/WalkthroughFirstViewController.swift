//
//  WalkthroughFirstViewController.swift
//
//  Created by suding on 2022/03/01.
//

import UIKit

protocol SelectQuestionProtocol {
     func renewButtons(_ sender: UIButton, btns: [UIButton])
 }

enum WhenDoSelect: String, CaseIterable {
    case cost = "가성비"
    case grape = "포도 품종"
    case brand = "와인 브랜드"
    case loc = "생산 지역"
    case type = "와인 종류 (레드/화이트/내추럴 등)"
    case etc = "기타 (직접 입력)"
    var str: String{
        return self.rawValue
    }
}

class WalkthroughFirstViewController: UIViewController {
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Q. 1"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    lazy var QuestionLabel: UILabel = {
        let label = UILabel()
        label.text =
        """
        와인을 마실 때 나에게
        가장 중요한 것은?
        """
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let stackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.backgroundColor = .white
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    } ()
    
    let cost: UIButton = {
        let button = UIButton()
        button.setTitle(WhenDoSelect.cost.str, for: .normal)
        return button
    }()
    
    let grape: UIButton = {
        let button = UIButton()
        button.setTitle(WhenDoSelect.grape.str, for: .normal)
        return button
    }()
    
    let brand: UIButton = {
        let button = UIButton()
        button.setTitle(WhenDoSelect.brand.str, for: .normal)
        return button
    }()
    
    
    let loc: UIButton = {
        let button = UIButton()
        button.setTitle(WhenDoSelect.loc.str, for: .normal)
        return button
    }()
    
    let type: UIButton = {
        let button = UIButton()
        button.setTitle(WhenDoSelect.type.str, for: .normal)
        return button
    }()
    
    let etc: UIButton = {
        let button = UIButton()
        button.setTitle(WhenDoSelect.etc.str, for: .normal)
        let action = UIAction(handler: { _ in
            let view = QABottomSheet()
            view.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                self.present(view, animated: true)
            }
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    var buttons = [UIButton]()
    internal var delegate: SelectWalkThroughOption?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConfigure()
        setupUI()
    }
    
    private func setupUI() {
        numberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(24)
        }
        
        QuestionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(numberLabel.snp.bottom).offset(28)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(QuestionLabel.snp.bottom).offset(40)
            make.height.equalTo(272)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupConfigure() {
        view.addSubview(numberLabel)
        view.addSubview(QuestionLabel)
        view.addSubview(cost)
        view.addSubview(stackView)
        buttons = [cost, grape,
                   brand, loc,
                   type, etc]
        buttons.forEach { btn in
            stackView.addArrangedSubview(btn)
            btn.titleLabel?.font = .systemFont(ofSize: 15)
            btn.setTitleColor(.black, for: .normal)
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.black.cgColor
            btn.layer.cornerRadius = 20
            btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            btn.addAction(UIAction { _ in
                btn.backgroundColor = .white
                btn.layer.borderColor = UIColor.standardColor.cgColor
                btn.layer.borderWidth = 1.5
                btn.setTitleColor(.standardColor, for: .normal)
                self.selectedBtn(btn)
            }, for: .touchUpInside)
        }
    }
    
    private func selectedBtn(_ btn: UIButton) {
        self.buttons.filter {
            $0 != btn
        }.forEach {
            $0.layer.borderColor = UIColor(rgb: 0xE0E0E0).cgColor
            $0.setTitleColor(UIColor(rgb: 0xbdbdbd), for: .normal)
        }
        guard let btnTxt = btn.titleLabel?.text,
              let select = WhenDoSelect.allCases.first(where: { $0.str == btnTxt})
        else { return }
        
        delegate?.selected(0, select)
    }
}
