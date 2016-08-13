//
//  SwiftEmptyDataSetDefaultView.swift
//  SwiftEmptyDataSet
//
//  Created by 张行 on 16/8/12.
//  Copyright © 2016年 张行. All rights reserved.
//

import UIKit
import SnapKit

@objc public enum SwiftEmptyDataSetDefaultViewType:Int {
    case Retry
    case Other
}

@objc public  protocol SwiftEmptyDataSetDefaultViewDelegate:NSObjectProtocol {
     func swiftEmptyDataSetDefaultViewButtonClick(type:SwiftEmptyDataSetDefaultViewType);
}



private let KSwiftEmptyDataSetDefaultRetry = "Retry"

public class SwiftEmptyDataSetDefaultView:UIView {
    internal var text:String
    internal var image:UIImage
    internal var buttonTitle:String
    internal var delegate:SwiftEmptyDataSetDefaultViewDelegate?

    internal private(set) var emptyTextLabel:UILabel?
    internal private(set) var iconImageView:UIImageView?
    internal private(set) var button:UIButton?
    internal private(set) var contentView:UIView?

    public init(text:String, image:UIImage, buttonTitle:String = KSwiftEmptyDataSetDefaultRetry, frame:CGRect = CGRectZero) {
        self.text = text
        self.image = image
        self.buttonTitle = buttonTitle
        super.init(frame: frame)
        self.initTextLabel()
        self.initIconImageView()
        self.initButton()
        self.initContentView()
        self.initView()
        self.initLayout()
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buttonClick()  {
        var type:SwiftEmptyDataSetDefaultViewType = .Other
        if self.buttonTitle == KSwiftEmptyDataSetDefaultRetry {
            type = .Retry
        }
        if self.delegate != nil && self.delegate!.respondsToSelector(#selector(SwiftEmptyDataSetDefaultViewDelegate.swiftEmptyDataSetDefaultViewButtonClick(_:))) {
            self.delegate!.swiftEmptyDataSetDefaultViewButtonClick(type)
        }

    }

    func initView()  {
        self.addSubview(self.contentView!)
        self.contentView?.addSubview(self.iconImageView!)
        self.contentView?.addSubview(self.emptyTextLabel!)
        self.contentView?.addSubview(self.button!)
    }

    func initLayout()  {
        self.contentView?.snp_makeConstraints(closure: { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.iconImageView!)
            make.bottom.equalTo(self.button!)
            make.center.equalTo(self)
        })

        self.iconImageView?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.contentView!)
            make.centerX.equalTo(self.contentView!)
            make.size.equalTo(CGSizeMake(200, 150))
        })

        self.emptyTextLabel?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.contentView!).offset(20)
            make.right.equalTo(self.contentView!).offset(-20)
            make.top.equalTo(self.iconImageView!.snp_bottom).offset(20)
        })

        self.button?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.emptyTextLabel!.snp_bottom).offset(20)
            make.centerX.equalTo(self.contentView!)
            make.size.equalTo(CGSizeMake(200, 40))
//            make.bottom.equalTo(self.contentView!)
        })
    }

    private func initTextLabel() {
        self.emptyTextLabel = UILabel(frame: CGRectZero)
        self.emptyTextLabel?.numberOfLines = 0
        self.emptyTextLabel?.textAlignment = .Center
        self.emptyTextLabel?.lineBreakMode = .ByTruncatingTail
        self.emptyTextLabel?.textColor = UIColor.lightGrayColor()
        self.emptyTextLabel?.text = self.text
    }

    private func initIconImageView() {
        self.iconImageView = UIImageView(frame: CGRectZero)
        self.iconImageView?.image = self.image
        self.iconImageView?.contentMode = .ScaleAspectFit
    }

    private func initButton() {
        self.button = UIButton(type: .Custom)
        self.button?.backgroundColor = UIColor(red: 1, green: 0.506, blue: 0.267, alpha: 1)
        self.button?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.button?.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.button?.addTarget(self, action:#selector(self.buttonClick), forControlEvents: .TouchUpInside)
        self.button?.setTitle(self.buttonTitle, forState: .Normal)
        self.button?.layer.masksToBounds = true
        self.button?.layer.cornerRadius = 5
    }

    private func initContentView() {
        self.contentView = UIView(frame: CGRectZero)
    }


}