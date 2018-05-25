//
//  NotesViewController.swift
//  BSC
//
//  Created by Marek Pridal on 25.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit
import RxSwift

class NotesViewController: UITableViewController {
    
    let model = NotesViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self;
        self.splitViewController?.preferredDisplayMode = .allVisible
        
        model.request.getNotes().observeOn(MainScheduler.asyncInstance).subscribe(onNext: { (notes) in
            print(notes)
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("Completed")
        }).disposed(by: disposeBag)
    }

}

//MARK: Split view controller
extension NotesViewController : UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.content == self {
            /*
            if let _  = secondaryViewController.content as? NoteDetailViewController {
                return true
            }
            */
        }
        return false
    }
}
