//
//  TTSViewController.swift
//  swiftDemo
//
//  Created by 张剑 on 14-10-8.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

import UIKit


class TTSViewController: UIViewController,IFlySpeechSynthesizerDelegate {
    
    // 创建合成对象
    var iflySpeechSynthesizer:IFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance() as! IFlySpeechSynthesizer;
    
    @IBOutlet weak var ttsTextView: UITextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //创建语音配置
        let initString:String="appid="+APPID_VALUE+",timeout="+TIMEOUT_VALUE;
        
        //所有服务启动前，需要确保执行createUtility
        IFlySpeechUtility.createUtility(initString);
        
        self.iflySpeechSynthesizer.delegate = self;//请不要删除这句,createRecognizer是单例方法，需要重新设置代理
        
        self.iflySpeechSynthesizer.setParameter("50", forKey: IFlySpeechConstant.SPEED());//合成的语速,取值范围 0~100
        self.iflySpeechSynthesizer.setParameter("50", forKey: IFlySpeechConstant.VOLUME());//合成的音量;取值范围 0~100
        self.iflySpeechSynthesizer.setParameter("xiaoyan", forKey: IFlySpeechConstant.VOICE_NAME());//发音人,默认为”xiaoyan”;可以设置的参数列表可参考个性化发音人列表;
        self.iflySpeechSynthesizer.setParameter("8000", forKey: IFlySpeechConstant.SAMPLE_RATE());//音频采样率,目前支持的采样率有 16000 和 8000;
        //self.iflySpeechSynthesizer.setParameter(nil, forKey: IFlySpeechConstant.TTS_AUDIO_PATH());//当你再不需要保存音频时，请在必要的地方加上这行。
        self.iflySpeechSynthesizer.setParameter("tts.pcm", forKey: IFlySpeechConstant.TTS_AUDIO_PATH());//保存音频时，请在必要的地方加上这行。
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title="语音合成示例"
 
        ttsTextView.text=TTS_SAMPLE_TEXT;
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        iflySpeechSynthesizer.stopSpeaking();
        iflySpeechSynthesizer.delegate=nil
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate()->Bool{
        return false;
    }
    
    //MARK: - Button Event
   
    @IBAction func btnStartClicked(sender: AnyObject) {
        iflySpeechSynthesizer.startSpeaking(ttsTextView.text);
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        iflySpeechSynthesizer.stopSpeaking();
    }
    
    @IBAction func btnPauseClicked(sender: AnyObject) {
        iflySpeechSynthesizer.pauseSpeaking();
    }
    
    @IBAction func btnResumeClicked(sender: AnyObject) {
        iflySpeechSynthesizer.resumeSpeaking();
    }
    
    
    //MARK: - iflySpeechSynthesizerDelegate
    
    /** 结束回调
    
    当整个合成结束之后会回调此函数
    
    @param error 错误码
    */
    func onCompleted(error:IFlySpeechError){
        NSLog("onCompleted")
    }
    
    /** 开始合成回调 */
    func onSpeakBegin(){
        NSLog("onSpeakBegin")
    }
    
    /** 缓冲进度回调
    
    @param progress 缓冲进度，0-100
    @param msg 附件信息，此版本为nil
    */
    func onBufferProgress(progress:Int, msg message:String){
        NSLog("bufferProgress:\(progress)");
    }
    
    /** 播放进度回调
    
    @param progress 播放进度，0-100
    */
    func onSpeakProgress(progress:Int32){
        NSLog("play progress:\(progress)");
    }
    
    /** 暂停播放回调 */
    func onSpeakPaused(){
        NSLog("onSpeakPaused")

    }
    
    /** 恢复播放回调 */
    func onSpeakResumed(){
        NSLog("onSpeakResumed")
    }
    
    /** 正在取消回调
    
    当调用`cancel`之后会回调此函数
    */
    func onSpeakCancel(){
         NSLog("onSpeakCancel")
    }
    
    //MARK: -
    
}
