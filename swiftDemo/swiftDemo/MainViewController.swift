//
//  MainViewController.swift
//  bbox
//
//  Created by 黄晋雪 on 3/9/16.
//  Copyright © 2016 iflytek. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import CoreLocation
import MediaPlayer

class MainViewController: UIViewController, IFlySpeechRecognizerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var resultRecognizeText: UILabel!
    @IBOutlet weak var processSlider: UISlider!
    @IBOutlet weak var volume:UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var viewDish:UIView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var pauseBtn:UIButton!
    @IBOutlet weak var favariteBtn:UIButton!
    @IBOutlet weak var micBtntext:UILabel!
    
    let mic_bg:UIImage = UIImage(named: "mic_btn_active")!
    var sentence:String = ""
    let locationManager = CLLocationManager() //定位
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: NSError?
    var location:CLLocation?
    var locationDetail:String = "beijing"
    var viewMicPosition = true
    var playState = false
    var favoriteState = false
    var angle:CGFloat = 1
    var duration:Double = 0.01
    var rotateState = false


    // 创建识别对象
    var iflySpeechRecognizer:IFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance() as! IFlySpeechRecognizer
    // uploader must create here for thread safty. Because all upload tasks must be put into the same NSoperationQueue.
    var uploader:IFlyDataUploader=IFlyDataUploader()
    var grammerId:String=""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //创建语音配置
        let initString:String = "appid=56f33943"
        
        //所有服务启动前，需要确保执行createUtility
        IFlySpeechUtility.createUtility(initString)
        
        let domain = "iat"
        
        self.iflySpeechRecognizer.delegate = self;//请不要删除这句,createRecognizer是单例方法，需要重新设置代理
        self.iflySpeechRecognizer.setParameter(domain, forKey: IFlySpeechConstant.IFLY_DOMAIN())
        self.iflySpeechRecognizer.setParameter("16000", forKey: IFlySpeechConstant.SAMPLE_RATE())
        self.iflySpeechRecognizer.setParameter("asr.pcm", forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
        
        // | result_type   | 返回结果的数据格式，可设置为json，xml，plain，默认为json。
        self.iflySpeechRecognizer.setParameter("json", forKey: IFlySpeechConstant.RESULT_TYPE())
    }

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        //导航栏设置
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 21/255, green: 27/255, blue: 51/255, alpha: 100)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //slider style
        self.processSlider.setThumbImage(UIImage(named: "slider_thumb"), forState: UIControlState.Normal)
        self.processSlider.setThumbImage(UIImage(named: "slider_thumb"), forState: UIControlState.Highlighted)
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
    }

    override func viewWillDisappear(animated: Bool) {
        self.iflySpeechRecognizer.stopListening();
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.resultRecognizeText.resignFirstResponder()
    }
    
    @IBAction func startRecognize(sender: AnyObject) {
        
        self.pauseBtn.setBackgroundImage(UIImage(named: "mic_btn"), forState: .Normal)
        
        if sender.state == UIGestureRecognizerState.Began{
            if playState{
                pause() //unpause
            }
            self.resultRecognizeText.hidden = false
            self.resultRecognizeText.text = "请说出你的想法："
            self.sentence = ""
            self.iflySpeechRecognizer.startListening()
        
        }else if sender.state == UIGestureRecognizerState.Ended{
            self.iflySpeechRecognizer.stopListening()
        }
    }
    
    
    func RotateDish(){
        UIView.animateWithDuration(duration, animations: {
            self.viewDish.transform = CGAffineTransformMakeRotation(self.angle * CGFloat(M_PI / 180))
            }, completion: { (Bool) -> Void in
                if self.rotateState{
                    self.angle+=1
                    self.RotateDish()
                }
        })
    }
    func stopRotateDish(){
        print("stop rotate")
//        self.rotateState = !rotateState 
        self.viewDish.layer.removeAllAnimations()
    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IFlySpeechRecognizerDelegate
    
    /**
    * @fn      onVolumeChanged
    * @brief   音量变化回调
    *
    * @param   volume      -[in] 录音的音量，音量范围1~100
    * @see
    */
    func onVolumeChanged(volume: Int32) {
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
        NSLog("onError:\(error)")
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
        var valueC:String="";
        if(results.count>0){
            let dic:NSDictionary = results[0] as! NSDictionary;
//            print("-----------------------------识别结果--------------------------------")
//            print(dic)
            for (key,value) in dic {
                result = key as! String
                valueC = "(置信度:\(value))\n"
            }
            print(result)
            jsonToText(result)
        }else{
            self.resultRecognizeText.text = "［请重新输入!］"
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
    
//  get text in json
    func jsonToText(result:String){
        print("---------------------------json------------------------")
        let json_data = result.dataUsingEncoding(NSUTF8StringEncoding)
        let json:AnyObject = try! NSJSONSerialization.JSONObjectWithData(json_data!, options: [])
        var sen = sentence
        if let jsonDic = json as? NSDictionary{
            if let ws:AnyObject = jsonDic["ws"]{
                if let wsArr = ws as? [AnyObject]{
                    for n in 0..<wsArr.count{
                        if let wsitems = wsArr[n] as? [String:AnyObject]{
                            if let wsDic = wsitems["cw"]{
                                if let cwArr = wsDic as? [AnyObject]{
                                    if let cwitems0 = cwArr[0] as? [String:AnyObject]{
                                        if let cwDic = cwitems0["w"]{
                                            sen += (cwDic as! String)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    sentence = sen
                    print(sentence)
                }
            }
            if let ls = jsonDic["ls"]{
                if ls as! NSObject == true {
                    self.resultRecognizeText.text = sentence
                    connectServer(sentence)
                }
            }
        }
    }
    
    //connection function
    func connectServer(sentence_json: String){
        let parameters = [
            "sentence": sentence_json,
            "location": locationDetail,
        ]
        Alamofire.request(.POST, "http://172.20.10.8:8000/GetSentence/", parameters: parameters)
            .response{ request, response, data, error in
                print("request is \(request)")
                print("response is \(response)")
                print("data is \(data)")
                print("error is \(error)")
            }
        
        self.newList()
        self.pauseBtn.setBackgroundImage(UIImage(named: "pause"), forState: .Normal)
    }
    
    //定位代理方法
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError \(error)")
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationInfo = locations.last!
        print("didUpdateLocations \(locationInfo)")
        
        location = locationInfo
        
        if !performingReverseGeocoding{
            
//            print("***Going to geocode")
            
            performingReverseGeocoding = true
            
            geocoder.reverseGeocodeLocation(locationInfo, completionHandler: {placemarks, error in
                
//                print("***Found placemarks:\(placemarks), error:\(error)")
                
                self.lastGeocodingError = error
                if error == nil, let p = placemarks where !p.isEmpty{
                    self.placemark = p.last!
                }else{
                    self.placemark = nil
                }
                self.performingReverseGeocoding = false
            })
        }
        
        updateLabels()
    }
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.3f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.3f", location.coordinate.longitude)
            
            if let placemark = placemark{
                addressLabel.text = stringFromPlacemark(placemark)
                locationDetail = stringFromPlacemark(placemark)
            }else if performingReverseGeocoding{
                addressLabel.text  = "searching for address..."
            }else if lastGeocodingError != nil  {
                addressLabel.text = "erroe finding address"
            }else{
                addressLabel.text = "no address found"
            }
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
        }
    }
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        
        var line1 = ""
        if let s = placemark.subThoroughfare{
            line1 += s + " "
        }
        if let s = placemark.thoroughfare{
            line1 += s
        }
        
        var line2  = ""
        
        if let s = placemark.locality{
            line2 += s + " "
        }
        if let s = placemark.administrativeArea{
            line2 += s + " "
        }
        if let s = placemark.postalCode{
            line2 += s
        }
        
        return line1 + " " + line2
    }
    
    func updatePlayState(){
        print(playState)
        if self.playState == true{
            print("music start")
            self.stopRotateDish()
            self.pauseBtn.setBackgroundImage(UIImage(named: "unpause"), forState: .Normal)
        }
        if self.playState == false{
            self.RotateDish()  
            self.pauseBtn.setBackgroundImage(UIImage(named: "pause"), forState: .Normal)
        }
        self.playState = !self.playState
        self.rotateState = !self.rotateState
        print(playState)
    }
    func startPlay(){
        Alamofire.request(.GET, "http://172.20.10.8:8000/startplay/")
        self.RotateDish()
        updatePlayState()
    }
    func newList(){
        
        let time:NSTimeInterval = 1
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time*Double(NSEC_PER_MSEC)))
        
        print("换歌单＝＝")
        self.stopRotateDish()
        self.playState = false
        self.rotateState = false
        updatePlayState()
        
        dispatch_after(delay, dispatch_get_main_queue()){
            Alamofire.request(.GET, "http://172.20.10.8:8000/control/5/")
        }
    }

    @IBAction func volumeChange(){
        volume.text = "\(Int(processSlider.value))"
        Alamofire.request(.GET, "http://172.20.10.8:8000/volume/\(Int(processSlider.value))/")
    }
    @IBAction func pause(){
        if playState{
            Alamofire.request(.GET, "http://172.20.10.8:8000/control/0/")
            updatePlayState()
        }
        else{
            Alamofire.request(.GET, "http://172.20.10.8:8000/control/1/")
            updatePlayState()
        }
    }
    @IBAction func nextItem(){
        Alamofire.request(.GET, "http://172.20.10.8:8000/control/2/")
    }
    @IBAction func forwardItem(){
        Alamofire.request(.GET, "http://172.20.10.8:8000/control/3/")
    }
    @IBAction func favorite(){
        if self.favoriteState == true{
            self.favariteBtn.setBackgroundImage(UIImage(named: "favarite_no"), forState: .Normal)
        }
        if self.favoriteState == false{
            self.favariteBtn.setBackgroundImage(UIImage(named: "favarite_yes"), forState: .Normal)
        }
        self.favoriteState = !self.favoriteState
    }
    
}
