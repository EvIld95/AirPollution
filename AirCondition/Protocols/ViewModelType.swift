//
//  RegistrationViewModelType.swift
//  Sapiens
//
//  Created by Paweł Szudrowicz on 09/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
