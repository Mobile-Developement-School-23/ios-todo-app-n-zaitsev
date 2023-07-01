//
//  Coordinator.swift
//

import UIKit

public protocol Coordinator : AnyObject {

    var childCoordinators: [Coordinator] { get set }

    init(navigationController:UINavigationController)

    func start()
}
