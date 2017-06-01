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
import Kingfisher

final class TweetDetailViewController: UIViewController, TweetDetailViewProtocol {

    fileprivate let selectedUserObserver = PublishSubject<String>()
    lazy var selectedUser: Observable<String> = {
        return self.selectedUserObserver.asObservable()
    }()
    
    let bag = DisposeBag()
    var viewModel: TweetDetailViewModelProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(withType: TweetDetailCell.self)
        bindTableView()
        
    }

}

extension TweetDetailViewController {
    
    fileprivate func bindTableView() {
        
        viewModel.tweets.drive(tableView.rx.items) { [weak self] _, row, cellViewModel in
            
            guard let weakSelf = self else { return UITableViewCell() }
            let cell = weakSelf.tableView.dequeueReusableCell(forIndexPath: IndexPath(row: row, section: 0)) as TweetDetailCell
            cellViewModel.userName.bind(to: cell.userNameLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.screenName.bind(to: cell.screenNameLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.body.bind(to: cell.bodyLabel.rx.text).addDisposableTo(cell.bag)
            cellViewModel.profileURL.filter { $0 != nil }.subscribe(onNext: { [weak cell] url in
                let imageURL = url!
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                cell?.iconImageView.kf.indicatorType = .activity
                cell?.iconImageView.kf.setImage(with: resource, placeholder: nil,
                                                options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                progressBlock: nil, completionHandler: nil)
            }).addDisposableTo(cell.bag)
            
            cell.iconButton.rx.tap
                .withLatestFrom(cellViewModel.userId) { _, userId -> String in
                    guard let id = userId else {
                        fatalError()
                    }
                    return id
                }
                .bind(to: weakSelf.selectedUserObserver)
                .addDisposableTo(cell.bag)
            
            cellViewModel.statusCount.asDriver(onErrorJustReturn: nil)
                .drive(cell.countLabel.rx.text)
                .addDisposableTo(cell.bag)
            
            return cell
            
        }.addDisposableTo(bag)
        
    }
    
}
