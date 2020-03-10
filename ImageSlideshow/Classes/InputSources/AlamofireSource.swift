//
//  AlamofireSource.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 14.01.16.
//
//

import UIKit
#if SWIFT_PACKAGE
import ImageSlideshow
#endif
import Alamofire
import AlamofireImage

/// Input Source to image using Alamofire
@objcMembers
public class AlamofireSource: NSObject, InputSource {
    /// url to load
    public var url: URL
    public var authToken: String?

    /// placeholder used before image is loaded
    public var placeholder: UIImage?

    /// Initializes a new source with a URL
    /// - parameter url: a url to load
    /// - parameter token: auth token
    /// - parameter placeholder: a placeholder used before image is loaded
    public init(url: URL, token: String? = nil, placeholder: UIImage? = nil) {
        self.url = url
        self.token = token
        self.placeholder = placeholder
        super.init()
    }

    /// Initializes a new source with a URL string
    /// - parameter urlString: a string url to load
    /// - parameter token: a authToken
    /// - parameter placeholder: a placeholder used before image is loaded
    public init?(urlString: String, token: String? = nil, placeholder: UIImage? = nil) {
        if let validUrl = URL(string: urlString) {
            self.url = validUrl
            self.token = token
            self.placeholder = placeholder
            super.init()
        } else {
            return nil
        }
    }

    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        if token != nil {
            var urlRequest = URLRequest(url: self.url)
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            imageView.af_setImage(withURLRequest: urlRequest, placeholderImage: self.placeholder, filter: nil, progress: nil) { [weak self] response in
                switch response.result {
                case .success(let image):
                    callback(image)
                case .failure:
                    if let strongSelf = self {
                        callback(strongSelf.placeholder)
                    } else {
                        callback(nil)
                    }
                }
            }
        } else {
            imageView.af_setImage(withURL: self.url, placeholderImage: self.placeholder, filter: nil, progress: nil) { [weak self] response in
                switch response.result {
                case .success(let image):
                    callback(image)
                case .failure:
                    if let strongSelf = self {
                        callback(strongSelf.placeholder)
                    } else {
                        callback(nil)
                    }
                }
            }
        }
    }

    public func cancelLoad(on imageView: UIImageView) {
        imageView.af_cancelImageRequest()
    }
}
