//
//  UITableViewController+RxExtension.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/22.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    
    var reachedBottom: ControlEvent<Void> {
        
        let lastCellObservable = base.rx.willDisplayCell.filter { [weak base] cell, indexPath -> Bool in
            guard let base = base else { return false }
            let isLastCell = indexPath.row == base.numberOfRows(inSection: indexPath.section) - 1
            return isLastCell
        }.map { _ in }
        
        return ControlEvent(events: lastCellObservable)
    }
    
}
