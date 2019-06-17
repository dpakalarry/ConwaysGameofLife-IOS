//
//  EngineProtocol.swift
//  Assignment4
//
//  Created by dp on 7/14/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

protocol EngineProtocol{
    var delegate: EngineDelegate? {get set}
    var grid: GridProtocol{get}
    var refreshRate: Double { get}
    var refreshTimer : Timer?{get set}
    var rows: Int{get set}
    var cols: Int{get set}
    init(rows: Int, cols: Int)
    func step()-> GridProtocol
}

extension EngineProtocol{
    var refreshRate: Double {
        return 0;
    }
}
