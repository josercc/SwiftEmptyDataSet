//
//  DetailViewController.swift
//  SwiftEmptyDataSet
//
//  Created by 张行 on 16/8/13.
//  Copyright © 2016年 张行. All rights reserved.
//

import UIKit
import SwiftHUD
class DetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SwiftEmptyDataSetDataSource,SwiftEmptyDataSetDelegete {
    let tableView:UITableView = UITableView(frame: CGRectZero, style: .Plain)

    var manger:SwiftEmptyDataSetManger?
    var titles:[String] = [String]()
    var isError:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.emptyDataDelegate = self
        self.tableView.emptyDataDataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        self.title = self.manger?.title
    }

    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }

    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SwiftHUD.show("Demo Dispaly Over", view: self.view, style: SwiftHUDStyle.Info, after: 3)
    }

    //MARK: - SwiftEmptyDataSetDataSource

    func swiftEmptyDataSetView(tableView:UITableView) -> UIView? {
        if self.isError {
            return tableView.emptyDataSetView(.Default, text: "Request Time Out", image: UIImage(named: "request_out")!, buttonTitle: "Retry")
        }
        return tableView.emptyDataSetView(.Default, text: self.manger!.text, image: self.manger!.image, buttonTitle: self.manger!.buttonTitle);
    }

    //MARK: - SwiftEmptyDataSetDelegete
    func swiftEmptyDataSetDefaultViewButtonClick(type:SwiftEmptyDataSetDefaultViewType) {
        let hud = SwiftHUD.show()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            hud.hide()
            switch type {
            case .Retry:
                self.titles.append(self.manger!.title)
            case .Other:
                self.isError = true
            }

            self.tableView.reloadData()
        })
    }

}
