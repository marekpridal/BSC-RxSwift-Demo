//
//  NoteDetailViewController.swift
//  BSC
//
//  Created by Marek Pridal on 26.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class NoteDetailViewController: UIViewController {
    let model = NoteDetailViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var noteTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNoteBinding()
        setupSaveBinding()
        noteTextView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let note = model.note.value {
            model.update(note: note.changeTitle(newTitle: noteTextView.text))
            print("Saving updated note \(note)")
        }
        view.endEditing(true)
    }

    private func setupNoteBinding() {
        model.note.map { $0?.title }.bind(to: noteTextView.rx.text).disposed(by: disposeBag)
    }

    private func setupSaveBinding() {
        navigationItem.rightBarButtonItem?.rx.tap.bind {
            [weak self] in
            guard let self = self else { return }
            let newNote = NoteTO(id: nil, title: self.noteTextView.text)
            self.model.new(note: newNote)
            print("Saving new note \(newNote)")
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}

extension NoteDetailViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
