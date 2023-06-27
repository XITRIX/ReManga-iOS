//
//  MangaDetailsMakeCommentCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.06.2023.
//

import MvvmFoundation
import RxBiBinding
import UIKit

class MangaDetailsMakeCommentCell<VM: MangaDetailsMakeCommentViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var commentContainer: UIView!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var placeholderLabel: UILabel!
    @IBOutlet private var sendButton: UIButton!

    private lazy var delegates = Delegates(parent: self)

    override func initSetup() {
        textView.delegate = delegates

        commentContainer.layer.cornerRadius = 16
        commentContainer.layer.cornerCurve = .continuous

        backgroundConfiguration = defaultBackgroundConfiguration()
        backgroundConfiguration?.backgroundColor = .clear
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            textView.rx.text <-> viewModel.commentText
            placeholderLabel.rx.isHidden <- viewModel.commentText.map { !$0.isNilOrEmpty }
            sendButton.rx.isEnabled <- viewModel.commentText.map { !$0.isNilOrEmpty }
        }
    }
}

private extension MangaDetailsMakeCommentCell {
    class Delegates: DelegateObject<MangaDetailsMakeCommentCell>, UITextViewDelegate {
        func textViewDidChange(_ textView: UITextView) {
            parent.invalidateIntrinsicContentSize()
        }
    }
}
