//
//  ViewController.swift
//  SwiftEmptyDataSet
//
//  Created by 张行 on 16/8/11.
//  Copyright © 2016年 张行. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var tableView:UITableView = UITableView(frame: CGRectZero, style: .Plain)

    var dataSetMangers:[SwiftEmptyDataSetManger] = [SwiftEmptyDataSetManger]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSetMangers.append(SwiftEmptyDataSetManger(title: "Adress Demo", text: "Shipping adress cannot be empty.\nPlease add this infomation", image: UIImage(named: "address_empty")!, buttonTitle: "Add a New Adress"))

        self.dataSetMangers.append(SwiftEmptyDataSetManger(title: "Cart Demo", text: "Your Shopping Bag is Empty", image: UIImage(named: "bag_empty")!, buttonTitle: "Add Cart"))

        self.dataSetMangers.append(SwiftEmptyDataSetManger(title: "Favorites Demo", text: "You have no Favorites Now.", image: UIImage(named: "favorite")!, buttonTitle: "Add Favorites"))

        self.dataSetMangers.append(SwiftEmptyDataSetManger(title: "Items Demo", text: "No Items", image: UIImage(named: "no_item")!, buttonTitle: nil))

        self.dataSetMangers.append(SwiftEmptyDataSetManger(title: "Order Demo", text: "You have no Order yet.", image: UIImage(named: "order")!, buttonTitle: nil))

        self.dataSetMangers.append(SwiftEmptyDataSetManger(title: "Question Demo", text: "Ask a question about this product", image: UIImage(named: "question")!, buttonTitle: "Ask Question"))
        self.dataSetMangers.append(SwiftEmptyDataSetManger(title: "Reviews Demo", text: "This product has no reviews yet.", image: UIImage(named: "no_review")!, buttonTitle: nil))
        self.dataSetMangers.append(SwiftEmptyDataSetManger(title: "Search Demo", text: "We Couldn't Find Anything Matching Your Search.", image: UIImage(named: "search")!, buttonTitle: nil))
        self.dataSetMangers.append(SwiftEmptyDataSetManger(title: "Vedio Demo", text: "Post a video a video to get more GB points", image: UIImage(named: "vedio")!, buttonTitle: nil))



        self.tableView = UITableView(frame: CGRectZero, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(EdgeInsetsZero)
        }
        self.title = "Demo List"
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.textLabel?.text = self.dataSetMangers[indexPath.row].title
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSetMangers.count;
    }

    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = DetailViewController()
        detail.manger = self.dataSetMangers[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }

}

class SwiftEmptyDataSetManger {
    var title:String
    var text:String
    var image:UIImage
    var buttonTitle:String?
    init(title:String, text:String, image:UIImage, buttonTitle:String?) {
        self.text = text
        self.image = image
        self.buttonTitle = buttonTitle
        self.title = title
    }
}

