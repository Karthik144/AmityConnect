//
//  ChatViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/29/21.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var myTable: UITableView!

    override func viewDidLoad() {
        // Do any additional setup after loading the view
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "John Smith"
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = MessageViewController()
        vc.title = "Chat"
        navigationController?.pushViewController(vc, animated: true)

    }



}
