//
//  NoteDetailViewController.swift
//  BSC
//
//  Created by Marek Pridal on 26.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class NoteDetailViewController: UIViewController {
    let viewModel: NoteDetailViewModel

    private lazy var noteTextView: UITextView = {
       UITextView()
    }()
    private let disposeBag = DisposeBag()

    init(viewModel: NoteDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupNoteBinding()
        setupSaveBinding()
        noteTextView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let note = viewModel.note.value {
            let updatedNote = note.changeTitle(newTitle: noteTextView.text)
            viewModel.update(note: updatedNote)
            print("Saving updated note \(updatedNote)")
        }
        view.endEditing(true)
    }

    private func setupLayout() {
        view.addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        noteTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        noteTextView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupNoteBinding() {
        viewModel.note.map { $0?.title }.bind(to: noteTextView.rx.text).disposed(by: disposeBag)
    }

    private func setupSaveBinding() {
        navigationItem.rightBarButtonItem?.rx.tap.bind {
            [weak self] in
            guard let self = self else { return }
            let newNote = Note(id: nil, title: self.noteTextView.text)
            self.viewModel.new(note: newNote)
            print("Saving new note \(newNote)")
        }.disposed(by: disposeBag)
    }
}
