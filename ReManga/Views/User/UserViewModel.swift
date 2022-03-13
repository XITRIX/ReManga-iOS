//
//  UserViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.11.2021.
//

import Bond
import Foundation
import MVVMFoundation

class UserViewModel: MvvmViewModel {
    let username = Observable<String?>(nil)
    let avatar = Observable<URL?>(nil)
    let userId = Observable<String?>(nil)
    let balance = Observable<String?>(nil)
    let tickets = Observable<String?>(nil)
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
                if let avatar = content.avatar,
                   let avatarUrl = URL(string: avatar)
                {
                    self.avatar.value = avatarUrl
                }
                self.userId.value = "ID: \(content.id)"
                self.balance.value = content.balance
                self.tickets.value = content.ticketBalance.text
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
