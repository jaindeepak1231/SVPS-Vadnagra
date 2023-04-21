//
//  SideMenuContentWebViewVC.swift
//  SVPSVadnagara
//
//  Created by Zignuts Technolab on 21/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SideMenu
import WebKit

class SideMenuContentWebViewVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var urlToLoad = WebPagesURL.Home.rawValue
    var navigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.loadWebPage()
        }
    }
    
    // MARK:- Custom Methods
    
    final func setupUI() {
        
        if let navigationTitle = self.navigationTitle {
            self.title = navigationTitle
        }
        
        let leftMenuButton = UIBarButtonItem(image: UIImage(named: "ic_action_menu"), style: .plain, target: self, action: #selector(sideMenuButtonTapped))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = leftMenuButton
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
        
        let url = URL(string: urlToLoad)!
        webView.load(URLRequest(url: url))
        
    }
    
    // MARK:- IBActions
    
    @objc func sideMenuButtonTapped() {
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

extension SideMenuContentWebViewVC: SideMenuClickProtocol {
    func sideMenuDidChanged(navigationTitle: String, urlToLoad: WebPagesURL) {
        
        self.urlToLoad = urlToLoad.rawValue
        self.title = navigationTitle
        webView.load(URLRequest(url: URL(string:"about:blank")!))
    }
}

extension SideMenuContentWebViewVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressHUD()
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressHUD()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressHUD()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideProgressHUD()
    }
}
