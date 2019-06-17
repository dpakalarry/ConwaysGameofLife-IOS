//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by dp on 7/14/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit
class SimulationViewController: UIViewController {

    // UI Elements
    @IBOutlet weak var gridView: GridView!
    @IBAction func btnStep(_ sender: Any) {
        StandardEngine.shared.grid = StandardEngine.shared.step()
    }
    @IBAction func butPressed(_ sender: Any) {
        let notificationName = Notification.Name("Save")
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: ["data" : gridView.grid.getAlive()])
    }
    @IBAction func btnReset(_ sender: Any) {
        StandardEngine.shared.grid = Grid(StandardEngine.shared.rows, StandardEngine.shared.cols)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StandardEngine.shared.delegate = self
    }
}

extension SimulationViewController: EngineDelegate {
    func engineDidUpdate(engine: EngineProtocol) {
        gridView.grid = engine.grid as! Grid
        gridView.setNeedsDisplay()
    }
}
