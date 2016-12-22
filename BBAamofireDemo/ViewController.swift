//
//  ViewController.swift
//  BBAamofireDemo
//
//  Created by ChenJie on 2016/12/22.
//  Copyright © 2016年 ChenJie. All rights reserved.
//

import UIKit
import Alamofire

let SERVICE_URL     = "http://v.juhe.cn/toutiao/index?"     // 请求地址
let SERVICE_IMG_URL = "https://httpbin.org/image/png"       // 图片 url
let APPKEY          = "ad2908cae6020addf38ffdb5e2255c06"    // 应用 APPKEY

let TOP             = "top"                                 // 参数：头条
let SHEHUI          = "shehui"                              // 参数：社会
let YULE            = "yule"                                // 参数：娱乐

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //第一部分
        firstMethod()
        //第二部分
        secondMethod()
        //第二部分
        thirdMethod()
        //第三、四部分
        fourMethod()
    }
    

    //MARK: Response Handling  五种不同响应方式
    func firstMethod() {
        let urlStr = "\(SERVICE_URL)type=\(TOP)&key=\(APPKEY)"
        // 1. response()
        // 官方解释：The response handler does NOT evaluate any of the response data. It merely forwards on all information directly from the URL session delegate. It is the Alamofire equivalent of using cURL to execute a Request.
        Alamofire.request(urlStr).response { (returnResult) in
            if let data = returnResult.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("firstMethod --> response() --> utf8Text = \(utf8Text)")
            }
        }
        
        //  2. responseData()
        //  官方解释：The responseData handler uses the responseDataSerializer (the object that serializes the server data into some other type) to extract the Data returned by the server. If no errors occur and Data is returned, the response Result will be a .success and the value will be of type Data.
        Alamofire.request(urlStr).responseData { (returnResult) in
            debugPrint("firstMethod --> responseData() --> returnResult = \(returnResult)")
            if let data = returnResult.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("firstMethod --> responseData() --> utf8Text = \(utf8Text)")
            }
        }
        
        // 3. responseString()
        // 官方解释：The responseString handler uses the responseStringSerializer to convert the Data returned by the server into a String with the specified encoding. If no errors occur and the server data is successfully serialized into a String, the response Result will be a .success and the value will be of type String.
        Alamofire.request(urlStr).responseString { (returnResult) in
            debugPrint("firstMethod --> responseString() --> Sucess = \(returnResult.result.isSuccess)")
            print("firstMethod --> responseString() --> returnResult = \(returnResult)")
        }
        
        // 4. responseJSON()
        // 官方解释：The responseJSON handler uses the responseJSONSerializer to convert the Data returned by the server into an Any type using the specified JSONSerialization.ReadingOptions. If no errors occur and the server data is successfully serialized into a JSON object, the response Result will be a .success and the value will be of type Any.
        Alamofire.request(urlStr).responseJSON { (returnResult) in
            debugPrint("firstMethod --> responseJSON --> \(returnResult)")
            if let json = returnResult.result.value {
                print("firstMethod --> responseJSON --> \(json)")
                /*  返回请求地址、数据、和状态结果等信息
                 print("firstMethod --> responseJSON() --> \(returnResult.request!)")
                 print("firstMethod --> responseJSON() --> \(returnResult.data!)")
                 print("firstMethod --> responseJSON() --> \(returnResult.result)")
                 */
            }
        }
        
        // 5. responsePropertyList()
        // 官方解释：
        /*
         Alamofire.request(urlStr).responsePropertyList { (<#DataResponse<Any>#>) in
         <#code#>
         }
         */
        
        
        // 补充：1.参数：queue：请求队列 --> 就是默认在主线程中执行~但是我们可以自定义调度队列。
        // 官方解释：Response handlers by default are executed on the main dispatch queue. However, a custom dispatch queue can be provided instead.
        // 补充：2.关于请求返回结果验证这里就不说了~在我封装的项目中均有体现~亦或者可以参阅一下官方文档即可~
        let customQueue = DispatchQueue.global(qos: .utility)
        Alamofire.request(urlStr).responseJSON(queue: customQueue) { (returnResult) in
            print("firstMethod --> 请求队列 --> \(returnResult)")
        }
    }
    
    
    
    
    //MARK: 请求方法、参数、编码、请求头等
    func secondMethod() {
        /*
         public enum HTTPMethod: String {
         case options = "OPTIONS"
         case get     = "GET"
         case head    = "HEAD"
         case post    = "POST"
         case put     = "PUT"
         case patch   = "PATCH"
         case delete  = "DELETE"
         case trace   = "TRACE"
         case connect = "CONNECT"
         }
         */
        // 1. GET请求
        let urlStr = "\(SERVICE_URL)type=\(YULE)&key=\(APPKEY)"
        Alamofire.request(urlStr, method: .get).responseJSON { (returnResult) in
            print("secondMethod --> GET 请求 --> returnResult = \(returnResult)")
        }
        // 2. POST请求
        Alamofire.request(urlStr, method: .post).responseJSON { (returnResult) in
            print("secondMethod --> POST 请求 --> returnResult = \(returnResult)")
        }
        // 3. 参数、编码
        // 官方解释：Alamofire supports three types of parameter encoding including: URL, JSON and PropertyList. It can also support any custom encoding that conforms to the ParameterEncoding protocol.
        let param = [
            "type": YULE,
            "key" : APPKEY
        ]
        Alamofire.request(SERVICE_URL, method: .post, parameters: param).responseJSON { (returnResult) in
            print("secondMethod --> 参数 --> returnResult = \(returnResult)")
        }
        //Alamofire.request(SERVICE_URL, method: .post, parameters: param, encoding: URLEncoding.default)
        //Alamofire.request(SERVICE_URL, method: .post, parameters: param, encoding: URLEncoding(destination: .methodDependent))
        
        // 4.请求头
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(urlStr, headers: headers).responseJSON { (returnResult) in
            print("secondMethod --> 请求头 --> returnResult = \(returnResult)")
        }
    }
    
    
    
    
    //MARK: URLRequest
    func thirdMethod() {
        let urlStr = "\(SERVICE_URL)type=\(YULE)&key=\(APPKEY)"
        let url = URL(string: urlStr)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
//        let param = ["type": YULE, "key": APPKEY]
//        do {
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
//        } catch {
//            print(error)
//        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseData { (returnResult) in
            debugPrint(returnResult)
            if let data = returnResult.data, let utf8Text =  String(data: data, encoding: .utf8) {
                print("thirdMethod --> 请求方式 --> utf8Text = \(utf8Text)")
            }
        }
    }
    
    
    
    //MARK: 下载(download)、上传(upload)
    func fourMethod() {
        // 1.下载图片
        Alamofire.download(SERVICE_IMG_URL).responseData { (returnResult) in
            if let data = returnResult.result.value {
                let image = UIImage(data: data)
                print("image = \(image)")
            } else {
                print("download is fail")
            }
        }
        // 2.下载进度
        Alamofire.download(SERVICE_IMG_URL).downloadProgress { (progress) in
            print("download progress = \(progress.fractionCompleted)")
            }.responseData { (returnResult) in
                if let data = returnResult.result.value {
                    let image = UIImage(data: data)
                    print("image = \(image)")
                } else {
                    print("download is fail")
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

