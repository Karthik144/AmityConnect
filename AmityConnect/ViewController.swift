//
//  ViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/3/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var accountTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profileTableView.register(PInfoCell.nib(), forCellReuseIdentifier: PInfoCell.identifier)
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        profileTableView.tableFooterView = nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = profileTableView.dequeueReusableCell(withIdentifier: PInfoCell.identifier, for: indexPath) as! PInfoCell
        
        customCell.configure(with: "Profile Information", imageName: "person.circle")
        
    
        return customCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


}


