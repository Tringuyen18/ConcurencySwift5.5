//
//  HomeViewModel.swift
//  ConcurenCy
//
//  Created by Trí Nguyễn on 23/12/2021.
//

import Foundation
import UIKit
import Combine

@MainActor
class HomeViewModel  {
    
    // MARK: - Properties
    @Published var image: UIImage?
    
    let imageURL = "https://photo-cms-viettimes.zadn.vn/w1280/Uploaded/2021/aohuooh/2019_03_16/chum_anh_chung_to_meo_bi_ngao_da_la_co_that_158278544_1632019.png"
    
    // MARK: - Actions
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        fetchImage(url: URL(string: imageURL)!) { image in
//            DispatchQueue.main.async {
//                completion(image)
//            }
            async {
                completion(image)
            }
        }
    }
    
    func loadImage2() {
        fetchImage(url: URL(string: imageURL)!) { image in
//            DispatchQueue.main.async {
//                self.image = image
//            }
            async {
                self.image = image
            }
        }
    }
    
    // Async-await
    func loadImage3() async {
        do {
            image = try await fetchImage(url: URL(string: imageURL)!)
        } catch {
            print("ViewModel: loi")
        }
    }
    
    // MARK: - API
    private func fetchImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
        .resume()
    }
    
    // API Async/await
    func fetchImage(url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
    
}
