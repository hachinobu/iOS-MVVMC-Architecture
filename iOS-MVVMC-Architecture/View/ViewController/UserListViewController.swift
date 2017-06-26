//
//  UserListViewController.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class UserListViewController: UIViewController, UserListViewProtocol {
    
    fileprivate let selectedUserObserver = PublishSubject<String>()
    lazy var selectedUser: Observable<String> = {
        return self.selectedUserObserver.asObservable()
    }()
    var viewModel: UserListViewModelProtocol!
    
    fileprivate lazy var loadingIndicatorView = LoadingIndicatorView.loadView()
    let bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var reachedBottom: ControlEvent<Void> = {
        return self.tableView.rx.reachedBottom
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.bindReachedBottom(reachedBottom: tableView.rx.reachedBottom.asDriver())
        bindTimeLineFetch()
        bindTableView()
    }

}

extension UserListViewController {
    
    fileprivate func setupUI() {
        //TableView Setting
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.tableFooterView = loadingIndicatorView
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(withType: UserListCell.self)
    }
    
    fileprivate func bindTimeLineFetch() {
        
        viewModel.error
            .drive(onNext: { error in
                print(error)
            }).addDisposableTo(bag)
        
    }
    
    fileprivate func bindTableView() {
        
        viewModel.loadingIndicatorAnimation
            .drive(loadingIndicatorView.indicator.rx.isAnimating)
            .addDisposableTo(bag)
        
        viewModel.loadingIndicatorAnimation.map { !$0 }
            .drive(loadingIndicatorView.indicator.rx.isHidden)
            .addDisposableTo(bag)
        
        //TableViewCellのBind
        viewModel.users.drive(tableView.rx.items(cellIdentifier: UserListCell.nibName, cellType: UserListCell.self)) { row, cellViewModel, cell in
            
            cellViewModel.userName.bind(to: cell.userNameLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.screenName.bind(to: cell.screenNameLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.description.bind(to: cell.descriptionLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.profileURL
                .filter { $0 != nil }
                .subscribe(onNext: { [weak cell] url in
                    
                    let imageURL = url!
                    let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                    cell?.iconImageView.kf.indicatorType = .activity
                    cell?.iconImageView.kf.setImage(with: resource, placeholder: nil,
                                                    options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                    progressBlock: nil, completionHandler: nil)
                    
                }).addDisposableTo(cell.bag)
            
        }.addDisposableTo(bag)
        
        tableView.rx.modelSelected(UserListCellViewModelProtocol.self).do(onNext: { [weak self] _ in
            if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }).map { $0.userId.description }.bind(to: selectedUserObserver).addDisposableTo(bag)
        
    }
    
}
