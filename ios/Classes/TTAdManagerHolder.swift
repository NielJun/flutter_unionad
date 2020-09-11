//
//  TTAdManagerHolder.swift
//  flutter_unionad
//
//  Created by 9Y on 2020/9/9.
//

import Foundation
import BUAdSDK

public class TTAdManagerHolder : NSObject, BURewardedVideoAdDelegate{

    public static let instace = TTAdManagerHolder()
    
    private var bURewardedVideoAd : BUNativeExpressRewardedVideoAd?
    
    //激励广告参数
    private var rewardModel :BURewardedVideoModel?
    
    public func initTTSDK(params : NSDictionary){
        let appId = params.value(forKey: "iosAppId") as? String
        if(appId != nil){
           BUAdSDKManager.setAppID(appId)
        }
    }
    
    public func showRewardedVideoAd(params : NSDictionary) {
            let mCodeId = params.value(forKey: "mCodeId") as? String
            let userID = params.value(forKey: "userID") as? String
            let rewardName = params.value(forKey: "rewardName") as? String
            let rewardAmount = params.value(forKey: "rewardAmount") as? Int
            let mediaExtra = params.value(forKey: "mediaExtra") as? String
            self.rewardModel = BURewardedVideoModel()
            self.rewardModel!.userId = userID
            if rewardName != nil {
                self.rewardModel!.rewardName = rewardName
            }
            if rewardAmount != nil {
                self.rewardModel!.rewardAmount = rewardAmount!
            }
            if mediaExtra != nil {
                self.rewardModel!.extra = mediaExtra
            }
            self.bURewardedVideoAd = BUNativeExpressRewardedVideoAd(slotID: mCodeId!, rewardedVideoModel: self.rewardModel!)
            self.bURewardedVideoAd!.delegate = self
            self.bURewardedVideoAd!.loadData()
        }
        
        private func getVC() -> UIViewController {
                   let viewController = UIApplication.shared.windows.filter { (w) -> Bool in
                       w.isHidden == false
                   }.first?.rootViewController
                   return viewController!
               }
    
}

extension TTAdManagerHolder: BUNativeExpressRewardedVideoAdDelegate {
    public func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
         self.bURewardedVideoAd!.show(fromRootViewController: self.getVC())
         LogUtil.logInstance.printLog(message: "激励广告加载成功")
        }
        
    public func nativeExpressRewardedVideoAdDidClose(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告关闭")
        }
        
    public func nativeExpressRewardedVideoAd(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
        LogUtil.logInstance.printLog(message: "激励广告加载失败")
        LogUtil.logInstance.printLog(message: error)
        }
        
    public func nativeExpressRewardedVideoAdDidClickSkip(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告跳过")
        }
        
    public func nativeExpressRewardedVideoAdServerRewardDidFail(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告失败")
        }
        
    public func nativeExpressRewardedVideoAdServerRewardDidSucceed(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, verify: Bool) {
            /// handle in close
        LogUtil.logInstance.printLog(message: "激励广告观看成功")
        }
        
    public func nativeExpressRewardedVideoAdDidPlayFinish(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
        LogUtil.logInstance.printLog(message: "激励广告完成")
        let map : NSDictionary = ["adType":"rewardAd",
                                  "rewardVerify":true,
                                  "rewardAmount":self.rewardModel!.rewardAmount,
                                  "rewardName":self.rewardModel!.rewardName ?? ""]
        SwiftFlutterUnionadPlugin.event!.sendEvent(event: map)
    }
}
