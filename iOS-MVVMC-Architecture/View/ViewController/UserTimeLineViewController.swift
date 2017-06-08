//
//  UserTimeLineViewController.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/06/01.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class UserTimeLineViewController: UIViewController, UserTimeLineViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let bag = DisposeBag()
    var viewModel: UserTimeLineViewModelProtocol!
    
    fileprivate var selectedTweetIdObserver = PublishSubject<String>()
    lazy var selectedTweetId: Observable<String> = {
        return self.selectedTweetIdObserver.asObservable()
    }()
    
    lazy var reachedBottom: ControlEvent<Void> = {
        return self.tableView.rx.reachedBottom
    }()
    
    let userProfileView: UserProfileView = UserProfileView.instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.bindRefresh(refresh: tableView.refreshControl!.rx.controlEvent(.valueChanged).asDriver())
        viewModel.bindReachedBottom(reachedBottom: tableView.rx.reachedBottom.asDriver())
        bindAuthStatus()
        bindTimeLineFetch()
        bindTableView()
    }

}

extension UserTimeLineViewController {
    
    fileprivate func setupUI() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(withType: TimeLineTweetCell.self)
        tableView.tableHeaderView = userProfileView
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
        
        viewModel.userProfileViewModel.drive(onNext: { [weak self] vm in
            guard let weakSelf = self else { return }
            vm.userName.bind(to: weakSelf.userProfileView.userNameLabel.rx.text).addDisposableTo(weakSelf.bag)
            vm.screenName.bind(to: weakSelf.userProfileView.screenNameLabel.rx.text).addDisposableTo(weakSelf.bag)
            vm.description.bind(to: weakSelf.userProfileView.descriptionLabel.rx.text).addDisposableTo(weakSelf.bag)
            vm.followingCount.bind(to: weakSelf.userProfileView.followingLabel.rx.text).addDisposableTo(weakSelf.bag)
            vm.followerCount.bind(to: weakSelf.userProfileView.followerLabel.rx.text).addDisposableTo(weakSelf.bag)
            vm.profileURL.filter { $0 != nil }.subscribe(onNext: { url in
                let imageURL = url!
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                weakSelf.userProfileView.profileIconImageView.kf.indicatorType = .activity
                weakSelf.userProfileView.profileIconImageView.kf.setImage(with: resource, placeholder: nil,
                                                                          options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                                          progressBlock: nil, completionHandler: nil)
                
            }).addDisposableTo(weakSelf.bag)
            
            vm.backgroundImageURL.filter { $0 != nil }.subscribe(onNext: { url in
                let imageURL = url!
                print(imageURL.absoluteString)
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                weakSelf.userProfileView.profileBackgroundImageView.kf.indicatorType = .none
                weakSelf.userProfileView.profileBackgroundImageView.kf.setImage(with: resource, placeholder: nil,
                                                                          options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                                          progressBlock: nil, completionHandler: nil)
            }).addDisposableTo(weakSelf.bag)
            
        }).addDisposableTo(bag)
        
        viewModel.tweets
            .map { _ in false }
            .drive(tableView.refreshControl!.rx.isRefreshing.asObserver())
            .addDisposableTo(bag)
        
        viewModel.loadingIndicatorAnimation
            .drive(loadingIndicator.rx.isAnimating)
            .addDisposableTo(bag)
        
        viewModel.loadingIndicatorAnimation.map { !$0 }
            .drive(loadingIndicator.rx.isHidden)
            .addDisposableTo(bag)
        
        //TableViewCellのBind
        viewModel.tweets.drive(tableView.rx.items) { [weak self] _, row, cellViewModel in
            guard let weakSelf = self else { return UITableViewCell() }
            let cell = weakSelf.tableView.dequeueReusableCell(forIndexPath: IndexPath(row: row, section: 0)) as TimeLineTweetCell
            cellViewModel.userName.bind(to: cell.userNameLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.screenName.bind(to: cell.screenNameLabel.rx.text).addDisposableTo(cell.bag)
            //observeOn(MainScheduler)とかasDeiverして繋ぐと初回のセル表示時にセルの高さが動的にならない。。
            cellViewModel.body.bind(to: cell.bodyLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.profileURL.filter { $0 != nil }.subscribe(onNext: { [weak cell] url in
                let imageURL = url!
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                cell?.iconImageView.kf.indicatorType = .activity
                cell?.iconImageView.kf.setImage(with: resource, placeholder: nil,
                                                options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                progressBlock: nil, completionHandler: nil)
            }).addDisposableTo(cell.bag)
            
            return cell
            }.addDisposableTo(bag)
        
        //TableViewCellタップ時に対象のTweetを知らせる
        tableView.rx.modelSelected(TimeLineCellViewModel.self)
            .do(onNext: { [weak self] _ in
                if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                    self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
            })
            .map { model -> String in
                return model.id.description
            }
            .bind(to: selectedTweetIdObserver)
            .addDisposableTo(bag)
        
    }
    
}
