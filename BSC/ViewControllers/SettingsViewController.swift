//
//  SettingsViewController.swift
//  BSC
//
//  Created by Marek Pridal on 26.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift

final class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var englishLanguageButton: UIButton!
    @IBOutlet private weak var czechLanguageButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        englishLanguageButton.setTitle("EnglishLanguage".localized, for: .normal)
        czechLanguageButton.setTitle("CzechLanguage".localized, for: .normal)
        
        englishLanguageButton.rx.tap.bind{ Language.language = .english }.disposed(by: disposeBag)
        czechLanguageButton.rx.tap.bind{ Language.language = .czech }.disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss".localized, style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.rx.tap.bind { [weak self] in self?.dismiss(animated: true, completion: nil) }.disposed(by: disposeBag)
    }

}

extension SettingsViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
