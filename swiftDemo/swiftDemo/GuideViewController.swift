//
//  GuideViewController.swift
//  swiftDemo
//
//  Created by 黄晋雪 on 5/13/16.
//  Copyright © 2016 iflytek. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class GuideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func blue(sender: AnyObject) {
    }
    @IBAction func red(sender: AnyObject) {
    }
    @IBAction func yellow(sender: AnyObject) {
    }
    @IBAction func green(sender: AnyObject) {
    }
    @IBAction func purple(sender: AnyObject) {
    }
    @IBAction func grey(sender: AnyObject) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
