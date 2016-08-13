//
//  SwiftEmptyDataSet.swift
//  SwiftEmptyDataSet
//
//  Created by 张行 on 16/8/11.
//  Copyright © 2016年 张行. All rights reserved.
//

import UIKit
import SnapKit

public enum  SwiftEmptyDataSetStyle{
    case Default
}

public protocol SwiftEmptyDataSetDataSource {
    func swiftEmptyDataSetView(tableView:UITableView) -> UIView?
}

@objc public protocol SwiftEmptyDataSetDelegete:NSObjectProtocol{
   optional func swiftEmptyDataSetDefaultViewButtonClick(type:SwiftEmptyDataSetDefaultViewType);
}



private var KEmptyDataDataSource:Void?
private var KEmptyDataDelegate:Void?

extension UIScrollView {
    public override class func initialize() {
            struct SwiftEmptyDataOnce {
                static var once:dispatch_once_t = 0
            }

            dispatch_once(&SwiftEmptyDataOnce.once){
                EmptyDataExchangeMethod("reloadData", selectTwo: "emptyDataReloadData", className: UITableView.self)
            }
        }
}

extension UITableView:SwiftEmptyDataSetDefaultViewDelegate{
    private struct EmptyDataPropertyKey {
        static var emptyDataDataSourceKey = "emptyDataDataSourceKey"
        static var emptyDelegateKey = "emptyDelegateKey"
        static var emptyDataSetViewKey = "emptyDataSetViewKey"
    }

    internal var emptyDataDataSource:SwiftEmptyDataSetDataSource? {
        get {
            return objc_getAssociatedObject(self, &EmptyDataPropertyKey.emptyDataDataSourceKey) as? SwiftEmptyDataSetDataSource
        }set(dataSource){
            if let dataSource:AnyObject = dataSource as? AnyObject {
                objc_setAssociatedObject(self, &EmptyDataPropertyKey.emptyDataDataSourceKey, dataSource, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }


    internal var emptyDataDelegate:SwiftEmptyDataSetDelegete? {
        get {
            return objc_getAssociatedObject(self, &EmptyDataPropertyKey.emptyDelegateKey) as? SwiftEmptyDataSetDelegete
        }set(delegate){
            if let delegate:AnyObject = delegate as? AnyObject {
                objc_setAssociatedObject(self, &EmptyDataPropertyKey.emptyDelegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    private var emptyDataSetView:UIView? {
        get {
            return objc_getAssociatedObject(self, &EmptyDataPropertyKey.emptyDataSetViewKey) as? UIView
        }set(emptyDataSetView) {
            if let emptyDataSetView:AnyObject = emptyDataSetView as? AnyObject {
                objc_setAssociatedObject(self, &EmptyDataPropertyKey.emptyDataSetViewKey, emptyDataSetView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    public func emptyDataSetView(style:SwiftEmptyDataSetStyle,text:String,image:UIImage,buttonTitle:String?) ->UIView? {
        switch style {
        case .Default:
            var view:SwiftEmptyDataSetDefaultView
            if buttonTitle != nil {
                view = SwiftEmptyDataSetDefaultView(text: text, image: image, buttonTitle: buttonTitle!, frame: CGRectZero)
            }else {
                view = SwiftEmptyDataSetDefaultView(text: text, image: image)
            }
            view.delegate = self
            return view
        }
    }

    //MARK - SwiftEmptyDataSetDefaultViewDelegate
    public func swiftEmptyDataSetDefaultViewButtonClick(type:SwiftEmptyDataSetDefaultViewType) {
        if self.emptyDataDelegate != nil && self.emptyDataDelegate!.respondsToSelector(#selector(SwiftEmptyDataSetDefaultViewDelegate.swiftEmptyDataSetDefaultViewButtonClick(_:))) {
            self.emptyDataDelegate!.swiftEmptyDataSetDefaultViewButtonClick!(type)
        }
    }
    func emptyDataReloadData() {

        if self.emptyDataDataSource == nil {
            self.emptyDataReloadData()
            return
        }
        guard let tableviewDataSource:UITableViewDataSource = self.dataSource! else {
            return
        }
        var sectionNumber = 0
        if tableviewDataSource.respondsToSelector(#selector(UITableViewDataSource.numberOfSectionsInTableView(_:))) {
            sectionNumber = tableviewDataSource.numberOfSectionsInTableView!(self)
        }else {
            sectionNumber = 1
        }

        var rowCount = 0
        for index in 0 ..< sectionNumber {
            rowCount += tableviewDataSource.tableView(self, numberOfRowsInSection: index)
        }

        if rowCount == 0 {
            // no data
            guard let emptyDataDataSource:SwiftEmptyDataSetDataSource = self.emptyDataDataSource! else {
                return
            }
            if self.emptyDataSetView != nil {
                self.emptyDataSetView!.removeFromSuperview()
            }
            self.emptyDataSetView = emptyDataDataSource.swiftEmptyDataSetView(self)
            guard let emptyDataSetView:UIView = self.emptyDataSetView else {
                return
            }
            self.scrollEnabled = false;
            self.addSubview(emptyDataSetView)
            emptyDataSetView.frame = self.bounds
        }else {
            if self.emptyDataSetView != nil {
                self.emptyDataSetView!.removeFromSuperview()
                self.scrollEnabled = true
            }
            self.emptyDataReloadData()
        }


    }


}

public func EmptyDataExchangeMethod(selectOne:String,selectTwo:String,className:AnyClass!) {
    let select1 = Selector(selectOne)
    let select2 = Selector(selectTwo)
    let select1Method = class_getInstanceMethod(className, select1)
    let select2Method = class_getInstanceMethod(className, select2)

    let didAddMethod = class_addMethod(className, select1, method_getImplementation(select2Method), method_getTypeEncoding(select2Method))

    if didAddMethod {
        class_replaceMethod(className, select2, method_getImplementation(select1Method), method_getTypeEncoding(select1Method))
    }else {
        method_exchangeImplementations(select1Method, select2Method)
    }
}