/*
 * Copyright(C) Koninklijke Philips N.V. 2018
 *
 *  All rights are reserved. Reproduction or transmission in whole or in part, in
 *  any form or by any means, electronic, mechanical or otherwise, is prohibited
 *  without the prior written permission of the copyright owner.
 *
 *  File Name : WebViewController.swift
 *  Owner: Manjunath Shivakumara
 */

import WebKit

class WebViewController : UIViewController {
    @IBOutlet weak var webViewPlaceholderView: UIView!
    var urlToDisplay : URL!
    var rulesWebView : WKWebView!
    
    //MARK: - Load Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpWebviewAndLoad()
        print("urlToDisplay\(urlToDisplay)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK: - WebView Methods
    
    func setUpWebviewAndLoad() {
        let webViewConfiguration = WKWebViewConfiguration()
        rulesWebView = WKWebView(frame: (webViewPlaceholderView.bounds), configuration: webViewConfiguration)
        rulesWebView.navigationDelegate = self
        rulesWebView.allowsBackForwardNavigationGestures = true
        rulesWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webViewPlaceholderView.addSubview(rulesWebView)
        webViewPlaceholderView.bringSubview(toFront: rulesWebView)
        
        guard let url = urlToDisplay else { return }
        rulesWebView.load(URLRequest(url: url))
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished Loading")
    }
}
