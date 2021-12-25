//
//  UnStructuredViewController.swift
//  ConcurenCy
//
//  Created by Trí Nguyễn on 21/12/2021.
//

import UIKit


enum ImageDownloadError: Error {
    case badImage
}

@MainActor
class UnStructuredViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var downloadImageTask: Task<Void, Never>? { // Task<T, Error>
        didSet {
            if downloadImageTask == nil {
                tapButton.setTitle("Download", for: .normal)
            } else {
                tapButton.setTitle("Cancel", for: .normal)
            }
        }
    }
    
    var downloadDataImageTask: Task<Data, Error>? {
        didSet {
            if downloadDataImageTask == nil {
                tapButton.setTitle("Download", for: .normal)
            } else {
                tapButton.setTitle("Cancel", for: .normal)
            }
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            print("Hello, iOS Developer")
            await hello(name: "Tri")
        }
    }
    
    func hello(name: String) async {
        print("Hello, \(name)!")
    }
    
    
    @IBAction func tap(_ sender: Any) {
        if downloadImageTask == nil {
            Task {
                await downloadDataRandom()
            }
        } else {
            cancelDownload()
        }
    }
    
    // MARK: - Download IMG
    func downloadImage(urlString: String) async throws -> UIImage {
        let imageUrl = URL(string: urlString)!
        let imageRequest = URLRequest(url: imageUrl)
        let (data, imgResponse) = try await URLSession.shared.data(for: imageRequest)
        guard let image = UIImage(data: data), (imgResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageDownloadError.badImage
        }
        return image
    }
    
    
    func downloadRandom() {
        let index = Int.random(in: 0...2)
        let urlStrings = [
            "https://media-cldnry.s-nbcnews.com/image/upload/newscms/2021_26/3487828/210630-stock-cat-bed-ew-245p.jpg",
            "https://s.w-x.co/in-cat_in_glasses.jpg",
            "https://www.gannett-cdn.com/-mm-/735f994d042682a89f8a4f2fcfd5ea505f3dc1cd/c=0-127-2995-1819/local/-/media/2015/10/31/USATODAY/USATODAY/635818943680464639-103115cute-kitty.jpg"
        ]
        
        downloadImageTask = Task {
            do {
                let image = try await downloadImage(urlString: urlStrings[index])
                imageView.image = image
            } catch {
                print(error.localizedDescription)
            }
            downloadImageTask = nil
        }
    }
    
    func cancelDownload() {
        downloadImageTask?.cancel()
        downloadDataImageTask?.cancel()
    }
    
    func downloadDataImage(urlString: String) async throws -> Data {
        let imageUrl = URL(string: urlString)!
        let imageRequest = URLRequest(url: imageUrl)
        let (data, imgresponse) = try await URLSession.shared.data(for: imageRequest)
        guard (imgresponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageDownloadError.badImage
        }
        return data
    }
    
    
    func beginDownloadDataRandom() {
        let index = Int.random(in: 0...2)
        let urlStrings = [
            "https://media-cldnry.s-nbcnews.com/image/upload/newscms/2021_26/3487828/210630-stock-cat-bed-ew-245p.jpg",
            "https://s.w-x.co/in-cat_in_glasses.jpg",
            "https://www.gannett-cdn.com/-mm-/735f994d042682a89f8a4f2fcfd5ea505f3dc1cd/c=0-127-2995-1819/local/-/media/2015/10/31/USATODAY/USATODAY/635818943680464639-103115cute-kitty.jpg"
        ]
        
        downloadDataImageTask = Task {
            return try await downloadDataImage(urlString: urlStrings[index])
        }
    }
    
    
    func showImageData(data: Data) {
        imageView.image = UIImage(data: data)
    }
    
    func downloadDataRandom() async {
        beginDownloadDataRandom()
        
        do {
            if let data = try await downloadDataImageTask?.value {
                showImageData(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
        downloadDataImageTask = nil
    }
}
