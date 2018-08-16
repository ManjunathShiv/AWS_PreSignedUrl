//
//  ViewController.swift
//  BM_Aws_Integration
//
//  Created by Manjunath Shivakumara on 26/06/18.
//  Copyright © 2018 Manjunath Shivakumara. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAuthCore
import AWSS3

class ViewController: UIViewController {
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var viewFileButton: UIButton!
    var downloadedFileURL : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get the AWSCredentialsProvider from the AWSMobileClient
        let credentialsProvider = AWSMobileClient.sharedInstance().getCredentialsProvider()
        let configuration = AWSServiceConfiguration(region:.APSouth1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // Get the identity Id from the AWSIdentityManager
        let identityId = AWSIdentityManager.default().identityId
        
        print("CredentialsProvider \(credentialsProvider)")
        print("IdentityID \(identityId ?? "")")
    }
    
    @IBAction func uploadFileToAws(_ sender: Any) {
        self.upload()
    }
    
    @IBAction func downloadFileFromAws(_ sender: Any) {
        self.download()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebViewSegue" {
            let url = self.downloadedFileURL
            (segue.destination as? WebViewController)?.urlToDisplay = url
        }
    }
    
    func download() {
        let getPreSignedURLRequest : AWSS3GetPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        getPreSignedURLRequest.bucket = "bmawsintegration-userfiles-mobilehub-736781972"
        getPreSignedURLRequest.key = "public/ClientServer.pdf"
        getPreSignedURLRequest.httpMethod = .GET
        getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)
        
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as NSError? {
                print("Error: \(error)")
                return nil
            }
            
            let presignedURL = task.result
            print("Download presignedURL is: \(presignedURL ?? NSURL())")
            
            let request = URLRequest(url: presignedURL! as URL)
            let downloadTask: URLSessionDownloadTask = URLSession.shared.downloadTask(with: request, completionHandler: { (url, response, error) in
                print("url\(String(describing: url)),response\(String(describing: response))")
                self.downloadedFileURL = response?.url
            })
            downloadTask.resume()
            
            return nil
        }

    }
    
    func upload() {
        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        getPreSignedURLRequest.bucket = "bmawsintegration-userfiles-mobilehub-736781972"
        getPreSignedURLRequest.key = "public/ClientServer.pdf"
        getPreSignedURLRequest.httpMethod = .PUT
        getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)
        
        //Important: set contentType for a PUT request.
        let fileContentTypeStr = "application/pdf"
        getPreSignedURLRequest.contentType = fileContentTypeStr
        
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as NSError? {
                print("Error: \(error)")
                return nil
            }
            
            let presignedURL = task.result
            print("Upload presignedURL is: \(presignedURL ?? NSURL())")
            
            var request = URLRequest(url: presignedURL! as URL)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            request.httpMethod = "PUT"
            request.setValue(fileContentTypeStr, forHTTPHeaderField: "Content-Type")
            
            if let filePath = Bundle.main.path(forResource: "ClientServer", ofType: "pdf") {
                print(filePath)
                let uploadTask : URLSessionTask = URLSession.shared.uploadTask(with: request, fromFile: URL(fileURLWithPath: filePath), completionHandler: { (data, response, error) in
                    print("data\(String(describing: data)),response\(String(describing: response))")
                })
                uploadTask.resume()
            }
            return nil
        }
    }

}

