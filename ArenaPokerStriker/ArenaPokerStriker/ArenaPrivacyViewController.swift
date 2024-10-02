//
//  ArenaPrivacyViewController.swift
//  ArenaPokerStriker
//
//  Created by jin fu on 2024/10/2.
//

import UIKit
import WebKit
import Adjust

class ArenaPrivacyViewController: UIViewController ,  WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var topCons: NSLayoutConstraint!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    var url: String?
    let dic: [String: Any]? = UserDefaults.standard.object(forKey: "ArenaBannerDatas") as? [String: Any]
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let dic = dic {
            let or = dic["type"] as! Int
            var orientations: UIInterfaceOrientationMask = .portrait
            if or == 2 {
                orientations = .landscape
            } else if or == 3 {
                orientations = .all
            }
            return orientations
        } else {
            return .all
        }
    }
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dic = dic {
            if let data = dic["data"] as? String, !data.isEmpty {
                self.url = "\(data)?a=\(Adjust.idfv() ?? "")&p=\(Bundle.main.bundleIdentifier ?? "")"
            }
        }
        
        configViews()
        initRequest()
    }
    
    //MARK: - Functions
    private func configViews() {
        self.indicatorView.hidesWhenStopped = true
        self.webView.alpha = 0
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.configuration.userContentController.add(self, name: "openUrl")
        self.webView.backgroundColor = .black
        self.webView.scrollView.backgroundColor = .black
        self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        self.view.backgroundColor = .black
        self.backBtn.isHidden = self.url != nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let dic = dic {
            let top = dic["top"] as! Int
            let bottom = dic["bottom"] as! Int
            if top > 0 {
                topCons.constant = view.safeAreaInsets.top
            }
            if bottom > 0 {
                bottomCons.constant = view.safeAreaInsets.bottom
            }
        }
    }
    
    private func initRequest() {
        if let urlStr = url, !urlStr.isEmpty {
            if let urlR = URL(string: urlStr) {
                self.indicatorView.startAnimating()
                let request = URLRequest(url: urlR)
                webView.load(request)
            }
        } else {
            self.indicatorView.startAnimating()
            if let urlR = URL(string: "https://www.termsfeed.com/live/2a4497d4-f1f0-4776-95a6-382cc8530fc3") {
                let request = URLRequest(url: urlR)
                webView.load(request)
            }
        }
    }
    
    //MARK: - Declare IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "openUrl" {
            if let data = message.body as? String, let daUrl = URL.init(string: data) {
                UIApplication.shared.open(daUrl)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
            self.webView.alpha = 1
            self.bgView.isHidden = true
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
            self.webView.alpha = 1
            self.bgView.isHidden = true
        }
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return nil
    }

}
