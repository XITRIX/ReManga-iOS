//
//  UserViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.11.2021.
//

import Foundation
import Bond

class UserViewModel: MvvmViewModel {
    let username = Observable<String?>(nil)
    let avatar = Observable<String?>(nil)
    let userId = Observable<String?>(nil)
    let balance = Observable<String?>(nil)
    let countViews = Observable<String?>(nil)
    let countVotes = Observable<String?>(nil)
    let countComments = Observable<String?>(nil)

    required init() {
        super.init()
        title.value = "Профиль"
        loadUser()
    }

    func loadUser() {
        state.value = .processing
        ReClient.shared.getCurrent { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                let content = model.content
                if let avatar = content.avatar {
                    self.avatar.value = ReClient.baseUrl.appending(avatar)
                }
                self.userId.value = "ID: \(content.id)"
                self.balance.value = content.balance
                self.countViews.value = content.countViews.text
                self.countVotes.value = content.countVotes.text
                self.countComments.value = content.countComments.text
                self.username.value = content.username
                self.state.value = .done
            case .failure(let error):
                self.state.value = .error(.init(error, retryCallback: self.loadUser))
            }
        }
    }
}