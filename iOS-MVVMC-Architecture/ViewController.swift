//
//  ViewController.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import Accounts
import Action
import RxCocoa

class ViewController: UIViewController {

    private let bag = DisposeBag()
    var viewModel: HomeTimeLineViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel = HomeTimeLineViewModel(viewWillAppear: rx.viewWillAppear.asDriver())
        
        viewModel.authError
            .filter { $0 != nil }
            .drive(onNext: { error in
                print(error!)
            }).addDisposableTo(bag)
        
        viewModel.authStatus
            .filter { $0.noAccount() }
            .drive(onNext: { _ in
                print("userがいない")
            }).addDisposableTo(bag)
        
        viewModel.authAccount
            .drive(onNext: { (account) in
                print(account)
            }).addDisposableTo(bag)
        
        
        viewModel.tweets.drive(onNext: { (tweets) in
            print(tweets.count)
        }).addDisposableTo(bag)
        
//        viewModel.error.withLatestFrom(viewModel.authError) { (e, ae) in
//            
//        }
        
        viewModel.error.drive(onNext: { (e) in
            print(e)
        }).addDisposableTo(bag)
        
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = .blue
        view.addSubview(btn)
        btn.rx.tap.subscribe { _ in
//            viewModel.fetchActionTrigger.onNext(1)
        }.addDisposableTo(bag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

