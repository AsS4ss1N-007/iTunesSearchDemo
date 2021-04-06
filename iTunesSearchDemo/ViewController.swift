//
//  ViewController.swift
//  iTunesSearchDemo
//
//  Created by Sachin's Macbook Pro on 06/04/21.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    fileprivate var songsArr: SongInfo?
    fileprivate var data = [Result]()
    
    fileprivate let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        return tableView
    }()
    var searchBar = UISearchBar(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width - 20, height: 70))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "iTunes Demo"
        configureUI()
    }
    
    private func configureUI(){
        setupSearchBar()
        searchBar.becomeFirstResponder()
        tabelViewLayout()
        tableviewDelegates()
    }
    
    private func tabelViewLayout(){
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func tableviewDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchBar(){
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        searchBar.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        searchBar.showsScopeBar = true
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "Search any artist"
        view.addSubview(searchBar)
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        if let songName = data[indexPath.item].trackName, let singer = data[indexPath.item].artistName{
            cell.textLabel?.text = "\(songName)   \(singer)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController{
    func searchBarTextShouldBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.data.removeAll()
        let searchedText = String((searchBar.text?.filter { !" \n\t\r".contains($0) })!)
        APIServices.shared.fetchSongs(term: searchedText) { (info) in
            if let data = info.results{
                self.data = data
                print(self.data)
                for item in self.data {
                    if ((item.artistName?.lowercased().contains(searchedText.lowercased())) != nil){
                        self.data.append(item)
                        self.tableView.reloadData()
                    }
                }
                
                if (searchBar.text!.isEmpty) {
                    self.data = []
                    self.tableView.reloadData()
                }
            }
        }
        
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text!.isEmpty) {
            self.data = []
        }
        self.tableView.reloadData()
    }
}
