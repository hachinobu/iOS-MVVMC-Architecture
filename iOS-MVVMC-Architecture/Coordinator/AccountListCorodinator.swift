//
//  AccountListCorodinator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/09.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AccountListCorodinator: Coordinator {

    private var selected: PublishSubject<Void> = PublishSubject()
    lazy var selectedAccount: Driver<Void> = self.selected.asDriver(onErrorJustReturn: ())
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
    }
    
}
