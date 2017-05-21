//
//  TweetDetailViewController.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/21.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TweetDetailViewController: UIViewController {

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vm = TweetDetailViewModel(viewWillAppear: rx.viewWillAppear.asDriver())
        vm.tweet.drive(onNext: { (tweet) in
            print(tweet!)
        }).addDisposableTo(bag)
        
    }

}
