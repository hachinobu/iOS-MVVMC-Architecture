//
//  HomeTimeLineViewController.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeTimeLineViewController: UIViewController, TimeLineViewProtocol, ViewLifeCycle {
    
    let bag = DisposeBag()
    var viewModel: TimeLineViewModel!
    
    private var selectedItemObserver = PublishSubject<Tweet>()
    lazy var selectedItem: Observable<Tweet> = {
        return self.selectedItemObserver.asObservable()
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        //TableView Setting
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(withType: TimeLineTweetCell.self)
        
        //TableViewCellのBind
        viewModel.tweets.drive(tableView.rx.items) { [weak self] _, row, element in
            guard let weakSelf = self else { return UITableViewCell() }
            let cell = weakSelf.tableView.dequeueReusableCell(forIndexPath: IndexPath(row: row, section: 0)) as TimeLineTweetCell
            return cell
        }.addDisposableTo(bag)
        
        //TableViewCellタップ時に対象のTweetを知らせる
        tableView.rx.modelSelected(Tweet.self).asDriver()
            .drive(selectedItemObserver)
            .addDisposableTo(bag)
        
//        tableView.rx.itemSelected.asDriver()
//            .withLatestFrom(viewModel.tweets) { (indexPath, tweets) -> Tweet in
//                return tweets[indexPath.row]
//            }.drive(selectedItemObserver)
//            .addDisposableTo(bag)
        
        
    }
    
}
