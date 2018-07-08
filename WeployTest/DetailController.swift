import UIKit
import SnapKit
import SwiftyJSON

class DetailController: UIViewController {
    var request: JSON!
    
    init(request: JSON) {
        super.init(nibName: nil, bundle: nil)
        
        self.request = request
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not necessary since we're not using IB")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        
        let url = URL(string: request["url"].stringValue)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text =  """
        At: \(request["time"].string!)
        Method: GET
        Protocol: \(url!.scheme!)
        Host: \(url!.host!)
        Status: \(request["status"])
        """
        
        self.view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin).offset(120)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-40)
        }
        
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
    }
    
    @objc open func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

