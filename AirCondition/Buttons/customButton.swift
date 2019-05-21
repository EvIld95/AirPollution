//
//  customButton.swift
//  Sapiens
//
//  Created by Paweł Szudrowicz on 07/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit

class customButton: UIButton {

    let customimageView: UIImageView
    
    init(imageView: UIImageView) {
        self.customimageView = imageView
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
