//
//  SwiftHUD.swift
//  SwiftHUD
//
//  Created by 张行 on 16/8/9.
//  Copyright © 2016年 张行. All rights reserved.
//

import Foundation
import SnapKit

private let MaxHUDWidth:CGFloat = UIScreen.mainScreen().bounds.size.width - 40

public typealias SwiftHUDComplete = (hud:SwiftHUD) -> Void

public enum SwiftHUDStyle {
    case None
    case Info
    case Success
    case Error
    case Loading
}

private var hud:SwiftHUD?

public class SwiftHUD {

    public var hudBackgroundView:UIView{ get{return self._hudBackgroundView} }

    private(set) var _hudBackgroundView:UIView

    public var loadingView:UIActivityIndicatorView?{ get{return self._loadingView!} }

    private(set) var _loadingView:UIActivityIndicatorView?

    public var iconImageView:UIImageView?{ get{return self._iconImageView!} }

    private(set) var _iconImageView:UIImageView?

    public var titleLabel:UILabel{ get{return _titleLabel} }

    private(set) var _titleLabel:UILabel

    private var style:SwiftHUDStyle = SwiftHUDStyle.None

    public class func show() -> SwiftHUD {
        return self.show("Loading...")
    }

    public class func show(text:String) -> SwiftHUD {
        let view:UIView? = UIApplication.sharedApplication().keyWindow?.rootViewController?.view
        assert(view != nil, "must init window rootViewController")
        return self.show(text, view: view!)
    }

    public class func show(text:String, view:UIView) ->SwiftHUD {
        return self.show(text, view: view, style: SwiftHUDStyle.None)
    }

    public class func show(text:String, view:UIView, style:SwiftHUDStyle) -> SwiftHUD {
        return self.show(text, view: view, style: style, after: 0)
    }

    public class func show(text:String, view:UIView, style:SwiftHUDStyle, after:NSTimeInterval) -> SwiftHUD {
        return self.show(text, view: view, style: style, after: after, complete: nil)
    }

    public class func show(text:String, view:UIView, style:SwiftHUDStyle, after:NSTimeInterval, complete:SwiftHUDComplete?) -> SwiftHUD {
        let hud:SwiftHUD = SwiftHUD(text: text, view: view, style: style, after: after, complete: complete)
        return hud
    }

    public func hide() {
        self.hide("")
    }

    public func hide(text:String) {
        self.hide(text, after: 1.5)
    }

    public func hide(text:String , after:NSTimeInterval) {
        self.hide(text, after: after, complete: nil)
    }

    public func hide(text:String , after:NSTimeInterval, complete:SwiftHUDComplete?) {
        if text == "" {
            self.hudBackgroundView.removeFromSuperview()
            return
        }
        self.titleLabel.text = text
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(after * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.hudBackgroundView.removeFromSuperview()
            if complete != nil {
                complete!(hud: self)
            }
        })

    }

    required public init(text:String, view:UIView, style:SwiftHUDStyle, after:NSTimeInterval, complete:SwiftHUDComplete?) {

        if hud != nil && hud!.hudBackgroundView.superview != nil {
            hud!.hudBackgroundView.removeFromSuperview()
        }

        self._hudBackgroundView = UIView()
        self._titleLabel = UILabel()
        self.initHudBackgroundView()
        self.initTitleLabel()
        self._titleLabel.text = text

        switch style {
            case .None:
                self.settingNoneStyle()
            case .Info,.Error,.Success:
                self._iconImageView = UIImageView()
                self.style = style
                self.initIconImageView()
                self.settingInfoStyle(self.iconImageView!)
            case .Loading:
                self._loadingView = UIActivityIndicatorView(activityIndicatorStyle: .White)
                self.initLoadingView()
                self.loadingView!.startAnimating()
                self.settingInfoStyle(self.loadingView!)
        }
        view.addSubview(self.hudBackgroundView)
        self.hudBackgroundView.snp_makeConstraints { (make) in
            make.center.equalTo(view)
        }
        if after > 0 {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(after * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.hide()
                if complete != nil {
                    complete!(hud: self)
                }
            })
        }

        hud = self
    }

    private func settingNoneStyle() {

        self.hudBackgroundView.addSubview(self.titleLabel)

        self.titleLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(EdgeInsets(top: 10, left: 10, bottom: -10, right: -10))
            make.width.lessThanOrEqualTo(MaxHUDWidth - 20)
        }
    }

    private func settingInfoStyle(view:UIView) {
        self.hudBackgroundView.addSubview(view)
        self.hudBackgroundView.addSubview(self.titleLabel)

        view.snp_makeConstraints { (make) in
            make.top.equalTo(self.hudBackgroundView).offset(10)
            make.size.equalTo(CGSizeMake(30, 30))
            make.centerX.equalTo(self.hudBackgroundView)
        }

        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_bottom).offset(10)
            make.left.equalTo(self.hudBackgroundView).offset(10)
            make.right.equalTo(self.hudBackgroundView).offset(-10)
            make.bottom.equalTo(self.hudBackgroundView).offset(-10)
            make.width.lessThanOrEqualTo(MaxHUDWidth - 20)
        }
    }


    private func imageWithStyle(style:SwiftHUDStyle) -> UIImage? {
        switch style {
        case .Error:
            return UIImage(named: "swift_alert_hud_error")
        case .Info:
            return UIImage(named: "swift_alert_hud_info")
        case .Success:
            return UIImage(named: "swift_alert_hud_success")
        case .None,.Loading:
            return nil
        }

    }
    private func initHudBackgroundView() {
        self._hudBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self._hudBackgroundView.layer.masksToBounds = true
        self._hudBackgroundView.layer.cornerRadius = 5
    }

    private func initLoadingView() {
        self._loadingView!.hidesWhenStopped = true
    }

    private func initIconImageView() {
        self._iconImageView!.image = self.imageWithStyle(self.style)
    }

    private func initTitleLabel() {
        self._titleLabel.numberOfLines = 0
        self._titleLabel.font = UIFont.systemFontOfSize(13)
        self._titleLabel.lineBreakMode = .ByTruncatingTail
        self._titleLabel.textColor = UIColor.whiteColor()
        self._titleLabel.textAlignment = .Center
    }
}