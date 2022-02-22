//
//  CityTableViewController.swift
//  CitiesILike
//
//  Created by Osman Balci on 9/27/2018.
//  Copyright © 2018 Osman Balci. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    
    // Instance variable holding the object reference of the UITableView UI object created in the Interface Builder (IB), i.e., Storyboard
    @IBOutlet var countryCityTableView: UITableView!
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //---------- Create and Initialize the Arrays -----------------------
    var dict_Countries_Cities: [NSDictionary] = []
    var dict_CityNames: [NSDictionary] = []
    var countryCodes = [String]()
    var cityNames = [String]()
    var cityIDs = ""
    // dataObjectToPass is the data object to pass to the downstream view controller
    //var dataObjectToPass: [String] = []
    var idToPass = ""
    var countryToPass = ""
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    
        countryCodes = applicationDelegate.dict_CountryId_Cities.allKeys as! [String]
        
        // Sort the country names within itself in alphabetical order
        countryCodes.sort { $0 < $1 }
        for item in countryCodes
        {
            dict_Countries_Cities = applicationDelegate.dict_CountryId_Cities.value(forKey: item) as! Array<NSDictionary>
            for item in dict_Countries_Cities
            {
                let tempCityName = item.allKeys as! [String]
                cityNames.append(tempCityName[0])
            }
        } // end for
        
    }


    /*
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    // We are implementing a Grouped table view style as we selected in the storyboard file.
    
    //----------------------------------------
    // Return Number of Sections in Table View
    //----------------------------------------
    
    // Each table view section corresponds to a country
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return countryCodes.count
    }
    
    //---------------------------------
    // Return Number of Rows in Section
    //---------------------------------
    
    // Number of rows in a given country (section) = Number of Cities in the given country (section)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        // Obtain the name of the given country
        let givenCountryCode = countryCodes[section]
        
        // Obtain the list of cities in the given country as AnyObject
        let cities: AnyObject? = applicationDelegate.dict_CityNames[givenCountryCode] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        let citiesOfGivenCountry = cities! as! [String]
        
        return citiesOfGivenCountry.count
    }
    
    //-----------------------------
    // Set Title for Section Header
    //-----------------------------
    
    // Set the table view section header to be the country name
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        return countryCodes[section]
    }
    
    //-----------------------------
    // Set Title for Section Footer
    //-----------------------------
    
    // Set the table view section footer to "My Favorite Cities in CountryName"
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String {
        
        return "City bikes in " + countryCodes[section]
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableView", for: indexPath) as UITableViewCell
        
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the name of the given country
        let givenCountryName = countryCodes[sectionNumber]
        
        /*
         Note that city names must not be sorted. The order shows how favorite the city is.
         The higher the order the more favorite the city is. The user specifies the ordering
         in the Edit mode by moving a row from one location to another for the same country.
         */
        
        // Obtain the list of cities in the given country as AnyObject
        let cities: AnyObject? = applicationDelegate.dict_CityNames[givenCountryName] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var citiesOfGivenCountry = cities! as! [String]
        
        // Set the cell title to be the city name
        cell.textLabel!.text = citiesOfGivenCountry[rowNumber]
        
        //cell.imageView!.image = UIImage(named: "Favorite.png")
        
        return cell
    }
    
    
    //---------------------------
    // Movement of City Attempted
    //---------------------------
    /*
     This method is invoked to carry out the row (city) movement after the method
     tableView: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath: approved the move.
     */
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
        let countryName = countryCodes[(fromIndexPath as NSIndexPath).section]
        
        // Obtain the list of cities in the country as AnyObject
        let cities: AnyObject? = applicationDelegate.dict_CityNames[countryName] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var citiesOfTheCountry: Array<String> = cities! as! [String]
        
        // Row number to move FROM
        let rowNumberFrom   = (fromIndexPath as NSIndexPath).row
        
        // Row number to move TO
        let rowNumberTo     = (toIndexPath as NSIndexPath).row
        
        // City name to move
        let cityNameToMove  = citiesOfTheCountry[rowNumberFrom]
        
        if rowNumberFrom > rowNumberTo {
            // Movement is from lower part of the list to the upper part
            citiesOfTheCountry.insert(cityNameToMove, at: rowNumberTo)
            citiesOfTheCountry.remove(at: rowNumberFrom + 1)
            
        } else {
            // Movement is from upper part of the list to the lower part
            citiesOfTheCountry.insert(cityNameToMove, at: rowNumberTo + 1)
            citiesOfTheCountry.remove(at: rowNumberFrom)
        }
        
        // Update the new list of cities for the country in the NSMutableDictionary
        applicationDelegate.dict_CityNames.setValue(citiesOfTheCountry, forKey: countryName)
        
        // No need to reload the table view data since the view is updated automatically
    }
    
    
    //-----------------------------------------------------
    // Allow Movement of Rows (Cities) within their Country
    //-----------------------------------------------------
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    //--------------------------
    // Selection of a City (Row)
    //--------------------------
    
    // Tapping a row (city) displays a map of the city
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        // Obtain the name of the country of the selected city
        let selectedCountryName = countryCodes[(indexPath as NSIndexPath).section]
        
        // Obtain the list of cities in the country as AnyObject
        let cities: AnyObject? = applicationDelegate.dict_CityNames[selectedCountryName] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var citiesOfTheCountry = cities! as! [String]
        
        // Obtain the name of the city whose Detail Disclosure button is tapped
        let selectedCityName = citiesOfTheCountry[(indexPath as NSIndexPath).row]
        let tempDict = applicationDelegate.dict_CountryId_Cities.value(forKey: selectedCountryName) as! Array<NSDictionary>
        
        for item in tempDict
        {
            let tempCityName = item.allKeys as! [String]
            if(selectedCityName == tempCityName[0] )
            {
                cityIDs = item.value(forKey: selectedCityName) as! String
            }
        }
        
        countryToPass = selectedCountryName
        // Prepare the data object to pass to the downstream view controller
        //dataObjectToPass[0] = selectedCityName
        //dataObjectToPass[1] = selectedCountryName
        idToPass = cityIDs
        
        // Perform the segue named CityMap
        performSegue(withIdentifier: "ShowStations", sender: self)
    }
    

    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "ShowStations" {
            
            // Obtain the object reference of the destination view controller
            let stationTable: StationsTableViewController = segue.destination as! StationsTableViewController
            
            // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
            stationTable.cityIdObtained = idToPass
            stationTable.countryPassed = countryToPass
        }/*
        else if segue.identifier == "CityMap" {
            
            // Obtain the object reference of the destination view controller
            let cityMapViewController: CityMapViewController = segue.destination as! CityMapViewController
            
            //Pass the data object to the destination view controller object
            cityMapViewController.dataObjectPassed = dataObjectToPass
            
        }*/
    }
    
    
    @IBAction func myFavoriteTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "toFavorite", sender: self)
    }
    
    
    
}

