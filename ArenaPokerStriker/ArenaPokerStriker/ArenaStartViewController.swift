//
//  ViewController.swift
//  ArenaPokerStriker
//
//  Created by jin fu on 2024/10/2.
//

import UIKit

class ArenaStartViewController: UIViewController {

    @IBOutlet weak var adsActivityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adsActivityView.hidesWhenStopped = true
        self.fetchBannerADsData()
        // Do any additional setup after loading the view.
    }
    
    private func fetchBannerADsData() {
        if needLoadBanner() == false {
            return
        }
        
        self.adsActivityView.startAnimating()
        if ArenaReachManage.sharedManager().isReachable {
            reqAdsLocalData()
        } else {
            ArenaReachManage.sharedManager().setReachabilityStatusChange { status in
                if ArenaReachManage.sharedManager().isReachable {
                    self.reqAdsLocalData()
                    ArenaReachManage.sharedManager().stopMonitoring()
                }
            }
            ArenaReachManage.sharedManager().startMonitoring()
        }
    }
    
    private func reqAdsLocalData() {
        fetchLocalAdsData { dataDic in
            if let dataDic = dataDic {
                self.configAdsData(pulseDataDic: dataDic)
            } else {
                self.adsActivityView.stopAnimating()
            }
        }
    }
    
    private func configAdsData(pulseDataDic: [String: Any]?) {
        if let aDic = pulseDataDic {
            let cCode: String = aDic["countryCode"] as? String ?? ""
            let adsData: [String: Any]? = aDic["jsonObject"] as? Dictionary
            if let adsData = adsData {
                if let codeData = adsData[cCode], codeData is [String: Any] {
                    let dic: [String: Any] = codeData as! [String: Any]
                    if let data = dic["data"] as? String, !data.isEmpty {
                        UserDefaults.standard.set(dic, forKey: "ArenaBannerDatas")
                        self.showAdsBanner();
                    }
                    return
                }
            }
            self.adsActivityView.stopAnimating()
        }
    }
    
    private func fetchLocalAdsData(completion: @escaping ([String: Any]?) -> Void) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            completion(nil)
            return
        }
        
        let url = URL(string: "https://open.dreamcraft.top/open/fetchLocalAdsData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appKey": "fdec258c5ef146c7a997836787295aad",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        if let dataDic = dictionary {
                            completion(dataDic)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }


}

