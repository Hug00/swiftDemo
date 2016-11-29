//
//  IflytekAlertView.swift
//  swiftDemo
//
//  Created by 张剑 on 14-10-9.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

import UIKit

class IflytekAlertView:UIView {

    var _textLabel:UILabel=UILabel(frame: CGRectMake(0, 10, 100, 10));
    var _queueCount:Int=0;
    var _aiv:UIActivityIndicatorView=UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
    var _parentView:UIView=UIView();
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
       
        super.init(frame:frame)
        
        // add textlabel
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75);
        self.layer.cornerRadius = 5.0;
        self._textLabel.numberOfLines = 0;
        self._textLabel.font = UIFont.systemFontOfSize(17);
        self._textLabel.textColor = UIColor.whiteColor();
        self._textLabel.textAlignment = NSTextAlignment.Center;
        self._textLabel.backgroundColor = UIColor.clearColor();
        self.addSubview(self._textLabel)
        
        // add the activity indicator
        self._aiv.startAnimating();
        self.addSubview(self._aiv);
        self._queueCount = 0;
    }
    
    //MARK: -
    
    func setText(text:String){
        
        _textLabel.frame = CGRectMake(0, 10, 100, 10);
        alpha = 1.0;
        _textLabel.text = text;
        _textLabel.sizeToFit();
        var frame:CGRect = CGRectMake(5, 0, _textLabel.frame.size.width,_textLabel.frame.size.height);
        _textLabel.frame = frame;
        _textLabel.frame = CGRectMake(_textLabel.frame.origin.x+40, _textLabel.frame.origin.y+10, _textLabel.frame.size.width, _textLabel.frame.size.height);
        frame =  CGRectMake((_parentView.frame.size.width - (frame.size.width+10+45))/2, frame.origin.y, _textLabel.frame.size.width+10+45, _textLabel.frame.size.height+20);
        _aiv.center = CGPointMake(25, _textLabel.bounds.size.height);
        self.frame = frame;
    }
    
    func dismissModalView(){
        self.removeFromSuperview();
    }
    
}