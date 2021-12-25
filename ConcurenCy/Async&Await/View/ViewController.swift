//
//  ViewController.swift
//  ViewController
//
//  Created by Nguyễn Trí on 28/08/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let urlString = "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list"
    var drinks: [Category] = [Category(strCategory: "Hello, Tringuyen")]
    
    var drinks2: [[Drink]] = []
    var titles: [String] = ["Origin Drink", "Cocktail", "Cocoa"]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
//        loadAPI1()
//        loadAPI3()
        
//        async {
//            do {
//                drinks = try await loadAPI2()
//                tableView.reloadData()
//            } catch {
//                print("error")
//            }
//        }
        
        // Group APIs
        async {
            do {
                print("--- API With Async Group")
                let urls = [URL(string:         "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink")!,
                            URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail")!,
                            URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocoa")!]
    
                let results: [DrinkResult] = try await fetchAPIs(urls: urls)
                
                for result in results {
                    let items = result.drinks
                    drinks2.append(items)
                }
                
                tableView.reloadData()
                
            } catch {
                print((error as! APIError).localizedDescription)
            }
        }
    }
    
    // MARK: - Config
    private func configureLayout() {
        title = "Bar"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: Completion handle
    func loadAPI1() {
        
        guard let url = URL(string: urlString) else { return }
        
        fetchAPI(url: url) { (result: Result<CategoryResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.drinks.append(contentsOf: result.drinks)
                    
                    for item in result.drinks {
                        print(item.strCategory)
                    }
                    
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    func loadAPI3() {
        async {
            do {
                let url = URL(string: urlString)!
                let result: CategoryResult = try await fetchAPI(url: url)
                
                self.drinks.append(contentsOf: result.drinks)
                
                for item in result.drinks {
                    print(item.strCategory)
                }
                
                self.tableView.reloadData()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // Dung Hoa 2 cach
    func loadAPI2() async throws -> [Category] {
        try await withCheckedThrowingContinuation({ c in
            guard let url = URL(string: urlString) else { return }
            fetchAPI(url: url) { (result: Result<CategoryResult, Error>) in
                switch result {
                case .success(let result):
                    for item in result.drinks {
                        print(item.strCategory)
                    }
                    
                    c.resume(returning: result.drinks)
                    
                case .failure(let error):
                    c.resume(throwing: error)
                }
            }
        })
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        titles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        drinks2.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinks2[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = drinks[indexPath.row].strCategory
        
        cell.textLabel?.text = drinks2[indexPath.section][indexPath.row].strDrink
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Ahiihi!")
    }
}
