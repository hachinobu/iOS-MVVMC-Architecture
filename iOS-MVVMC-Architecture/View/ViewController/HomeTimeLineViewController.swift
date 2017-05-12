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

    var viewModel: HomeTimeLineViewModel!
    
    private var selectedItemObserver = PublishSubject<String>()
    lazy var selectedItem: Observable<String> = {
        return self.selectedItemObserver.asObservable()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
