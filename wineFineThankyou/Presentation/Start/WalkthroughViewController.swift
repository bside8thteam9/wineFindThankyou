//
//  WalkthroughViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/04/02.
//

import Foundation
import UIKit

protocol AfterWalkthroughAnswer: AnyObject {
    func selected(_ idx: Int, _ str: String?)
}

class WalkthroughViewController: UIViewController {
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var txtFieldEtcetera: UITextField!
    @IBAction private func leftArrowAction(_ sender: UIButton) {
        guard pageControl.currentPage > 0,
            let xPos = self.pageIdx2Xpos[pageControl.currentPage - 1]
        else { return }
        
        self.scrollView.setContentOffset(CGPoint(x: xPos, y: 0), animated: true)
    }
    
    private var question2Answer = [Int: String]()
    private var pageIdx2Xpos = [Int: CGFloat]()
    private var keyboardHeight: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        addContentsToScrollView()
        setPageControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func addContentsToScrollView() {
        QuestionList.allCases.enumerated().forEach { idx, question in
            let walkthroughView = WalkthroughView()
            let xPos = self.view.frame.width * CGFloat(idx)
            walkthroughView.frame = CGRect(x: xPos, y: 0, width: self.view.frame.width, height: scrollView.bounds.height)
            scrollView.addSubview(walkthroughView)
            scrollView.contentSize.width = walkthroughView.frame.width * CGFloat(idx + 1)
            walkthroughView.questionNumber = question.rawValue
            walkthroughView.delegate = self
            walkthroughView.nextBtnClosure = {
                guard let xPos = self.pageIdx2Xpos[idx + 1]
                else { self.goToResult(); return }
                
                self.scrollView.setContentOffset(CGPoint(x: xPos, y: 0), animated: true)
            }
            pageIdx2Xpos[question.rawValue] = xPos
        }
    }
    
    private func setPageControl() {
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray30
        pageControl.preferredIndicatorImage = UIImage(named: "_page_control")
        pageControl.numberOfPages = QuestionList.allCases.count
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        self.keyboardHeight = keyboardHeight
    }
    
    private func goToResult() {
        guard let _ = question2Answer[QuestionList.question0.rawValue],
              let _ = question2Answer[QuestionList.question1.rawValue],
              let _ = question2Answer[QuestionList.question2.rawValue],
              let vc = UIStoryboard(name: StoryBoard.start.name, bundle: nil).instantiateViewController(identifier: WalkthroughResulViewController.identifier) as? WalkthroughResulViewController
        else {
            showAlert()
            return
        }
        
        vc.question2Answer = self.question2Answer
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
        
        func showAlert() {
            let alert = UIAlertController(title: "전체 질문에 답해주세요.",
                                          message: "아직 답변하지 않으신 질문이 있습니다.\n확인 후 다시 시도해주세요.",
                                          preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "확인", style: .default) {_ in
                alert.dismiss(animated: true)
            }
            alert.addAction(okBtn)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
}

extension WalkthroughViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        setPageControlWhenBeSelectedPage(currentPage: Int(round(value)))
    }
    
    private func setPageControlWhenBeSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
}

extension WalkthroughViewController: AfterWalkthroughAnswer{
    func selected(_ idx: Int, _ str: String?) {
        self.question2Answer[idx] = str
    }
}
