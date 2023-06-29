import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webview: WKWebView!
    var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlStr = "https://vhcdn.net/webappV1/home.html"
        
        if let url = URL(string: urlStr) {
            let req = URLRequest(url: url)
            webview.load(req)
        }
        
        let left = UIImage(systemName: "chevron.left")
        let right = UIImage(systemName: "chevron.right")
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: right, style: .plain, target: self, action: #selector(goForward)),
            UIBarButtonItem(image: left, style: .plain, target: self, action: #selector(goBack)),
        ]
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton]
        navigationController?.isToolbarHidden = false
        
        webview.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        webview.allowsBackForwardNavigationGestures = true
    }
    
    override func loadView() {
        webview = WKWebView(frame: .zero)
        webview.navigationDelegate = self
        view = webview
    }
    
    @objc func goBack() {
        if webview.canGoBack {
            webview.goBack()
        }
    }
    
    @objc func goForward() {
        if webview.canGoForward {
            webview.goForward()
        }
    }
    
    @objc func refresh() {
        webview.reload()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.title = webview.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        navigationController?.isToolbarHidden = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "estimatedProgress"
        {
            progressView.progress = Float(webview.estimatedProgress)
        }
    }

}
