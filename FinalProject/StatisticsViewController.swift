//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by dp on 7/14/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    var alive = 0
    var died = 0
    var born = 0
    var empty = 0
    var prevGrid: GridProtocol = Grid(0,0)
    @IBOutlet weak var lblDied: UILabel!
    @IBOutlet weak var lblBorn: UILabel!
    @IBOutlet weak var lblAlive: UILabel!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBAction func btnReset(_ sender: UIButton) {
        resetVals()
        updateTable()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setupListener() {
        let name = Notification.Name("notification.name.broadcast")
        let notificationSelector = #selector(notified(notification:))
        NotificationCenter.default.addObserver(self,
                                               selector: notificationSelector,
                                               name: name,
                                               object: nil)
        print("Notification On")
    }
    
    func cancelListener() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func notified(notification: Notification) {
        guard let grid = notification.userInfo?["grid"] as? GridProtocol else {
            print("Notification broke")
            return
        }
        if prevGrid.size != grid.size{
            prevGrid = Grid(grid.size.rows, grid.size.cols)
            resetVals()
        }
        alive += grid.getNumDif(of: .alive, vs: prevGrid)
        died += grid.getNumDif(of: .died, vs: prevGrid)
        born += grid.getNumDif(of: .born, vs: prevGrid)
        empty += grid.getNumDif(of: .empty, vs: prevGrid)
        prevGrid = grid
        updateTable()
    }
    func updateTable(){
        lblAlive.text = "\(alive)"
        lblDied.text = "\(died)"
        lblBorn.text = "\(born)"
        lblEmpty.text = "\(empty)"
    }
    func resetVals(){
        alive = 0
        died = 0
        born = 0
        empty = 0
    }

}
