//
//  GithubViewController.swift
//  VGH
//
//  Created by 冯奕琦 on 2018/11/8.
//  Copyright © 2018 冯奕琦. All rights reserved.
//

import UIKit
import WebKit

class GithubViewController: UIViewController {

    //MARK: Update From Model
    var model:GithubModel = GithubModel()
    
    func updateModelToWeb() {
        //改变AllLanguages的url为空
        let urlName = model.currentLangage == Constants.allLangages[0] ? "": model.currentLangage
        let urlString = Constants.trendingURL + urlName
        print(urlString)
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
        //更改顶部Button文字
        languageButton.setTitle(model.currentLangage, for: .normal)
    }
    
    
    //MARK:NavigationView
    
    
    @IBOutlet weak var languageButton:UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    
    @IBAction func webViewGoback() {
       print("Go back")
        webView.goBack()
    }
    
    @IBAction func changeLanguage() {
        print("Change Language")
        if let view = changerView {
            view.isHidden = view.isHidden ? false : true
        }else{
            gettingANewChangerView()
        }
    }
    //segue
    @IBAction func goback(segue:UIStoryboardSegue){
        if let chooseVC = segue.source as? ChooseFavoriteLanguageViewController , let newFavoriteLanguageArray = chooseVC.currentFavoriteLanguagesArray {
            //更新changerView
            print(newFavoriteLanguageArray)
            model.favoriteLanguage = newFavoriteLanguageArray
            gettingANewChangerView()
            changerView?.isHidden = true
        }
        
    }
    
    //MARK: ChoiceAntherLanguage
    
    var changerView:LangeuageChangerView?
    
    func gettingANewChangerView() {
        changerView?.removeFromSuperview()
        //初始化changerView
        let newView = LangeuageChangerView(midPoint: CGPoint(x: navigationView.frame.midX, y: navigationView.frame.maxY-4),
                                           favoriteLanguage: model.favoriteLanguage)
        //设置delegate
        newView.delegate = self
        changerView = newView
        view.addSubview(newView)
        //更改currentLanguage为allLanguage
        model.ChangeLangeuageTo(Constants.allLangages[0])
        updateModelToWeb()
    }
    
    //MARK:WKWebView
    
    @IBOutlet weak var webView: WKWebView!
    
//    override func loadView() {
//        //创建网页加载的偏好设置
//        let prefrences = WKPreferences()
//        prefrences.javaScriptEnabled = false
//
//        //配置网页视图
//        let webConfiguration = WKWebViewConfiguration()
//        webConfiguration.preferences = prefrences
//
//        webView = WKWebView(frame: CGRect(x: 0, y: 20, width: 0, height: 0), configuration: webConfiguration)
//
//        view = webView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //配置Webview
        webView.navigationDelegate = self;
        webView.allowsBackForwardNavigationGestures = true
        //创建网页加载的偏好设置
        let prefrences = WKPreferences()
        prefrences.javaScriptEnabled = true
        //配置网页视图
        webView.configuration.preferences = prefrences
        updateModelToWeb()
    }
    
}
//MARK:LanguageChangerDelegate
extension GithubViewController:ChangeLangeuageButtonDelegate{
    
    func changeModel(language: String) {
        model.ChangeLangeuageTo(language)
        updateModelToWeb()
    }
    
    func segueToFavoriteLanguageVC() {
        
        performSegue(withIdentifier: "segueToChooseLanguage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? ChooseFavoriteLanguageViewController{
            //初始化下一个VC的值
            nextVC.currentFavoriteLanguagesArray = model.favoriteLanguage
        }
    }
    
}

// MARK: WKNavigationDelegate
extension GithubViewController: WKNavigationDelegate {
    //视图开始载入的时候显示左上交网络活动指示器
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    //载入结束后，关闭网络活动指示器
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
