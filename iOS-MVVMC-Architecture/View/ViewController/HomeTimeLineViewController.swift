//
//  HomeTimeLineViewController.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class HomeTimeLineViewController: UIViewController, TimeLineViewProtocol {

    let bag = DisposeBag()
    var viewModel: HomeTimeLineViewModel!
    
    private var selectedItemObserver = PublishSubject<String>()
    lazy var selectedItem: Observable<String> = {
        return self.selectedItemObserver.asObservable()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.authStatus
            .drive(onNext: { status in
                print(status)
            }).addDisposableTo(bag)
        
        viewModel.authError
            .filter { $0 != nil }
            .drive(onNext: { authError in
                print(authError!)
            }).addDisposableTo(bag)
        
        viewModel.tweets
            .drive(onNext: { tweets in
                print(tweets.count)
            }).addDisposableTo(bag)
        
        viewModel.error
            .drive(onNext: { error in
                print(error)
            }).addDisposableTo(bag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
