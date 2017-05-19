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
import Kingfisher

class HomeTimeLineViewController: UIViewController, TimeLineViewProtocol, ViewLifeCycle {
    
    let bag = DisposeBag()
    var viewModel: TimeLineViewModel!
    
    fileprivate var selectedItemObserver = PublishSubject<String>()
    lazy var selectedItem: Observable<String> = {
        return self.selectedItemObserver.asObservable()
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindAuthStatus()
        bindTimeLineFetch()
        bindTableView()
    }
    
}

extension HomeTimeLineViewController {
    
    fileprivate func setupUI() {
        //TableView Setting
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(withType: TimeLineTweetCell.self)
    }
    
    fileprivate func bindAuthStatus() {
        viewModel.authStatus
            .drive(onNext: { status in
                print(status)
            }).addDisposableTo(bag)
        
        viewModel.authError
            .filter { $0 != nil }
            .drive(onNext: { authError in
                print(authError!)
            }).addDisposableTo(bag)
    }
    
    fileprivate func bindTimeLineFetch() {
        viewModel.tweets
            .drive(onNext: { tweets in
                print(tweets.count)
            }).addDisposableTo(bag)
        
        viewModel.error
            .drive(onNext: { error in
                print(error)
            }).addDisposableTo(bag)
    }
    
    fileprivate func bindTableView() {
        //TableViewCellのBind
        viewModel.tweets.drive(tableView.rx.items) { [weak self] _, row, cellViewModel in
            guard let weakSelf = self else { return UITableViewCell() }
            let cell = weakSelf.tableView.dequeueReusableCell(forIndexPath: IndexPath(row: row, section: 0)) as TimeLineTweetCell
            cellViewModel.userName.asDriver(onErrorJustReturn: nil).drive(cell.userNameLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.screenName.asDriver(onErrorJustReturn: nil).drive(cell.screenNameLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.body.asDriver(onErrorJustReturn: nil).drive(cell.bodyLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.profileURL.asDriver(onErrorJustReturn: nil).filter { $0 != nil }.drive(onNext: { [weak cell] url in
                let imageURL = url!
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                cell?.iconImageView.kf.indicatorType = .activity
                cell?.iconImageView.kf.setImage(with: resource, placeholder: nil, options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly], progressBlock: nil, completionHandler: nil)
            }).addDisposableTo(cell.bag)
            
            return cell
            }.addDisposableTo(bag)
        
        //TableViewCellタップ時に対象のTweetを知らせる
        tableView.rx.modelSelected(TimeLineCellViewModel.self)
            .do(onNext: { [weak self] _ in
                if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                    self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
            }).flatMap { model -> Observable<String?> in
                return model.id
            }.filter { $0 != nil }
            .map { $0! }
            .bind(to: selectedItemObserver)
            .addDisposableTo(bag)
        
        //        tableView.rx.itemSelected.asDriver()
        //            .withLatestFrom(viewModel.tweets) { (indexPath, tweets) -> Tweet in
        //                return tweets[indexPath.row]
        //            }.drive(selectedItemObserver)
        //            .addDisposableTo(bag)
    }
    
    
}



