//
//  ViewController.swift
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()
        view.backgroundColor = .cyan
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = TaskDetailsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}
