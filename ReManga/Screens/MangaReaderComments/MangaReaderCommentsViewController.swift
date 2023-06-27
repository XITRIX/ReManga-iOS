//
//  MangaReaderComments.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.06.2023.
//

import MvvmFoundation
import RxBiBinding
import UIKit

class MangaReaderCommentsViewController<VM: MangaReaderCommentsViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!

    @IBOutlet private var commentView: CustomUIView!
    @IBOutlet private var sendButton: UIButton!
    @IBOutlet private var textView: FlexibleTextView!
    @IBOutlet private var commentContainer: UIView!
    @IBOutlet private var placeholderLabel: UILabel!

    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)
    private let dismissItem = UIBarButtonItem(systemItem: .close)

    private lazy var keyboardToken = KeyboardHandler(collectionView)

    private lazy var delegates = Delegates(parent: self)

    deinit {
        print("\(Self.self) deinited")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        #if !os(xrOS)
        if let sheet = navigationController?.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
        }
        #endif

        keyboardToken.onKeyboardWillChangeFrame = { [weak self] status in
            guard let self else { return }

            collectionView.contentInset.bottom = keyboardToken.requiredBottomInset + commentContainer.bounds.height + collectionView.layoutMargins.bottom
            collectionView.verticalScrollIndicatorInsets.bottom = collectionView.contentInset.bottom

            UIView.animate(withDuration: status.animationDuration, delay: 0, options: status.animationCurve) {
                self.view.layoutIfNeeded()
            }
        }

        textView.innerView = commentView
        textView.maxHeight = 90

        textView.delegate = delegates

        commentContainer.layer.cornerRadius = 16
        commentContainer.layer.cornerCurve = .continuous

        navigationItem.trailingItemGroups.append(.fixedGroup(items: [dismissItem]))

        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)

        bind(in: disposeBag) {
            dataSource.applyModels <- viewModel.items
            viewModel.dismiss <- dismissItem.rx.tap

            textView.rx.text <-> viewModel.commentText
            placeholderLabel.rx.isHidden <- viewModel.commentText.map { !$0.isNilOrEmpty }
            sendButton.rx.isEnabled <- viewModel.commentText.map { !$0.isNilOrEmpty }
        }
    }

    override var isModalInPresentation: Bool {
        get { textView.isFirstResponder }
        set {}
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        print("-=-=-= inset: \(keyboardToken.requiredBottomInset)")
        collectionView.contentInset.bottom = keyboardToken.requiredBottomInset + commentContainer.bounds.height + collectionView.layoutMargins.bottom
        collectionView.verticalScrollIndicatorInsets.bottom = collectionView.contentInset.bottom
        
        textView.contentInset.left = 8
        textView.contentInset.right = sendButton.bounds.width + 16 + 8

        textView.verticalScrollIndicatorInsets.right = -0.5
        textView.verticalScrollIndicatorInsets.top = 6
        textView.verticalScrollIndicatorInsets.bottom = 6
    }

//    override var canBecomeFirstResponder: Bool { true }

//    override var inputAccessoryView: UIView? {
//        commentView.translatesAutoresizingMaskIntoConstraints = false
////        testView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////        return testView
//
////        commentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        return commentView
//    }
}

private extension MangaReaderCommentsViewController {
    class Delegates: DelegateObject<MangaReaderCommentsViewController>, UITextViewDelegate {
        func textViewDidChange(_ textView: UITextView) {
            textView.invalidateIntrinsicContentSize()
            UIView.animate(withDuration: 0.2) { [self] in
                parent.view.layoutIfNeeded()
                //                parent.testView.layoutIfNeeded()
            }

//            textView.invalidateIntrinsicContentSize()
//            parent.commentView.invalidateIntrinsicContentSize()
            let target = textView.systemLayoutSizeFitting(textView.bounds.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
//            parent.commentView.frame.size.height = target.height + 24
//                parent.commentView.layoutIfNeeded()
            print("-=-=-= height: \(target.height)")
//            }
        }
    }
}

class FlexibleTextView: UITextView {
    var innerView: UIView?
    var maxHeight: CGFloat = 0

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

        if size.height == UIView.noIntrinsicMetric {
            // force layout
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
        }

        if maxHeight > 0.0, size.height > maxHeight {
            size.height = maxHeight

            if !isScrollEnabled {
                isScrollEnabled = true
            }
        } else if isScrollEnabled {
            isScrollEnabled = false
        }

//        if let innerView, size.width < 10000 {
//            print("-=-=-= safearea: \(innerView.safeAreaInsets.bottom)")
//            innerView.frame.size.height = size.height + 28 + innerView.safeAreaInsets.bottom
//            DispatchQueue.main.async {
//                innerView.superview?.layoutIfNeeded()
//            }
//        }

        print("-=-=-=-= size: \(size)")
        return size
    }
}

class CustomUIView: UIView {
//    var innerView: UIView?
//    var constr: NSLayoutConstraint?

//    override func addConstraint(_ constraint: NSLayoutConstraint) {
//        super.addConstraint(constraint)
//
//        for constraint in constraints {
//            if constraint.firstAttribute == .height
//            {
//                constraint.isActive = false
//            }
//        }
//    }
//
//    override func addConstraints(_ constraints: [NSLayoutConstraint]) {
//        super.addConstraints(constraints)
//
//        for constraint in constraints {
//            if constraint.firstAttribute == .height
//            {
//                constraint.isActive = false
//            }
//        }
//    }
//
//    override func updateConstraints() {
//        super.updateConstraints()
//
//        for constraint in constraints {
//            if constraint.firstAttribute == .height
//            {
//                constraint.isActive = false
//            }
//        }
//    }

    override func layoutSubviews() {
        super.layoutSubviews()

//        guard let innerView else { return }
//        let target = innerView.systemLayoutSizeFitting(innerView.bounds.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
//        let height = target.height + 16 + safeAreaInsets.bottom
//
//        if frame.size.height != height {
//            frame.size.height = height
//        }
//        invalidateIntrinsicContentSize()
    }
}
