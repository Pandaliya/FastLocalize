//
//  WordsTableController.swift
//  FastLocalize_Example
//
//  Created by pan zhang on 2022/10/31.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import FastLocalize

class WordsTableController: UITableViewController {
    var word: String = ""
    
    convenience init(word: String) {
        self.init(style: .plain)
        self.word = word
    }
    
    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Actions
    
    // MARK: - Datas
    
    // MARK: - Views
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WordLanguages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordsTableController") ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "WordsTableController")
        
        if indexPath.row < WordLanguages.count {
            let lang = WordLanguages[indexPath.row]
            cell.textLabel?.text = self.word.localized(langage: WordLanguages[indexPath.row])
            cell.detailTextLabel?.text = lang.title
        }
        
        return cell
    }
    
    func setupViews() {
        
    }
    
    func setupConstraints() {
        
    }
    
    // MARK: - Lazy
}

