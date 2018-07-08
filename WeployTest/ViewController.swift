import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

// Things that should not be changed:
// - Do not change the use of JSON to store data and as a model for presentation.
// - Do not use Storyboard or Interface Builder
//
// Apart from that, change everything that you feel is:
// - buggy
// - messy
// - repetitive
// - hard to understand/maintain
//
// This app is fully functional. You are not expected to change the functionality except for the bug fixing. Most of
// the bugs are obvious and can be found just by using the app or by reading the code. Where it is not obvious,
// we've put a TODO comment in the code to explain how that part of the code is supposed to function.
class ViewController: UIViewController {
    private let urlField = UITextField()

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
            
            request["time"] = dateFormatterPrint.string(from: Date())
            request["status"] = response.response!.statusCode

            if var requests = KeyValue.get("requests").array {
                requests.insert(JSON(request), at: 0)
                KeyValue.put("requests", JSON(requests))
            }
            else {
                KeyValue.put("requests", JSON([request]))
            }

            let alert = UIAlertController(title: "Success", message: "Click 'History' to view recorded requests", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
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

