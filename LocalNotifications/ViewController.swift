//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Maha saad on 11/05/1443 AH.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var TotalTimeLabel: UILabel!
    
    @IBOutlet weak var houreMinLabel: UILabel!
    
    @IBOutlet weak var timerSetLabl: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    var minutes = ["5 Minutes","10 Minutes","20 Minutes","30 Minutes"]
    var num = [5,10,20,30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        picker.dataSource = self
        picker.delegate = self
        houreMinLabel.isHidden = true
        timerSetLabl.isHidden = true
        time.isHidden = true
        
        

    }
    
    @IBAction func NewDay(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Are you sure its a new day?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let alertOKAction=UIAlertAction(title:"New day", style: UIAlertAction.Style.default,handler: { action  in self.new ()
                })
        let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertAction.Style.destructive,handler: { action in
                   print("Cancel Button Pressed")
                })

            alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        self.present(alert, animated: true, completion: nil)
        
        
            
        }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Cancel current timer?", message: nil, preferredStyle: UIAlertController.Style.alert)

        let alertOKAction=UIAlertAction(title:"Back", style: UIAlertAction.Style.default,handler: { action  in
            print("Back Button Pressed")
                })
        let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertAction.Style.destructive,handler: { action in
            self.cancel()
                })

        alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func StartTimerButton(_ sender: UIButton) {
        
        localNotifications()
        
        let selectedMin = picker.selectedRow(inComponent: 0)
        let alert = UIAlertController(title: "\(num[selectedMin]) min countdown ", message: "After \(num[selectedMin]) Minutes , you will be notified, turn your ringer on  ", preferredStyle: UIAlertController.Style.alert)
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertAction.Style.default,handler: { action in
                print("OK Button Pressed")
                })
            alert.addAction(alertOKAction)
        self.present(alert, animated: true, completion: nil)
        
        TotalTimeLabel.text = "Total time : \(num[selectedMin])"
        houreMinLabel.text = "0 hours , \(num[selectedMin]) min"
        timerSetLabl.text = "\(num[selectedMin]) minutes timer set"
        houreMinLabel.isHidden = false
        timerSetLabl.isHidden = false
        time.isHidden = false
        
        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
    //   let timeString = formatter.string(from: currentTime)
        let addminutes = currentTime.addingTimeInterval(TimeInterval(num[selectedMin] * 60))
        
      //  formatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        let after_add_time = formatter.string(from: addminutes)
        time.text = "Work Until : \(after_add_time)"
        

    }
    
    func new(){
        picker.reloadAllComponents()
        TotalTimeLabel.text = "Total time :0"
        houreMinLabel.text = "0 hours , 0 min"
        timerSetLabl.text = "0 minutes timer set"
        houreMinLabel.isHidden = true
        timerSetLabl.isHidden = true
        time.isHidden = true
   
    }
    func cancel(){
        let selectedMin = picker.selectedRow(inComponent: 0)
        picker.reloadAllComponents()
        timerSetLabl.text = "\(num[selectedMin]) minutes timer cancelled"
        time.isHidden = true
    }
    
    func localNotifications(){
        let selectedMin = picker.selectedRow(inComponent: 0)
        //ask for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert,.sound]) { (granted, error) in
        }
        //create notification content
        let content = UNMutableNotificationContent()
        content.title = "Time End"
        content.body = "Stop Working"
        //create notifications trigger
        //
        let d = Date().addingTimeInterval(TimeInterval(num[selectedMin] * 60))
        let dateComponents = Calendar.current.dateComponents([.year , .month ,.day ,.hour ,.minute ,.second], from: d)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false )
        //create request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        //register the request
        center.add(request){ (error) in
            //pppp
            
        }
        
    }
}

extension ViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutes.count
    }
}

extension ViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return minutes[row]
    }
}




