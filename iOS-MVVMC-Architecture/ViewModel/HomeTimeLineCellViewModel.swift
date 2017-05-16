//
//  HomeTimeLineCellViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/16.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class HomeTimeLineCellViewModel: TimeLineCellViewModel {
    
    var userName: PublishSubject<String> = PublishSubject()
    var screenName: PublishSubject<String> = PublishSubject()
    var body: PublishSubject<String> = PublishSubject()
    var profileURL: PublishSubject<URL> = PublishSubject()
    
}
