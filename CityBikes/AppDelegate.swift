//
//  AppDelegate.swift
//  CityBikes
//
//  Created by Thoang Tran on 11/6/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//
///GGGGGGGGGGGGGGGG

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dict_CountryId_Cities : NSMutableDictionary = NSMutableDictionary()
     var dict_myFavorite = NSMutableDictionary()
    
    /**
     -----------------------------
     - Read data from API for HomeViewController
     - Read data from plist file for Photo Library
     -----------------------------
    **/
    var dict_photo_Names: NSMutableDictionary = NSMutableDictionary()
    //var dict_Stations_Data: NSMutableDictionary = NSMutableDictionary()
    var dict_New_City_Id : NSMutableDictionary = NSMutableDictionary()
    var dict_CityNames: NSMutableDictionary = NSMutableDictionary()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        var regionData: Data
        let apiUrl = "https://api.citybik.es/v2/networks?fields=id,location"
        let regionDataReturned: Data? = try? Data(contentsOf: URL(string: apiUrl)!)
        if let regionDataObtained = regionDataReturned {
            regionData = regionDataObtained
        } else {
            return false;
        }
        let jsonDict : NSDictionary = (try! JSONSerialization.jsonObject(with: regionData, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        var resultsArray = [NSDictionary]()
        if let tempArray = jsonDict.value(forKey: "networks") as? Array<NSDictionary> {
            resultsArray = tempArray
        }
        for item in resultsArray {
            if item.allKeys.count != 0 {
                let locationDict = item.value(forKey: "location") as! NSDictionary
                let countryCode = locationDict.value(forKey: "country") as! String
                let city = locationDict.value(forKey: "city") as! String
                let cityId = item.value(forKey: "id") as! String
                let dict_city_id : NSMutableDictionary = NSMutableDictionary()
                
                dict_city_id.setValue(cityId, forKey: city)
                
                if dict_CountryId_Cities.value(forKey: countryCode) != nil {
                    var tempArray = dict_CountryId_Cities.value(forKey: countryCode) as! Array<NSDictionary>
                    //let tempDict = dict_CountryId_Cities.value(forKey: countryCode) as! NSDictionary
                    //                 tempDict.setValue(cityId, forKey: city)
                    var tempArrayA = dict_CityNames.value(forKey: countryCode) as! Array<String>
                    tempArray.append(dict_city_id)
                    tempArrayA.append(city)
                    dict_CountryId_Cities.setValue(tempArray, forKey: countryCode)
                    //                dict_New_City_Id.setValue(tempDict, forKey: countryCode)
                    dict_CityNames.setValue(tempArrayA, forKey: countryCode)
                    
                }
                    
                else
                {
                    var tempArray = [NSDictionary]()
//                    let tempDict = NSDictionary()
                    var tempArrayA = [String]()
                    tempArray.append(dict_city_id)
                    //                tempDict.setValue(cityId, forKey: city)
                    tempArrayA.append(city)
                    dict_CountryId_Cities.setValue(tempArray, forKey: countryCode)
                    dict_CityNames.setValue(tempArrayA, forKey: countryCode)
                    //                dict_New_City_Id.setValue(tempDict, forKey: countryCode)
                }
            }
        }
        
        // Use for photos.plist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/photos.plist"
        
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            dict_photo_Names = dictionaryFromFileInDocumentDirectory
        }
        else {
            let plistFilePathInMainBundle = Bundle.main.path(forResource: "photos", ofType: "plist")
            
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            
            dict_photo_Names = dictionaryFromFileInMainBundle!
            //let keys = dict_photo_Names.allKeys as? [String]
            //print(keys)
        }
        
        // ---- MY FAVORITE
       
        let pathss = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPaths = pathss[0] as String
        let myFavoritePlistFilePathInDocumentDirectory = documentDirectoryPaths + "/MyFavorite.plist"
        let myFavoriteDictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: myFavoritePlistFilePathInDocumentDirectory)
        if let dictionaryFromFileInDocumentDirectory = myFavoriteDictionaryFromFile {
            
            // MyFavoriteTheaters.plist exists in the Document directory
            dict_myFavorite = dictionaryFromFileInDocumentDirectory
            
        } else {
            let plistFilePathInMainBundle = Bundle.main.path(forResource: "MyFavorite", ofType: "plist")
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            dict_myFavorite = dictionaryFromFileInMainBundle!
        }
        
        
        /**
         -----------------------------
         Read data from API for HomeViewController
         -----------------------------
         **/
        //readAPI()
        
        
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/photos.plist"
        let plistFilePathInDocumentDirectoryForMyFavorite = documentDirectoryPath + "/MyFavorite.plist"
        dict_photo_Names.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        dict_myFavorite.write(toFile: plistFilePathInDocumentDirectoryForMyFavorite, atomically: true)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    /**
     -----------------------------
     Read data from API for HomeViewController
     -----------------------------
     **/
    /*func readAPI() {
        
        let apiURL = "https://api.citybik.es/v2/networks/citi-bike-nyc"
        
        let url: URL? = URL(string: apiURL)
        
        let jsonData: Data?
        
        do {
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
        }
        catch {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the first JSON data file to get imagename, poster, and ID!")
            return
        }
        
        if let jsonDataFromApiURL = jsonData {
            
            let jsonDataDict = try? JSONSerialization.jsonObject(with: jsonDataFromApiURL, options: []) as? [String: Any]
            
            if let dictionaryStatus = jsonDataDict as? Dictionary<String, AnyObject> {
                
                if let network = dictionaryStatus["network"] as? Dictionary<String, AnyObject> {
                    
                    if let stations = network["stations"] as? [[String: AnyObject]] {
                        
                        var freebike: Int = 0
                        var empty_slots: Int = 0
                        var name: String = ""
                        var long: Double = 0.0
                        var lat: Double = 0.0
                        
                        for station in stations {
                            
                            //Empty slots
                            if station["empty_slots"] is NSNull {
                                empty_slots = 0
                            }
                            else {
                                empty_slots = station["empty_slots"] as! Int
                            }
                            
                            //Freebike
                            if station["free_bikes"] is NSNull {
                                freebike = 0
                            }
                            else {
                                freebike = station["free_bikes"] as! Int
                            }
                            
                            //Station Name
                            if station["name"] is NSNull {
                                name = ""
                            }
                            else {
                                name = station["name"] as! String
                            }
                            
                            //Longtitude
                            if station["longitude"] is NSNull {
                                long = 0.0
                            }
                            else {
                                long = station["longitude"] as! Double
                            }
                            
                            //Longtitude
                            if station["latitude"] is NSNull {
                                lat = 0.0
                            }
                            else {
                                lat = station["latitude"] as! Double
                            }
                            
                            let stationData = [freebike, empty_slots, long, lat] as [Any]
                            dict_Stations_Data[name] = stationData
                        }
                    }
                    
                }
            }
        }
    }*/
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        //present(alertController, animated: true, completion: nil)
    }
}

