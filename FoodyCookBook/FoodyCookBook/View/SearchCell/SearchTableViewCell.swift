//
//  SearchTableViewCell.swift
//  FoodyCookBook
//
//  Created by Tim on 26/06/2021.
//

import UIKit


let imageCache = NSCache<AnyObject, AnyObject>.sharedInstance

class SearchTableViewCell: UITableViewCell {
    let identifier = String(describing: SearchTableViewCell.self)

    private var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var arrowParentView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var food: Meals? {
        didSet {
            foodNameLbl.text = food?.strMeal
            let url = food?.strMealThumb
            let fileUrl = URL(string: url!)!
            self.downloadItemImageForSearchResult(imageURL: fileUrl)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func downloadItemImageForSearchResult(imageURL: URL?) {
        
        if let urlOfImage = imageURL {
            if let cachedImage = imageCache.object(forKey: urlOfImage.absoluteString as NSString){
                self.foodImageView!.image = cachedImage as? UIImage
            } else {
                let session = URLSession.shared
                self.downloadTask = session.downloadTask(
                    with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
                        if error == nil, let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
                            DispatchQueue.main.async() {
                                let imageToCache = image
                                if let strongSelf = self, let imageView = strongSelf.foodImageView {
                                    imageView.image = imageToCache
                                    imageCache.setObject(imageToCache, forKey: urlOfImage.absoluteString as NSString , cost: 1)
                                }
                            }
                        } else {
                            print("ERROR \(error?.localizedDescription ?? String())")
                        }
                    })
                self.downloadTask!.resume()
            }
        }
        
        foodImageView.layer.cornerRadius = foodImageView.frame.size.width / 2
        foodImageView.layer.masksToBounds = true
    }
    
    override public func prepareForReuse() {
        self.downloadTask?.cancel()
        foodImageView?.image = UIImage(named: "ImagePlaceholder")
    }
    
    deinit {
        self.downloadTask?.cancel()
        foodImageView?.image = nil
    }
    
}
