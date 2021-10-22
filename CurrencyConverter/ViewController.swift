//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by PPEI on 10/21/2564 BE.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fromPView: UIPickerView!
    @IBOutlet weak var toPView: UIPickerView!
    @IBOutlet weak var Rate: UILabel!
    
    var currencyArray:[String] = []
    var rateArray:[Double] = []
    let baseURL = "http://api.exchangeratesapi.io/v1/"
    let apiKey = "548b1416b847653d4ac21ba7fd770fc1"
    var currencyFrom:String = ""
    var currencyTo:String = ""
    var valueFrom:Double = 0
    var valueTo:Double = 0
    var values:[Double] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencyArray.sort()
        return currencyArray[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()// Do any additional setup after loading the view.
        //connect
        toPView.delegate=self
        toPView.dataSource=self
        fromPView.dataSource=self
        fromPView.delegate=self
        // api request
        let session = URLSession(configuration: .default)
        let url = baseURL + "latest?access_key=" + apiKey
        let request = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: request) {(data, response, error) in
            
            if error != nil{
                print("Your network has an error!")
            }
            else if let data = data {
                do {
                    let r = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    let rates = r["rates"] as! NSDictionary
                    
                    for (key, value) in rates {
                        self.currencyArray.append((key as? String)!)
                        self.rateArray.append(value as! Double)
                    }
                    self.currencyFrom = self.currencyArray[0]
                    self.valueFrom = self.rateArray[0]
                    self.currencyTo = self.currencyArray[0]
                    self.valueTo = self.rateArray[0]
                    print(self.currencyArray)
              
                } catch {
                    print("There is an error occuring.")
                    return
                }
            }
            self.fromPView.reloadAllComponents()
            self.toPView.reloadAllComponents()
        }
        task.resume()

        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if (pickerView.tag == 1) {
                currencyFrom = currencyArray[row]
                valueFrom = rateArray[row]
                print(currencyFrom, valueFrom)
            }
            if (pickerView.tag == 2) {
                currencyTo = currencyArray[row]
                valueTo = rateArray[row]
            }
        }
    
    @IBAction func getResult(_ sender: Any) {
        
        let rst:Double = 1/valueFrom * valueTo
        let rstStr = String(format: "%.02f", rst)
        self.Rate.text = rstStr
    }
}

