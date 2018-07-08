import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    private let urlField = UITextField()
    private let currentTime = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "Enter a URL"
        label.textAlignment = .center
        self.view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin).offset(50)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-40)
        }

        urlField.borderStyle = .roundedRect
        urlField.text = "https://www.google.com"
        self.view.addSubview(urlField)
        
        urlField.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin).offset(80)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-40)
        }

        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.setTitle("Fetch URL", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(fetchUrl), for: .touchUpInside)

        self.view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin).offset(130)
            make.centerX.equalTo(self.view)
            make.width.equalTo(120)
        }
        
        let button2 = UIButton()
        button2.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderWidth = 1
        button2.layer.cornerRadius = 4
        button2.setTitle("History", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.addTarget(self, action: #selector(openSummary), for: .touchUpInside)
        
        self.view.addSubview(button2)
        
        button2.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin).offset(180)
            make.centerX.equalTo(self.view)
            make.width.equalTo(120)
        }
    }
    
    @objc open func fetchUrl() {
        NSLog("GET \(urlField.text!)")
        Alamofire.request(urlField.text!, method: .get).responseString { response in
            var request = [String: Any]()
            
            request["url"] = self.urlField.text!
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            request["time"] = dateFormatterPrint.string(from: self.currentTime)
            request["status"] = response.response!.statusCode

            let alert = UIAlertController(title: "Success", message: "Click 'History' to view recorded requests", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { handlerAction in
                
                // TODO: Work out why this sometimes isn't executed.
                if var requests = KeyValue.get("requests").array {
                    requests.insert(JSON(request), at: 0)
                    KeyValue.put("requests", JSON(requests))
                }
                else {
                    KeyValue.put("requests", JSON([request]))
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc open func openSummary() {
        self.present(HistoryController(), animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

