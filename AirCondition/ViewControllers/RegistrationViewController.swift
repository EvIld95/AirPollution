//
//  RegistrationViewController.swift
//  Sapiens
//
//  Created by Paweł Szudrowicz on 26/03/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController {
    var viewModel: RegistrationViewModel!
    var appManager: AppManager!
    
    let logoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Air", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.imageView?.contentMode = .scaleAspectFill
        button.titleLabel?.font = UIFont(name: "Futura", size: 60)
        button.clipsToBounds = false
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have account? ", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light), .foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "Register here!", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold), .foregroundColor: UIColor.black]))
        button.setAttributedTitle(attributedText, for: .normal)
        button.titleLabel!.textAlignment = .center
        button.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleDontHaveAccount() {
        UIView.transition(with: self.registerButton, duration: 0.5, options: .transitionFlipFromTop, animations: {
            if self.registerButton.currentTitle == "Login" {
                self.registerButton.setTitle("Register", for: .normal)
            } else {
                self.registerButton.setTitle("Login", for: .normal)
            }
        }, completion: nil)
        
        UIView.transition(with: self.dontHaveAccountButton, duration: 0.5, options: .curveEaseIn, animations: {
            var firstPart = ""
            var secondPart = ""
            if self.registerButton.currentTitle == "Login" {
                firstPart = "Don't have account? "
                secondPart = "Register here!"
            } else {
                firstPart = "Already have account? "
                secondPart = "Login here!"
            }
            let attributedText = NSMutableAttributedString(string: firstPart, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light), .foregroundColor: UIColor.black])
            attributedText.append(NSAttributedString(string: secondPart, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold), .foregroundColor: UIColor.black]))
            self.dontHaveAccountButton.setAttributedTitle(attributedText, for: .normal)
        }, completion: nil)
    }
    
    
    let emailTextField: CustomTextField = {
        var textField = CustomTextField(padding: 8, height: 50, image: #imageLiteral(resourceName: "avatar"))
        textField.placeholder = "E-mail address"
        textField.text = "tempMail@gmail.com"
        return textField
    }()
    
    var passwordTextField: CustomTextField = {
        var textField = CustomTextField(padding: 8, height: 50, image: #imageLiteral(resourceName: "lock"))
        textField.placeholder = "Password"
        textField.text = "password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Futura", size: 18)
        button.backgroundColor = .sapiensBorderColor
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Facebook", for: .normal)
        button.setTitleColor(.sapiensBorderColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Futura", size: 18)
        button.backgroundColor = .clear
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 8
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleLoginWithFacebook), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.sapiensBorderColor.cgColor
        
        let iv = UIImageView(image: #imageLiteral(resourceName: "facebook").withRenderingMode(.alwaysOriginal))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        
        button.addSubview(iv)
        iv.anchor(top: nil, leading: button.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: .zero)
        iv.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        iv.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.6).isActive = true
        iv.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.6).isActive = true
        return button
    }()
    
    @objc fileprivate func handleLoginWithFacebook() {
        print("Login With Facebook")
    }
    
    let disposeBag = DisposeBag()
    func setupRx() {
        emailTextField.rx.text.orEmpty.throttle(0.5, scheduler: MainScheduler.instance).bind(to: self.viewModel.input.email).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.throttle(0.5, scheduler: MainScheduler.instance).bind(to: self.viewModel.input.password).disposed(by: disposeBag)
        viewModel.output.valid.bind(to: registerButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
  
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            registerButton,
            facebookButton
            ])
        sv.axis = .vertical
        sv.spacing = 8
        
        let overallSV = UIStackView(arrangedSubviews: [
            sv, dontHaveAccountButton
            ])
        overallSV.axis = .vertical
        overallSV.spacing = 30
        return overallSV
    }()
    
    lazy var overallStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            logoButton,
            verticalStackView
            ])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        return sv
    }()
    
    
    @objc func handleRegister() {
        if self.registerButton.currentTitle == "Login" {
            viewModel.actionLogin.execute(Void())
        } else {
            viewModel.actionRegister.execute(Void())
        }
        
    }
    
    func setupLayout() {
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 50, left: 50, bottom: 50, right: 50))
        
        overallStackView.axis = .vertical
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupRx()
        setupNotificationObservers()
        self.view.setupGradientLayer()
        setupLayout()
        setupTapGesture()
    }
    
    
    
    // handle keyboard dismiss
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        // how to figure out how tall the keyboard actually is
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        // let's try to figure out how tall the gap is from the register button to the bottom of the screen
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        print(bottomSpace)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) // dismisses keyboard
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
