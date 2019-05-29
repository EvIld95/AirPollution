//
//  RegistrationViewModel.swift
//  Sapiens
//
//  Created by Paweł Szudrowicz on 07/05/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import Action

class RegistrationViewModel: ViewModelType {
    var input: RegistrationViewModel.Input
    var output: RegistrationViewModel.Output

    struct Input {
        let email = BehaviorRelay<String>(value: "")
        let password = BehaviorRelay<String>(value: "")
    }
    
    struct Output {
        let valid: Observable<Bool>
    }
    
    lazy var actionRegister: Action<Void, Void> = Action<Void, Void>(workFactory: { input in
        return Observable.create({ (observer) -> Disposable in
            Auth.auth().createUser(withEmail: self.input.email.value, password: self.input.password.value) { authResult, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(Void())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    })
    
    lazy var actionLogin: Action<Void, Void> = Action<Void, Void>(workFactory: { input in
        return Observable.create({ (observer) -> Disposable in
            Auth.auth().signIn(withEmail: self.input.email.value, password: self.input.password.value, completion: { (result, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(Void())
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    })
    
    init() {
        self.input = Input()
        let valid =  Observable.combineLatest(self.input.email.asObservable(), self.input.password.asObservable()) { (usrname, pass) -> Bool in
            return usrname.contains("@") && pass.count > 5
        }.distinctUntilChanged()
        self.output = Output(valid: valid)
    }
}
