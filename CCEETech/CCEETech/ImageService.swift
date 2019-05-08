//
//  ImageService.swift
//  CCEETech
//
//  Class for storing images pulled from urls
//
//  Created by mcaim on 2/27/19.
//
import Foundation
import UIKit

class ImageService {
    
    // dictionary for storing images
    static let cache = NSCache<NSString,UIImage>()
    
    // downloads image from given url
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?, _ url:URL)->()) {
        let dataTask =  URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadedImage:UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data:data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            } else {
             // continue
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage,url)
            }
        }
        dataTask.resume()
    }
    
    // gets image from cache dictionary
    static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage?,_ url:URL)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image, url)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
    
}
