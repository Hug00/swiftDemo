//
//  ViewController.swift
//  swiftDemo
//
//  Created by 张剑 on 14-10-8.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    var dataSource = ["      本示例为讯飞语音iPhone平台开发者提供语音听写，语音识别（包括命令词和语法文件识别）和语音合成代码样例，旨在让用户能够依据该示例快速开发出基于语音接口的应用程序。","语音听写示例","语音识别示例","语音合成示例"];
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title="语音示例"
        
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: "reloadDataSource", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        reloadDataSource()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let businessItem = dataSource[indexPath.row] as String
        cell.textLabel?.text = businessItem as String
        if(indexPath.row==0){
            cell.textLabel?.numberOfLines=10
        }
        return cell
    }
    
    override func tableView(tableView: UITableView?, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row==0){
            return 240
        }
        return 80 
    }
    
    //选择一行
    override func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row=indexPath.row as Int
        var identifier:String=""
        var _:UIViewController;
        if(row==1){//iat
            identifier="IATViewController"
        }
        else if(row==2){
            identifier="ASRViewController"
        }
        else if(row==3){
            identifier="TTSViewController"
        }
        else{
            return
        }
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier(identifier) as UIViewController!, animated: true)

    }
    
    //MARK: - datasource
    func reloadDataSource() {
        if (self.refreshControl != nil) {
            self.refreshControl?.beginRefreshing()
        }
        
        //do sth to get new data
        
        self.tableView.reloadData()
        
        if (self.refreshControl != nil) {
             self.refreshControl?.endRefreshing()
        }
       
    }
    
    //MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    }

}

