//
//  StandardEngine.swift
//  Assignment4
//
//  Created by dp on 7/14/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StandardEngine: EngineProtocol {
    var delegate: EngineDelegate?
    var grid: GridProtocol{
        didSet{
            delegate?.engineDidUpdate(engine: StandardEngine.shared)
            let notificationName = Notification.Name("notification.name.broadcast")
            NotificationCenter.default.post(name: notificationName,
                                            object: nil,
                                            userInfo: ["grid" : grid])
        }
    }
    var refreshRate: Double = 5.0
    var refreshTimer : Timer?
    var rows: Int{
        didSet{
                grid = Grid(rows,cols)
        }
    }
    var cols: Int{
        didSet{
            grid = Grid(rows,cols)
        }
    }
    static var shared = StandardEngine()
    required init(rows: Int = 10, cols: Int = 10) {
        grid = Grid(rows, cols)
        refreshTimer = nil
        self.rows = rows
        self.cols = cols
        self.delegate = nil
    }
    func step() -> GridProtocol {
        grid = grid.next()
        return grid;
    }
    
}
