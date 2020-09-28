//
//  ViewController.swift
//  PiggyTestWeb
//
//  Created by Qing Li on 2020/9/25.
//  Copyright © 2020 Qing Li. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, WKUIDelegate {
    
    //Search Bar
    lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.returnKeyType = .search
        
        return textField
    } ()
    
    //WebContent
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self;
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    } ()
    
    //Left And Right Bar Button Item.(Refresh and Asin)
    let refresBarItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(actionRefresh))
    let asinBarItem = UIBarButtonItem(title: "ASIN", style: .done, target: self, action: #selector(actionDisplay))
    
    //Previous and Forward Button For Web Content.
    let previousButton = UIButton(frame: .zero)
    let forwardButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SetUI
        setupUI()
        setupNavItems()
        
        //Clear Cookies
        self.clearCookies()
        
        //Load URL for WebView
        let url = URL(string: "https://amazon.com")
        let request = NSMutableURLRequest(url: url!)
        
        self.webView.load(request as URLRequest)
    }
    
    override func viewDidLayoutSubviews() {
        //SetView Height
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navHeight = self.navigationController != nil && self.view.frame.origin.y == 0 ? self.navigationController!.navigationBar.frame.height : 0
        
        self.textField.frame = CGRect(x: 0, y: navHeight + statusHeight, width: self.view.frame.width, height: 40)
        self.webView.frame = CGRect(x: 0, y: navHeight + statusHeight + 40, width: self.view.frame.width, height: self.view.frame.height - statusHeight - navHeight - 40)
        
        self.previousButton.frame = CGRect(x: 20, y: self.view.frame.height - 60, width: 30, height: 30)
        self.forwardButton.frame = CGRect(x: 60, y: self.view.frame.height - 60, width: 30, height: 30)
    }
    
    
    //Set UI
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.webView)
        self.view.addSubview(self.textField)
        self.textField.textColor = UIColor.black
        self.previousButton.setTitle("<", for: .normal)
        self.previousButton.setTitleColor(.black, for: .normal)
        self.previousButton.backgroundColor = .white
        self.previousButton.addTarget(self, action: #selector(actionPrevious), for: .touchUpInside)
        
        self.forwardButton.setTitle(">", for: .normal)
        self.forwardButton.setTitleColor(.black, for: .normal)
        self.forwardButton.backgroundColor = .white
        self.forwardButton.addTarget(self, action: #selector(actionForward), for: .touchUpInside)
        self.view.addSubview(self.previousButton)
        self.view.addSubview(self.forwardButton)
    }
    
    func setupNavItems() {
        self.navigationController?.navigationBar.barTintColor = .systemBlue
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = asinBarItem
        self.navigationItem.rightBarButtonItem = refresBarItem
    }
    
    
    //Button Actions
    @objc func actionPrevious() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func actionForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func actionDisplay() {
        var result = "No ASIN"
        let pathes = URLComponents(url: webView.url!, resolvingAgainstBaseURL: true)?.path.components(separatedBy: "/")
        if (pathes != nil && pathes!.count > 0) {
            for i in 0..<pathes!.count {
                let subString = pathes![i]
                if subString.count == 10 && subString.isAlphanumeric {
                    result = subString
                }
            }
        }
        
        let alertController = UIAlertController(title: "ASIN", message: result, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func actionRefresh() {
        webView.reload()
    }
    
    //Clear Cook
    func clearCookies() {
        if #available(iOS 9.0, *) {
            let dataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeOfflineWebApplicationCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeIndexedDBDatabases, WKWebsiteDataTypeWebSQLDatabases])
            let date = Date(timeIntervalSinceReferenceDate: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: dataTypes as! Set<String>, modifiedSince: date, completionHandler: {})
        } else {
            let storage = HTTPCookieStorage.shared
            for cookie in storage.cookies! {
                storage.deleteCookie(cookie)
            }
        }
    }
    
    //TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        if textField.text!.isEmpty {
            return true;
        }
        
        let url = URL(string: "https://amazon.com/s?k=" + (textField.text?.replacingOccurrences(of: " ", with: "+"))!)
        let request = NSMutableURLRequest(url: url!)
        
        self.webView.load(request as URLRequest)
        
        
        
        return true;
    }
    
}

//check String is Alphanumeric
extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

