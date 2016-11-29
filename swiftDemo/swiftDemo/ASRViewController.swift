//
//  ASRViewController.swift
//  swiftDemo
//
//  Created by 张剑 on 14-10-8.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

import UIKit

class ASRViewController: UIViewController,IFlySpeechRecognizerDelegate {
    
    // 创建识别对象
    var iflySpeechRecognizer:IFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance() as! IFlySpeechRecognizer;
    // uploader must create here for thread safty. Because all upload tasks must be put into the same NSoperationQueue.
    var uploader:IFlyDataUploader=IFlyDataUploader();
    var grammerId:String="";
    
    @IBOutlet weak var resultTextView: UITextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //创建语音配置
        var initString:String
        initString="appid="+APPID_VALUE+",timeout="+TIMEOUT_VALUE;
        
        //所有服务启动前，需要确保执行createUtility
        IFlySpeechUtility.createUtility(initString);
        
        self.iflySpeechRecognizer.delegate = self;//请不要删除这句,createRecognizer是单例方法，需要重新设置代理
        self.iflySpeechRecognizer.setParameter("asr", forKey: IFlySpeechConstant.IFLY_DOMAIN())
        self.iflySpeechRecognizer.setParameter("16000", forKey: IFlySpeechConstant.SAMPLE_RATE())
        self.iflySpeechRecognizer.setParameter("asr.pcm", forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
        
        // | result_type   | 返回结果的数据格式 plain,只支持plain
        self.iflySpeechRecognizer.setParameter("plain", forKey: IFlySpeechConstant.RESULT_TYPE())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title="语音识别示例"
        
        resultTextView.text = ASR_SAMPLE_TIPINFO;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Button Event
    
    @IBAction func btnUploadGrammarClicked(sender: AnyObject) {
        resultTextView.text = ASR_SAMPLE_TIPINFO;
        self.iflySpeechRecognizer.stopListening();
 
        /*上传abnf语法时，需要上传的参数*/

        self.uploader.setParameter("asr",forKey:"sub");
        self.uploader.setParameter("abnf",forKey:"dtt");
        
        //语法不变，请不要重复上传
        self.uploader.uploadDataWithCompletionHandler({
                (result:String!,error:IFlySpeechError!)->Void in
                self.onUploadFinished(result,error:error)
                self.grammerId=result;
            }, name:"abnf", data:ASR_SAMPLE_ABNFGRAMMAR)
    }
    
    @IBAction func btnStartClicked(sender: AnyObject) {
        self.resultTextView.text=""
        self.iflySpeechRecognizer.setParameter(grammerId, forKey: IFlySpeechConstant.CLOUD_GRAMMAR())
        self.iflySpeechRecognizer.startListening();
    }
    
    @IBAction func btnStopClicked(sender: AnyObject) {
        self.iflySpeechRecognizer.stopListening();
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        self.iflySpeechRecognizer.cancel();
    }
    
    //MARK: - IFlySpeechRecognizerDelegate
    
    /**
    * @fn      onVolumeChanged
    * @brief   音量变化回调
    *
    * @param   volume      -[in] 录音的音量，音量范围1~100
    * @see
    */
    func onVolumeChanged(volume:Int32){
        NSLog("音量：\(volume)")
    }
    
    /**
    * @fn      onBeginOfSpeech
    * @brief   开始识别回调
    *
    * @see
    */
    func onBeginOfSpeech(){
        NSLog("onEndOfSpeech")
    }
    
    /**
    * @fn      onEndOfSpeech
    * @brief   停止录音回调
    *
    * @see
    */
    func onEndOfSpeech(){
        NSLog("onEndOfSpeech")
    }
    
    /**
    * @fn      onError
    * @brief   识别结束回调
    *
    * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
    */
    func onError(error:IFlySpeechError){
        NSLog("onError:%d",error)
    }
    
    /**
    * @fn      onResults
    * @brief   识别结果回调
    *
    * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
    * @see
    */
    func onResults( results:Array<AnyObject>, isLast:Bool){
        
        var result:String="";
        if(results.count>0){
            let dic:NSDictionary = results[0] as! NSDictionary;
            for (key,value) in dic {
                result="\(key) (置信度:\(value))\n";
            }
            NSLog(result)
            self.resultTextView.text=self.resultTextView!.text+result
        }
        
    }
    
    /**
    * @fn      onCancal
    * @brief   取消识别回调
    *
    * @see
    */
    
    func onCancel(){
        NSLog("onCancel")
    }
    
    //MARK: - IFlyDataUploaderDelegate
    /**
    * @fn      onUploadFinished
    * @brief   上传完成回调
    * @param grammerID 上传用户词、联系人为空
    * @param error 上传错误
    */
    func onUploadFinished(grammerID:String,error:IFlySpeechError){
        NSLog("error:\(error.errorCode)");
        
        if (error.errorCode==0) {
            NSLog("上传成功");
        }
        else {
            NSLog("上传失败");
        }
    }
}
