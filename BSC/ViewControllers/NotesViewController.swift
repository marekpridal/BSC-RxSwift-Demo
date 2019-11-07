//
//  NotesViewController.swift
//  BSC
//
//  Created by Marek Pridal on 25.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class NotesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private let refreshControl = UIRefreshControl()

    let model = NotesViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()
        setupTableViewDataSource()
        bindModelDelete()
        bindModelSelection()
        bindError()
        setupAddNewNote()
        setupSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRows = tableView.indexPathsForSelectedRows {
            selectedRows.forEach { indexPath in
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl

        refreshControl.rx.controlEvent(UIControl.Event.valueChanged).asDriver().drive(onNext: {
            [weak self] in
            self?.refreshControl.beginRefreshing()
            self?.model.refreshData()
        }).disposed(by: disposeBag)
    }

    private func setupTableViewDataSource() {
        model.notes.observeOn(MainScheduler.asyncInstance).bind { [weak self] _ in
            self?.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)

        model.notes.bind(to: tableView.rx.items(cellIdentifier: Identifier.noteCell)) { _, note, cell in
            cell.textLabel?.text = note.title
        }.disposed(by: disposeBag)
    }

    private func bindModelSelection() {
        tableView.rx.modelSelected(NoteTO.self).observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] note in
            let noteDetailVC = NoteDetailViewController.instantiate()
            noteDetailVC.model.note.accept(note)
            self?.bindNoteError(model: noteDetailVC.model)
            self?.navigationController?.pushViewController(noteDetailVC, animated: true)
        }).disposed(by: disposeBag)
    }

    private func bindModelDelete() {
        tableView.rx.modelDeleted(NoteTO.self).subscribe(onNext: { [weak self] note in
            print("Deleted note \(note)")
            self?.model.delete(note: note)
        }).disposed(by: disposeBag)
    }

    private func bindError() {
        model.error.observeOn(MainScheduler.asyncInstance).subscribe(onNext: { error in
            let alertVC = UIAlertController(title: "ALERT_TITLE".localized, message: error.localizedDescription, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    private func setupAddNewNote() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let navigationController = UINavigationController()
            let noteDetailVC = NoteDetailViewController.instantiate()
            self.bindNoteError(model: noteDetailVC.model)
            noteDetailVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
            noteDetailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: nil, action: nil)
            noteDetailVC.navigationItem.leftBarButtonItem?.rx.tap.bind { noteDetailVC.dismiss(animated: true, completion: nil) }.disposed(by: self.disposeBag)
            navigationController.viewControllers = [noteDetailVC]
            navigationController.modalPresentationStyle = .popover
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }

    private func bindNoteError(model: NoteDetailViewModel) {
        model.error.observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] error in
            let alertVC = UIAlertController(title: "ALERT_TITLE".localized, message: error.localizedDescription, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
            self?.navigationController?.present(alertVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    private func setupSettings() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings".localized, style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.rx.tap.bind {
            [weak self] in
            guard let self = self else { return }
            let navigationController = UINavigationController()
            let settingsVC = SettingsViewController.instantiate()
            navigationController.viewControllers = [settingsVC]
            navigationController.modalPresentationStyle = .popover
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}
