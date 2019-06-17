//
//  TableViewController.swift
//  FinalProject
//
//  Created by dp on 7/27/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var rows = 10;
    var cols = 10;
    @IBOutlet weak var lblFreq: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var txtRows: UITextField!
    @IBOutlet weak var sldRows: UISlider!
    @IBOutlet weak var sldFreq: UISlider!
    @IBOutlet weak var swtTimer: UISwitch!
    @IBOutlet weak var txtCols: UITextField!
    @IBOutlet weak var sldCols: UISlider!
    @IBOutlet weak var tblConfig: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        setupListener()
        txtRows.text = "10"
        sldRows.value = 10
        txtCols.text = "10"
        sldCols.value = 10
        lblFreq.text = "Refresh Freq: 5.0"
        sldFreq.value = 5.0
        lblTimer.text = "Refresh: false"
        swtTimer.setOn(false, animated: false)
    }
    
    @IBAction func switchTimer(_ sender: UISwitch) {
        lblTimer.text = "Refresh: \(sender.isOn)"
        if sender.isOn{
            StandardEngine.shared.refreshTimer = Timer.scheduledTimer(withTimeInterval: StandardEngine.shared.refreshRate,
                                                                      repeats: true)
            {timer in
                let _ = StandardEngine.shared.step()
            }
        }
        else{
            StandardEngine.shared.refreshTimer?.invalidate()
            StandardEngine.shared.refreshTimer = nil
        }
    }
    @IBAction func sldFreq(_ sender: UISlider) {
        StandardEngine.shared.refreshTimer?.invalidate()
        StandardEngine.shared.refreshTimer = nil
        lblFreq.text = "Refresh Freq: \(round(10*sender.value)/10)"
        StandardEngine.shared.refreshRate = Double(round(10*sender.value)/10)
        if(lblTimer.text == "Refresh: true"){
            StandardEngine.shared.refreshTimer = Timer.scheduledTimer(withTimeInterval: StandardEngine.shared.refreshRate,
                                                                      repeats: true)
            {timer in
                let _ = StandardEngine.shared.step()
            }
        }
    }
    @IBAction func sldRows(_ sender: UISlider) {
        rows = Int(sender.value)
        txtRows.text = "\(rows)"
        StandardEngine.shared.cols = rows
    }
    @IBAction func sldCols(_ sender: UISlider) {
        cols = Int(sender.value)
        txtCols.text = "\(cols)"
        StandardEngine.shared.rows = cols
    }
    @IBAction func txtRowsChange(_ sender: UITextField) {
        guard let text = sender.text,
            let sizeInt = Int(text), sizeInt >= 0 && sizeInt <= 100 else {
                print("Invalid size!")
                sender.text = nil
                return
        }
        
        rows = sizeInt
        sldRows.value = Float(sizeInt)
        StandardEngine.shared.cols = sizeInt
    }
    @IBAction func txtColsChange(_ sender: UITextField) {
        guard let text = sender.text,
            let sizeInt = Int(text), sizeInt >= 0 && sizeInt <= 100 else {
                print("Invalid size!")
                sender.text = nil
                return
        }
        cols = sizeInt
        sldCols.value = Float(sizeInt)
        StandardEngine.shared.rows = sizeInt
    }
    @IBAction func btnAddConfig(_ sender: UIButton) { //Alert Code found from: https://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
        let alert = UIAlertController(title: "New Configuration", message: "Please insert a title for this new configuration", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "Insert title here"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let nDict: NSDictionary = ["title": textField!.text!, "contents": []]
            if self.model != nil{
                self.model?.append(nDict)
                self.tblConfig.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = model{
            return model.count
        } else {
            return 1
        }
    }
    
    func tableView(_ view: UITableView, cellForRowAt: IndexPath) -> UITableViewCell{
        guard let cell = view.dequeueReusableCell(withIdentifier: "patternCell") else{return UITableViewCell()}
        
        if cellForRowAt.row % 2 != 0 {
            cell.backgroundColor = UIColor.blue
            cell.textLabel?.textColor = UIColor.white
        }
        else{
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
        }
        cell.textLabel?.text = "LOADING"
        
        guard let model = model else{return cell}
        let modelInstance = model[cellForRowAt.row] 
        let title = modelInstance["title"] as! String
        cell.textLabel?.text = title
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Configurations"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        return
    }
    
    var model: [NSDictionary]? = nil;
}
extension TableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
}


extension TableViewController{
    func fetch(){
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:"https://dl.dropboxusercontent.com/u/7544475/S65g.json")!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            let jsonArray = json as! NSArray
            OperationQueue.main.addOperation {
                self.model = jsonArray as? [NSDictionary]
                self.tblConfig.reloadData()
            }
        }
    }
}

extension TableViewController{
    func setupListener() {
        let name = Notification.Name("Save")
        let notificationSelector = #selector(notified(notification:))
        NotificationCenter.default.addObserver(self,
                                               selector: notificationSelector,
                                               name: name,
                                               object: nil)
        print("Table NotificationOn")
    }
    func cancelListener() {
        NotificationCenter.default.removeObserver(self)
    }
    func notified(notification: Notification) {
        guard let points = notification.userInfo?["data"] as? [(Int, Int)] else {
            print("Notification broke")
            return
        }
        if let model = self.model{
            if let indexPath = self.tblConfig.indexPathForSelectedRow{
                let modelInstance = model[indexPath.row]
                let title = modelInstance["title"] as! String
                self.model?[indexPath.row] = ["title": title, "contents": points.map{[$0,$1]}]
            }
        }
        
    }
    
}

    // MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
extension TableViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let model = model{
            if let destination = segue.destination as? ConfigViewController {
                if let indexPath = tblConfig.indexPathForSelectedRow{
                    let modelInstance = model[indexPath.row]
                    let data = modelInstance["contents"] as! [[Int]]
                    destination.new = true
                    destination.data = data.map{ pos in
                        destination.new = false
                        return (pos[0], pos[1])
                    }
                    destination.completion = { (data, str) in
                        StandardEngine.shared.grid = StandardEngine.shared.grid.newGrid(with: data)
                        self.rows = StandardEngine.shared.grid.size.cols
                        self.cols = StandardEngine.shared.grid.size.rows
                        self.txtCols.text = "\(self.cols)"
                        self.txtRows.text = "\(self.rows)"
                        self.sldCols.value = Float(self.cols)
                        self.sldRows.value = Float(self.rows)
                        if let model = self.model{
                            if let indexPath = self.tblConfig.indexPathForSelectedRow{
                                let modelInstance = model[indexPath.row]
                                let title = (str == nil) ? (modelInstance["title"] as! String) : str!
                                self.model?[indexPath.row] = ["title": title, "contents": data.map{[$0,$1]}]
                            }
                        }
                        self.tblConfig.reloadData()
                        return
                    }
                }
            }
        }
    }
}
 


