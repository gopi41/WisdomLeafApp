//
//  ViewController.swift
//  WisdomLeafApp
//
//  Created by Gopi on 15/06/23.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    let viewModel = WLViewModel()
    let pullToRefresh = UIRefreshControl()
    @IBOutlet weak var wlTableView: UITableView!{
        didSet {
            wlTableView.delegate = self
            wlTableView.dataSource = self
            wlTableView.register(UINib(nibName: "WLTableViewCell",
                                            bundle: nil),
                                      forCellReuseIdentifier: "WLTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WisdomLeaf Data"
        self.refreshData {
            // do nothing
            print("API is called")
        }
        self.pullToRefresh.addTarget(self, action: #selector(handleTopRefresh(_:)), for: .valueChanged)
        self.pullToRefresh.tintColor = UIColor.blue
        wlTableView.addSubview(pullToRefresh)
    }
    
    @objc
    func handleTopRefresh(_ sender: UIRefreshControl) {
        loadAPIData()
    }
    
    func refreshData(completion: @escaping() ->()) {
        viewModel.downloadJSON { images in
            DispatchQueue.main.async { [self] in
                self.viewModel.array = images
                self.wlTableView.reloadData()
                completion()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getWLDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wlTableView.dequeueReusableCell(withIdentifier: "WLTableViewCell", for: indexPath) as! WLTableViewCell
        cell.selectionStyle = .none
        if let data = self.viewModel.getWLData(at: indexPath.row) {
            cell.setUpCell(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.getCellIsSelectedOrNot(at: indexPath.row) {
            let alert = UIAlertController(title: "Unselect", message: "Do you wants to unselect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "yes", style: UIAlertAction.Style.default, handler: {_ in
                self.viewModel.selectModel(at: indexPath.row)
                self.wlTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "no", style: UIAlertAction.Style.default, handler: {_ in
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showAlert(index: indexPath.row)
        }

    }
    
    func showAlert(index: Int) {
        let alertController = UIAlertController(title: "Oops", message: "please select the Image", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.viewModel.selectModel(at: index)
            self.wlTableView.reloadData()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height) {
            if viewModel.isAllDataLoaded {
                self.viewModel.page += 1
                self.loadAPIData()
            }
        }
    }
    
}

extension ViewController {
    func loadAPIData() {
        self.refreshData {
            self.pullToRefresh.endRefreshing()
            self.wlTableView.reloadData()
        }
 
    }
}

