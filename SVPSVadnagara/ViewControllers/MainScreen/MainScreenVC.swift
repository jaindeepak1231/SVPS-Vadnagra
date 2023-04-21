//
//  MainScreenVC.swift
//  SVPSVadnagara
//
//  Created by Varun on 02/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SideMenu
import WebKit
import SafariServices

enum WebPagesURL: String {
    
    case notWebPage = ""
    case Home = "https://svpsvadnagara.org/?wsdl=api"
    case AboutSamaj = "https://svpsvadnagara.org/about-samaj/?wsdl=api"
    case ObjectivesofSVPS = "https://svpsvadnagara.org/objectives-of-svps/?wsdl=api"
    case History = "https://svpsvadnagara.org/history/?wsdl=api"
    case Trustee = "https://svpsvadnagara.org/trustees/?wsdl=api"
    case Search = "https://svpsvadnagara.org/matrimonial/?wsdl=api"
    case Announcement = "https://svpsvadnagara.org/announcement/?wsdl=api"
    case Activity = "https://svpsvadnagara.org/activitiesnew/?wsdl=api"
    case Gallery = "https://svpsvadnagara.org/gallery/?wsdl=api"
    case UsefulLinks = "https://svpsvadnagara.org/useful-links/?wsdl=api"
    case ContactUs = "https://svpsvadnagara.org/contact-us/?wsdl=api"
    case Metromonial = "https://svpsvadnagara.org/portal/matrimonial/?wsdl=api&user_id=0"
    //case MetromonialWithUserID = "https://svpsvadnagara.org/portal/test.html?user_id="// "https://svpsvadnagara.org/portal/matrimonial/?wsdl=api&user_id="
    case MetromonialWithUserID = "https://svpsvadnagara.org/portal/matrimonial/?wsdl=api&user_id="
}

class MainScreenVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlToLoad = WebPagesURL.Home.rawValue
    var navigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webView.navigationDelegate = self
        
        setupUI()
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.loadWebPage()
        //}
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
        //}
        
/*
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            let str_URL = WebPagesURL.MetromonialWithUserID.rawValue + strGetUserID()
            if let url = URL (string: str_URL) {
                let svc = SFSafariViewController(url: url)
                /*self.present(svc, animated: true, completion: {
                    var frame = svc.view.frame
                    let OffsetY: CGFloat  = 64
                    frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - OffsetY)
                    frame.size = CGSize(width: frame.width, height: frame.height + OffsetY)
                    svc.view.frame = frame
                    
                    let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 50))
                    view.backgroundColor = UIColor.blue
                    svc.view.addSubview(view)
                })*/
                self.present(svc, animated: true, completion: nil)
            }
        })*/
        
    }
    
    // MARK:- Custom Methods
    
    final func setupUI() {
        
        if let navigationTitle = self.navigationTitle {
            self.title = navigationTitle
        }
        
        let leftMenuButton = UIBarButtonItem(image: UIImage(named: "ic_action_menu"), style: .plain, target: self, action: #selector(sideMenuButtonTapped))
        self.navigationItem.leftBarButtonItem = leftMenuButton
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationController?.navigationBar.topItem?.leftBarButtonItem = leftMenuButton
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = .white
        
        setupMenu()
    }
    
    final func setupMenu() {
        
        let sideMenuVC = SideMenuVC.instantiate(fromAppStoryboard: .Main)
        sideMenuVC.delegate = self
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideMenuVC)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.width - 50
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    final func loadWebPage() {
        
        isConnectedToInternet()

        if urlToLoad != "" {
            let str_URL = urlToLoad // WebPagesURL.MetromonialWithUserID.rawValue + strGetUserID()
            let url = URL(string: str_URL)!
            
            if let isLogin = UserDefaults.standard.value(forKey: "is_login") as? Bool {
                if isLogin {
                    if self.navigationTitle == "Matrimonial".localized("") {
                        self.webView.uiDelegate = self
                        self.webView.navigationDelegate = self
                        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4"
                    }
                }
            }
            webView.load(URLRequest(url: url))
            
        }
        else {
            debugPrint("self.title Missing=====>>\(self.title ?? "Home".localized(""))")
        }
        
        
    }
    
    // MARK:- IBActions
    
    @objc func sideMenuButtonTapped() {
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

extension MainScreenVC: SideMenuClickProtocol {
    func sideMenuDidChanged(navigationTitle: String, urlToLoad: WebPagesURL) {
        
        self.urlToLoad = urlToLoad.rawValue
        self.title = navigationTitle
        webView.load(URLRequest(url: URL(string:"about:blank")!))
    }
}

extension MainScreenVC: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ShowProgressHud(message: "please wait...".localized(""))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DismissProgressHud()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DismissProgressHud()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DismissProgressHud()
    }
    
}
/*
extension SFSafariViewController{
    override open var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
}
*/
