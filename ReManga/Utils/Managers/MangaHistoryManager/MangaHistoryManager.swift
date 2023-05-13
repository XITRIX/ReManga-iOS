//
//  MangaHistoryManager.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.05.2023.
//

import MvvmFoundation
import RxSwift

struct MangaHistoryItem: Codable, Hashable {
    var id: String
    var title: String?
    var image: String?
    var details: String?
    var chapterId: String?
    var apiKey: ContainerKey.Backend
    var date: Date = .now

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(apiKey)
    }
}

class MangaHistoryManager {
    private static let userDefaultsKey = "MangaHistoryManager:History"
    private var disposeBag = DisposeBag()

    @Binding private(set) var history: [MangaHistoryItem] = []

    init() {
        history = Self.load()

        bind(in: disposeBag) {
            Self.save <- $history
        }
    }

    func addItem(_ item: MangaHistoryItem) {
        var res = history.filter { $0.hashValue != item.hashValue }
        res.append(item)
        history = res
    }

    func removeItem(_ item: MangaHistoryItem) {
        history = history.filter { $0.hashValue != item.hashValue }
    }
}

private extension MangaHistoryManager {
    static func save(_ data: [MangaHistoryItem]) {
        do {
            let data = try JSONEncoder().encode(data)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {}
    }

    static func load() -> [MangaHistoryItem] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey)
        else { return [] }

        do {
            return try JSONDecoder().decode([MangaHistoryItem].self, from: data)
        } catch {
            return []
        }
    }
}
