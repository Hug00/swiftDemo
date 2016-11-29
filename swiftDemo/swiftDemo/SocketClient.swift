//
//  SocketClient.swift
//  swiftDemo
//
//  Created by 黄晋雪 on 4/24/16.
//  Copyright © 2016 iflytek. All rights reserved.
//

import Foundation

class SocketClient {
    
    var socketClient:TCPClient!
    
    func connectServer(){
        //创建socket
        socketClient = TCPClient(addr: "localhost", port: 8888)
        
        //连接
        let (success, errmsg) = socketClient.connect(timeout: 1)
        if success {
            
            let (success, errmsg) = socketClient.send(str:"start")
            if success {
                //读取数据
                let data = socketClient.read(1024*10)
                if let d = data {
                    if let str = String(bytes: d, encoding: NSUTF8StringEncoding){
                        print(str)
                    }
                }
            }else {
                print(errmsg)
            }
        } else {
            print(errmsg)
        }
    }

}