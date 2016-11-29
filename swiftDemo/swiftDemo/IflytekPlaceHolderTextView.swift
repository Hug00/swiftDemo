//
//  IflytekPlaceHolderTextView.swift
//  swiftDemo
//
//  Created by 张剑 on 14-10-9.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

import UIKit

class IflytekPlaceHolderTextView:UITextView{
    
    
    var _placeholder:String="";
    var _placeholderColor:UIColor=UIColor.lightGrayColor();
    var _placeHolderLabel:UILabel=UILabel();
    
    override var text: String!{
        get{
            return super.text
        }
        set{
            super.text=text;
            self.textChanged(NSNotification(name:UITextViewTextDidChangeNotification, object: nil));
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer? ) {
        
        super.init(frame:frame, textContainer:textContainer);
        
        self._placeholder="";
        self._placeholderColor=UIColor.lightGrayColor();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: nil)
    }

    
    override func awakeFromNib() {

        super.awakeFromNib();
        
        // Use Interface Builder User Defined Runtime Attributes to set
        // placeholder and placeholderColor in Interface Builder.
        if (!self._placeholder.isEmpty) {
            self._placeholder="";
        }
        
        if (!self._placeholderColor.isEqual(UIColor.lightGrayColor())) {
            self._placeholderColor=UIColor.lightGrayColor();
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    override  func drawRect(rect: CGRect) {

        if(!self._placeholder.isEmpty ){
                _placeHolderLabel.frame = CGRectMake(8,8,self.bounds.size.width - 16,0);
                _placeHolderLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping;
                _placeHolderLabel.numberOfLines = 0;
                _placeHolderLabel.font = self.font;
                _placeHolderLabel.backgroundColor = UIColor.clearColor();
                _placeHolderLabel.textColor = self._placeholderColor;
                _placeHolderLabel.alpha = 0;
                _placeHolderLabel.tag = 999;
                self.addSubview(_placeHolderLabel);
            
                _placeHolderLabel.text = self._placeholder;
                _placeHolderLabel.sizeToFit();
                self.sendSubviewToBack(_placeHolderLabel);
            }
        
        if(self.text.isEmpty && !self._placeholder.isEmpty ){
            self.viewWithTag(999)
            self.alpha=1;
        }
        
        super.drawRect(rect);
    }
    
    //MARK: -
    
    func textChanged(notification:NSNotification){
        if(self._placeholder.isEmpty){
            return;
        }
        
        if(self.text.isEmpty){
            self.viewWithTag(999)
            self.alpha=1;
        }
        else{
            self.viewWithTag(999)
            self.alpha=0;
        }
    }
}


