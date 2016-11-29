//
//  IflytekPopupView.swift
//  swiftDemo
//
//  Created by 张剑 on 14-10-9.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

import UIKit

class IflytekPopupView:UIView {
    
    var _textLabel:UILabel=UILabel(frame: CGRectMake(0, 10, 100, 10));
    var _queueCount:Int=0;
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
        
        self._queueCount = 0;
    }
    
    //MARK: -
    
    func setText(text:String){
        
        _textLabel.frame = CGRectMake(0, 10, 100, 10);
        _queueCount += 1;
        alpha = 1.0;
        _textLabel.text = text;
        _textLabel.sizeToFit();
        var frame:CGRect = CGRectMake(5, 0, _textLabel.frame.size.width, _textLabel.frame.size.height);
        _textLabel.frame = frame;
        _textLabel.frame = CGRectMake(_textLabel.frame.origin.x, _textLabel.frame.origin.y+10, _textLabel.frame.size.width, _textLabel.frame.size.height);
        frame =  CGRectMake((_parentView.frame.size.width - frame.size.width)/2, self.frame.origin.y, _textLabel.frame.size.width+10, _textLabel.frame.size.height+20);
        self.frame = frame;
        UIView.animateWithDuration(3.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations:
            {
                self.alpha = 0.0;
            }
            , completion:
            {
            (completion) in
                if (self._queueCount == 1) {
                    self.removeFromSuperview();
                }
                self._queueCount-=1;
            }
        )
        
    }
}