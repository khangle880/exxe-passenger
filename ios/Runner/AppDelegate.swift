import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let VNPAY_CHANNEL_NAME = "passenger/vn_pay"
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let vnpayChanel = FlutterMethodChannel(name: VNPAY_CHANNEL_NAME,
                                               binaryMessenger: controller.binaryMessenger)
        
        vnpayChanel.setMethodCallHandler({
            (call: FlutterMethodCall,result: @escaping FlutterResult) -> Void in
            if( call.method != "open_sdk"){
                result(FlutterMethodNotImplemented)
                return
            }
            else{
                if let args = call.arguments as? Dictionary<String, Any>,
                   let url = args["url"] as? String {
                    
                    self.openSDK(url: url )
                    result("success")
                } else {
                    result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
                }
            }
            
        })

        GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey("AIzaSyC4OI79qDL5sN7ziz4dW4OUX_surdHP1YI")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func openSDK(url: String) {
        //  Converted to Swift 5.5 by Swiftify v5.5.24623 - https://swiftify.com/
        //các thông số dưới đây là demo
        //vui lòng đọc kỹ comment của từng variable một
        
        let fromVC = self.window.rootViewController//bắt buộc
        let scheme = "exxe" //bắt buộc, tên scheme bạn tự đặt theo app
        let isSandbox = false //bắt buộc, YES <=> môi trường test, NO <=> môi trường live
        let paymentUrl = url //@"https://sandbox.vnpayment.vn/tryitnow/Home/CreateOrder"; //bắt buộc, VNPAY cung cấp
        let tmn_code = "EXXEAPP1" //bắt buộc, VNPAY cung cấp
        let backAction = true //bắt buộc, YES <=> bấm back sẽ thoát SDK, NO <=> bấm back thì trang web sẽ back lại trang trước đó, nên set là YES, nên set là YES, vì trang thanh toán không nên cho người dùng back về trang trước
        let backAlert = "" //không bắt buộc, thông báo khi người dùng bấm back
        let title = "VNPAY" //bắt buộc, title của trang thanh toán
        let titleColor = "#000000" //bắt buộc, màu của title
        let beginColor = "#FFFFFF" //bắt buộc, màu của background title
        let endColor = "#FFFFFF" //bắt buộc, màu của background title
        let iconBackName = "ic_back" //bắt buộc, icon back
        
        show(
            fromVC: fromVC,
            scheme: scheme,
            isSandbox: isSandbox,
            paymentUrl: paymentUrl,
            tmn_code: tmn_code,
            backAction: backAction,
            backAlert: backAlert,
            title: title,
            titleColor: titleColor,
            beginColor: beginColor,
            endColor: endColor,
            iconBackName: iconBackName)
    }
    
    //  Converted to Swift 5.5 by Swiftify v5.5.24623 - https://swiftify.com/
    func show(
        fromVC: UIViewController?,
        scheme: String?,
        isSandbox: Bool,
        paymentUrl: String?,
        tmn_code: String?,
        backAction: Bool,
        backAlert: String?,
        title: String?,
        titleColor: String?,
        beginColor: String?,
        endColor: String?,
        iconBackName: String?
    ) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SDK_COMPLETED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector("sdkAction:"), name: NSNotification.Name("SDK_COMPLETED"), object: nil)
        if let fromVC = fromVC {
            CallAppInterface.setHomeViewController(fromVC)
        }
        if let scheme = scheme {
            CallAppInterface.setSchemes(scheme)
        }
        CallAppInterface.setIsSandbox(isSandbox)
        if let appBackAlert = backAlert {
            CallAppInterface.setAppBackAlert(appBackAlert)
        }
        CallAppInterface.setEnableBackAction(backAction)
        if let paymentUrl = paymentUrl,
           let title = title,
           let iconBackName = iconBackName,
           let beginColor = beginColor,
           let endColor = endColor,
           let titleColor = titleColor,
           let tmn_code = tmn_code {
            CallAppInterface.showPushPaymentwithPaymentURL(paymentUrl,
                                                           withTitle: title,
                                                           iconBackName: iconBackName,
                                                           beginColor: beginColor,
                                                           endColor: endColor,
                                                           titleColor: titleColor,
                                                           tmn_code: tmn_code)
        }
    }
    
    //  Converted to Swift 5.5 by Swiftify v5.5.24623 - https://swiftify.com/
    @objc func sdkAction(_ notification: Notification?) {
        let name = notification?.name.rawValue ?? ""
        if name.isEqual("SDK_COMPLETED") {

            let actionValue = (notification?.object as? NSObject)?.value(forKey: "Action") as? String

            print("actionValue = \(actionValue ?? "")")

            if "AppBackAction" == actionValue {
                //Người dùng nhấn back từ sdk để quay lại

                return
            }
            if "CallMobileBankingApp" == actionValue {
                //Người dùng nhấn chọn thanh toán qua app thanh toán (Mobile Banking, Ví...)
                //lúc này app tích hợp sẽ cần lưu lại cái PNR, khi nào người dùng mở lại app tích hợp với cheme thì sẽ gọi kiểm tra trạng thái thanh toán của PNR Đó xem đã thanh toán hay chưa.

                return
            }
            if "WebBackAction" == actionValue {
                //Người dùng nhấn back từ trang thanh toán thành công khi thanh toán qua thẻ khi gọi đến http://sdk.merchantbackapp

                return
            }
            if "FaildBackAction" == actionValue {
                //giao dịch thanh toán bị failed

                return
            }
            if "SuccessBackAction" == actionValue {
                //thanh toán thành công trên webview

                return
            }
        }
    }
    
}
