//
//  GridView.swift
//  Assignment4
//
//  Created by dp on 7/6/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

@IBDesignable

class GridView: UIView {

    var grid: GridProtocol = Grid(10,10) {
        didSet {
            
            rows = grid.size.rows
            cols = grid.size.cols
            setNeedsDisplay()
        }
    }
    var togCell = (-1,-1)
    @IBInspectable var rows: Int = 10
    @IBInspectable var cols: Int = 10
    @IBInspectable var livingColor: UIColor = UIColor.blue
    @IBInspectable var emptyColor: UIColor = UIColor.white
    @IBInspectable var bornColor: UIColor = UIColor.green
    @IBInspectable var diedColor: UIColor = UIColor.black
    @IBInspectable var gridColor: UIColor = UIColor.red
    @IBInspectable var gridWidth: CGFloat = 1.0
    
    
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let gridPath = UIBezierPath()
        if rows <= 0 || cols <= 0{
            return
        }
        for pos in 0...rows {
            gridPath.move(to: CGPoint(x: (getSpace(of:"rows",rect) * (CGFloat)(pos)), y: 0))
            gridPath.addLine(to: CGPoint(x: (getSpace(of:"rows",rect) * (CGFloat)(pos)), y: rect.height))
        }
        for pos in 0...cols {
            gridPath.move(to: CGPoint(x: 0, y: (getSpace(of:"cols",rect) * (CGFloat)(pos))))
            gridPath.addLine(to: CGPoint(x: rect.width, y: (getSpace(of:"cols",rect) * (CGFloat)(pos))))
        }
        
        gridPath.lineWidth = CGFloat(gridWidth)
        gridColor.setStroke()
        gridPath.stroke()
        gridPath.fill()
        _ = (0...rows).map{ pos in
            _ = (0...cols).map{ pos2 in
                let circlePath = UIBezierPath(arcCenter: getMid(of: (pos,pos2), of: rect),
                                              radius: ((rows < cols ? getSpace(of:"cols",rect)/2: getSpace(of:"rows",rect)/2) - gridWidth),
                                              startAngle: CGFloat(0),
                                              endAngle:CGFloat(Double.pi * 2),
                                              clockwise: true)
                var color: UIColor
                switch(grid[pos,pos2]){
                case .alive: color = livingColor
                case .born: color = bornColor
                case .died: color = diedColor
                default: color = emptyColor
                }
                color.setStroke()
                circlePath.stroke()
                color.setFill()
                circlePath.fill()
            }
        }
    }
    func getSpace(of: String, _ rect: CGRect) -> CGFloat{
        return of == "rows" ? rect.width/CGFloat(rows) : rect.height/CGFloat(cols)
    }
    func getMid(of point: (Int,Int), of rect: CGRect) -> CGPoint{
        let divX = getSpace(of:"rows",rect)
        let divY = getSpace(of:"cols",rect)
        let x = divX * CGFloat(point.0) + 0.5 * divX
        let y = divY * CGFloat(point.1) + 0.5 * divY
        return CGPoint(x: x, y: y)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = getTouch(touches), rows > 0, cols > 0 else{return}
        updateGrids(point: touch)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = getTouch(touches), rows > 0, cols > 0 else{return}
        let x = touch.0
        let y = touch.1
        if togCell != touch && x < rows && y < cols && x >= 0 && y >= 0{
            updateGrids(point: touch)
        }
    }
    func getTouch(_ touches: Set<UITouch>) -> (Int, Int)?{
        guard let touchPosition = touches.first?.location(in:self) else{return nil}
        let x = Int(touchPosition.x / getSpace(of:"rows",frame))
        let y = Int(touchPosition.y / getSpace(of:"cols",frame))
        return(x,y)
    }
    func updateGrids(point: (Int, Int)){
        let x = point.0
        let y = point.1
        grid[x,y] = grid[x,y].toggle(value: grid[x,y])
        StandardEngine.shared.grid[x,y] = grid[x,y]
        togCell = (x,y)
        self.setNeedsDisplay()
    }
}
