//
//  ViewController.swift
//

import UIKit

class ViewController: UIViewController {

    init(fileCache: FileCache) {
        self.fileCache = fileCache
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .cyan
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let item = fileCache.todoItems.first?.value ?? TodoItem()
        let vc = TaskDetailsViewController(item: item)
        vc.saveItem = { [weak fileCache] newItem in
            fileCache?.add(item: newItem)
            try? fileCache?.save(to: "test", format: .json)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

    private let fileCache: FileCache
}
