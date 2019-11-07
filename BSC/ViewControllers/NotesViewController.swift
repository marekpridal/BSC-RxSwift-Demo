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
    let viewModel: NotesViewModel

    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifier.noteCell)
        return tableView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        .init()
    }()

    init(viewModel: NotesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()
        setupLayout()
        setupTableViewDataSource()
        bindModelDelete()
        bindModelSelection()
        bindError()
        setupAddNewNote()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRows = tableView.indexPathsForSelectedRows {
            selectedRows.forEach { indexPath in
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl

        refreshControl.rx.controlEvent(UIControl.Event.valueChanged).asDriver().drive(onNext: {
            [weak self] in
            self?.refreshControl.beginRefreshing()
            self?.viewModel.refreshData()
        }).disposed(by: disposeBag)
    }

    private func setupTableViewDataSource() {
        viewModel.notes.observeOn(MainScheduler.asyncInstance).bind { [weak self] _ in
            self?.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)

        viewModel.notes.bind(to: tableView.rx.items(cellIdentifier: Identifier.noteCell)) { _, note, cell in
            cell.textLabel?.text = note.title
        }.disposed(by: disposeBag)
    }

    private func bindModelSelection() {
        tableView.rx.modelSelected(Note.self).observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] note in
            self?.viewModel.delegate?.showNoteDetail(note: note, errorHandler: { error in
                DispatchQueue.main.async { [weak self] in
                    let alertVC = UIAlertController(title: "ALERT_TITLE".localized, message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
                    self?.navigationController?.present(alertVC, animated: true, completion: nil)
                }
            })
        }).disposed(by: disposeBag)
    }

    private func bindModelDelete() {
        tableView.rx.modelDeleted(Note.self).subscribe(onNext: { [weak self] note in
            print("Deleted note \(note)")
            self?.viewModel.delete(note: note)
        }).disposed(by: disposeBag)
    }

    private func bindError() {
        viewModel.error.observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] error in
            let alertVC = UIAlertController(title: "ALERT_TITLE".localized, message: error.localizedDescription, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
            self?.present(alertVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    private func setupAddNewNote() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap.bind { [weak self] in
            self?.viewModel.delegate?.showNewNoteForm(errorHandler: { error in
                DispatchQueue.main.async { [weak self] in
                    let alertVC = UIAlertController(title: "ALERT_TITLE".localized, message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
                    self?.navigationController?.present(alertVC, animated: true, completion: nil)
                }
            })
        }.disposed(by: disposeBag)
    }
}
