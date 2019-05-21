//
//  CustomTextField.swift
//  Custom
//
//  Created by Paweł Szudrowicz on 26/03/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CustomTextField: UITextField {
    let padding: CGFloat
    let height: CGFloat
    var borderView: UIView
    var iconImageView: UIView
    let imageSize: CGFloat
    var heightConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    init(padding: CGFloat, height: CGFloat, image: UIImage) {
        self.imageSize = height/2
        self.padding = padding
        self.height = height
        self.borderView = UIView(frame: CGRect(x: 0, y: height - 1, width: 50, height: 1))
        self.iconImageView = UIImageView(image: image.withRenderingMode(.alwaysOriginal))
        self.iconImageView.clipsToBounds = true
        self.iconImageView.contentMode = .scaleAspectFit
        super.init(frame: .zero)
       
        backgroundColor = .clear
        borderStyle = .none
        font = UIFont(name: "Futura", size: 18)
        borderView.backgroundColor = UIColor.sapiensBorderColor
        addSubview(borderView)
        addSubview(iconImageView)
        
        self.heightConstraint = borderView.heightAnchor.constraint(equalToConstant: 1)
        self.heightConstraint.isActive = true
        
        self.rx.controlEvent(UIControlEvents.editingDidBegin).asObservable().subscribe(onNext: { [unowned self] (_) in
            self.heightConstraint.constant = 3
            self.layoutIfNeeded()
        }).disposed(by: disposeBag)
        
        self.rx.controlEvent(UIControlEvents.editingDidEnd).asObservable().subscribe(onNext: { [unowned self] (_) in
            self.heightConstraint.constant = 1
            self.layoutIfNeeded()
        }).disposed(by: disposeBag)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderView.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        iconImageView.anchor(top:nil, leading: self.leadingAnchor, bottom: nil, trailing: nil)
        iconImageView.widthAnchor.constraint(equalToConstant: self.imageSize).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: self.imageSize).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding + self.imageSize, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding + self.imageSize, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
