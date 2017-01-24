//
//  PhotosViewController.swift
//  tumblr
//
//  Created by Nick McDonald on 1/23/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var feedTableView: UITableView!
    var posts: [NSDictionary] = []
    var refreshControl: UIRefreshControl!
    var isMoreDataLoading: Bool = false
    var loadingMoreDataActivityView: InfiniteScrollActivityView?
    var currentPage: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedTableView.dataSource = self
        self.feedTableView.delegate = self
        self.getTumblrPosts()
        self.feedTableView.rowHeight = 240
        self.setUpRefreshControl()
        self.setUpInfiniteScrollingLoadingIndicator()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpInfiniteScrollingLoadingIndicator() {
        let frame = CGRect(x: 0, y: self.feedTableView.contentSize.height, width: self.feedTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultDrawHeight)
        self.loadingMoreDataActivityView = InfiniteScrollActivityView(frame: frame)
        self.loadingMoreDataActivityView!.isHidden = true
        self.feedTableView.addSubview(self.loadingMoreDataActivityView!)
        
        var insets = self.feedTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultDrawHeight;
        self.feedTableView.contentInset = insets
    }
    
    private func setUpRefreshControl() {
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getTumblrPosts), for: .valueChanged)
        self.refreshControl = refreshControl
        self.feedTableView.refreshControl = refreshControl
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!self.isMoreDataLoading) {
            let scrollViewContentHeight = self.feedTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.feedTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.feedTableView.isDragging) {
                self.isMoreDataLoading = true
                let frame = CGRect(x: 0, y: self.feedTableView.contentSize.height, width: self.feedTableView.bounds.width, height: InfiniteScrollActivityView.defaultDrawHeight)
                self.loadingMoreDataActivityView?.frame = frame
                self.loadingMoreDataActivityView?.startAnimating()
                
                self.getTumblrPosts()
            }
        }
    }
    
    @objc private func getTumblrPosts() {
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(tumblrAPIKey)&\(postOffsetRequestParam)\(self.currentPage)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.isMoreDataLoading = false
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts += responseFieldDictionary["posts"] as! [NSDictionary]
                        self.currentPage += self.posts.count
                        self.refreshControl.endRefreshing()
                        self.loadingMoreDataActivityView?.stopAnimating()
                        self.feedTableView.reloadData()
                    }
                }
        });
        task.resume()
    }
    

     // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the new view controller using segue.destinationViewController.
        //Pass the selected object to the new view controller.
        let vc: PhotoDetailsViewController = segue.destination as! PhotoDetailsViewController
        let index: IndexPath = self.feedTableView.indexPath(for: sender as! PhotoTableViewCell)!
        let post: NSDictionary = self.posts[index.row]
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageURLString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageURL = URL(string: imageURLString!) {
                vc.imageURL = imageURL
            }
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.feedTableView.dequeueReusableCell(withIdentifier: photoTableViewCellIdentifer, for: indexPath) as! PhotoTableViewCell
        let post = self.posts[indexPath.row]
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
                cell.postImageView.setImageWith(imageUrl)
            } else {
                // Nothing
            }
        } else {
            // Nothing
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.feedTableView.deselectRow(at: indexPath, animated: true)
    }

}
