import UIKit
import SnapKit
import SwiftyJSON

class HistoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var requests: [JSON]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        
        requests = KeyValue.get("requests").arrayValue
        
        self.tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        
        self.view.addSubview(tableView)
        
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)

        self.view.addSubview(button)

        button.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.bottomMargin).offset(-80)
            make.centerX.equalTo(self.view)
            make.width.equalTo(120)
        }
        
        let timeLabel = UILabel()

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        timeLabel.text = "Current time: \(dateFormatterPrint.string(from: Date()))"
        
        self.view.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.bottomMargin).offset(-30)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin).offset(50)
            make.bottom.equalTo(button.snp.top).offset(-60)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-40)
        }
    }
    
    @objc open func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let request = requests[indexPath.row]
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryCell {
            cell.textLabel?.text = request["url"].string
            cell.detailTextLabel?.text = request["time"].string
            
            // TODO: Find out why the checkmark is never shown.
            if request["viewed"].boolValue {
                cell.accessoryType = .checkmark
            }
            
            return cell
        }
        else {
            let cell = HistoryCell(style: .subtitle, reuseIdentifier: "HistoryCell")
            
            cell.textLabel?.text = request["url"].string
            cell.detailTextLabel?.text = request["time"].string
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var request = requests[indexPath.row]
        
        self.present(DetailController(request: request), animated: true, completion: nil)
        
        request["viewed"] = true
        
        tableView.reloadData()
    }
}

