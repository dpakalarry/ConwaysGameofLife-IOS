//
//  ConfigViewController.swift
//  FinalProject
//
//  Created by dp on 7/29/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    
    @IBOutlet weak var grid: GridView!
    @IBOutlet weak var txt: UITextField!
    var data: [(Int, Int)] = []
    var new: Bool = true
    var completion: (([(Int, Int)], String?) -> Void)?
    @IBAction func btnSave(_ sender: UIButton) {
        if let completion = completion{
            data = grid.grid.getAlive()
            completion(data, txt.text)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        grid.grid = new ? Grid(StandardEngine.shared.rows,StandardEngine.shared.cols) : grid.grid.newGrid(with: data)
        grid.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
