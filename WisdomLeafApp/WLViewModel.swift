//
//  WLImageViewModel.swift
//  WisdomLeafApp
//
//  Created by Gopi on 15/06/23.
//

import Foundation


class WLViewModel {

    var array: [WLData]?
    var page = 1
    var limit = 20
    var isAllDataLoaded = false
    
    func getWLData(at index: Int) -> WLData? {
        if let arrayData = array {
        return arrayData[index]
        }
        return nil
    }
    
    func getWLDataCount() -> Int {
        if let arrayData = array {
            return arrayData.count
        }
        else {
           return 0
        }
    }
    
    func getCellIsSelectedOrNot(at index: Int) -> Bool {
        if let arrayData = array {
            return arrayData[index].isSelected
        }
        return false
    }
    
    func selectModel(at index: Int) {
        array![index].isSelected.toggle()
    }
    
    func downloadJSON(completed:@escaping ([WLData]) -> ()){
        let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)")
        URLSession.shared.dataTask(with: url!) { data, response, err in
            if err == nil{
                do{
                let wlData = try JSONDecoder().decode([WLData].self, from: data!)
                    self.array = wlData
                    self.isAllDataLoaded = true
                    completed(wlData)
                }
                catch{
                  print("error fetching data from api")
                }
                
            }
        }.resume()
    }
    
}
