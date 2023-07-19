//
//  MangaDownloadManager.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import Kingfisher
import MvvmFoundation
import RxRelay
import RxSwift

struct MangaProgressKeyModel: Codable, Hashable {
    var id: String
    var tome: String
    var chapter: String
    var title: String?
    var url: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

extension MangaProgressKeyModel {
    init(_ model: MangaDetailsChapterViewModel) {
        id = model.id.value
        tome = model.tome.value
        chapter = model.chapter.value
        title = model.title.value
        url = ""
    }
}

class MangaDownloadManager {
    public static var imageLocalPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("downloads")
    }

    @MainActor
    private static func imagePathFor(manga: MangaDetailsViewModel, chapter: MangaDetailsChapterViewModel, page: Int, api: ApiProtocol) -> String {
        "\(api.name)-\(manga.id ?? "")/\(chapter.id.value)/\(page).png"
    }

    private static let userDefaultsKey = "MangaDownloadManager:Downloads"

    private var disposeBag = DisposeBag()
    private var progressBindings = [MangaProgressKeyModel: BehaviorRelay<CGFloat>]()
    let downloadedManga = BehaviorRelay<[String: MangaDownloadModel]>(value: [:])

    init() {
        downloadedManga.accept(MangaDownloadManager.load())

        bind(in: disposeBag) {
            downloadedManga.bind { downloads in
                try? MangaDownloadManager.save(downloads)
            }
        }
    }

    func downloadChapters(api: ApiProtocol, manga: MangaDetailsViewModel, chapters: [MangaDetailsChapterViewModel]) async throws {
        // Get saved manga object
        let key = await keyFrom(manga.id, api: api)
        var current = downloadedManga.value[key]

        // If not exists create one
        if current == nil {
            current = MangaDownloadModel(
                id: key,
                name: manga.title.value,
                image: manga.image.value,
                date: .now,
                chapters: []
            )

            downloadedManga.mutableValue[key] = current
        }

        // Init downloading for each chapter
        for chapter in chapters {
            progressBindings[.init(chapter)] = BehaviorRelay(value: 0)
            await bindChapterModelToProgress(chapter)
            current?.downloads.mutableValue.insert(.init(chapter))
        }

        // Sort chapters in downloading order
        let sortedChapters = chapters
            .sorted(using: KeyPathComparator(\.chapter.value, comparator: .localizedStandard))
            .sorted(using: KeyPathComparator(\.tome.value, comparator: .localizedStandard))

        // Start download each chapter
        for chapter in sortedChapters {
            let pages = try await downloadChapter(api: api, manga: manga, chapter: chapter, progressCallback: { [progressBindings] progress in
                    progressBindings[.init(chapter)]?.accept(progress)
            })
            await finalizeDownloading(of: manga, with: chapter, api: api, pages: pages)
            await MainActor.run {
                progressBindings[.init(chapter)]?.accept(1)
                progressBindings[.init(chapter)] = nil
            }
        }
    }

    @MainActor
    func bindChapterToDownloadManager(chapter: MangaDetailsChapterViewModel, of manga: MangaDetailsViewModel, from api: ApiProtocol) {
        bindChapterModelToProgress(chapter)

        bind(in: chapter.disposeBag) {
            downloadedManga.bind { [unowned self] downloads in
                _ = Task {
                    let key = keyFrom(manga.id, api: api)
                    guard let manga = downloads[key],
                          manga.chapters.value.contains(where: { $0.id == chapter.id.value })
                    else { return }

                    chapter.loadingProgress.accept(1)
                }
            }
        }
    }

    func progressBinder(for key: MangaProgressKeyModel) -> BehaviorRelay<CGFloat>? {
        progressBindings[key]
    }

    func downloadChapter(api: ApiProtocol, manga: MangaDetailsViewModel, chapter: MangaDetailsChapterViewModel, saveFiles: Bool = true, progressCallback: ((Double) -> ())? = nil) async throws -> [ApiMangaChapterPageModel] {
        var pages = try await api.fetchChapter(id: chapter.id.value)
        let kingfisher = KingfisherManager.shared

        var progress: Double = 0

        for page in pages.enumerated() {
            guard let url = URL(string: page.element.path)
            else { throw ApiMangaError.wrongUrl }

            var options: KingfisherOptionsInfo = []
            options.append(.requestModifier(api.kfAuthModifier))

            let image = try await withCheckedThrowingContinuation { continuation in
                kingfisher.retrieveImage(with: url, options: options) { receivedSize, totalSize in
                    let localProgress: Double = .init(receivedSize) / Double(totalSize) / Double(pages.count)
                    DispatchQueue.main.async { [progress, localProgress] in
                        progressCallback?(progress + localProgress)
                    }
                } completionHandler: { result in
                    progress += 1 / Double(pages.count)
                    DispatchQueue.main.async { [progress] in
                        progressCallback?(progress)
                    }
                    continuation.resume(with: result)
                }
            }

            if saveFiles {
                let path = await Self.imagePathFor(manga: manga, chapter: chapter, page: page.offset, api: api)
                let realPath = MangaDownloadManager.imageLocalPath.appending(component: path)
                try FileManager.default.createDirectory(at: realPath.deletingLastPathComponent(), withIntermediateDirectories: true)
                try image.image.pngData()?.write(to: realPath)
                pages[page.offset].path = path
            }
        }

        return pages
    }

    func deleteChapters(of mangaId: String) {
        // Get manga model
        guard let mangaModel = downloadedManga.value[mangaId]
        else { return }

        // Remove every chapter in model
        for chapter in mangaModel.chapters.value {
            for page in chapter.pages {
                try? FileManager.default.removeItem(atPath: page.path)
            }
        }

        // Remove manga model
        downloadedManga.mutableValue[mangaId] = nil
    }

    func deleteChapter(_ chapterId: String, of mangaId: String) {
        // Get manga and chapter model
        guard let mangaModel = downloadedManga.value[mangaId],
              let chapter = mangaModel.chapters.value.first(where: { $0.id == chapterId })
        else { return }

        // Remove pages from disk
        for page in chapter.pages {
            try? FileManager.default.removeItem(atPath: page.path)
        }

        // Remove chapter by ID
        mangaModel.chapters.mutableValue.removeAll(where: { $0.id == chapterId })

        // If no chapters left, remove manga model
        if mangaModel.chapters.value.isEmpty {
            downloadedManga.mutableValue[mangaId] = nil
        }
    }
}

private extension MangaDownloadManager {
    static func save(_ data: [String: MangaDownloadModel]) throws {
        let data = try JSONEncoder().encode(data)
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }

    static func load() -> [String: MangaDownloadModel] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey)
        else { return [:] }

        do {
            return try JSONDecoder().decode([String: MangaDownloadModel].self, from: data)
        } catch {
            return [:]
        }
    }
}

private extension MangaDownloadManager {
    func finalizeDownloading(of manga: MangaDetailsViewModel, with remoteChapter: MangaDetailsChapterViewModel, api: ApiProtocol, pages: [ApiMangaChapterPageModel]) async {
        // Get downloaded manga model (created earlier, should not be nil)
        let key = await keyFrom(manga.id, api: api)
        guard let current = downloadedManga.value[key]
        else { return }

        // Init chapter local model
        current.date.accept(.now)
        let chapter = MangaChapterDownloadModel(
            id: remoteChapter.id.value,
            tome: remoteChapter.tome.value,
            chapter: remoteChapter.chapter.value,
            title: remoteChapter.title.value,
            pages: pages
        )

        // Remove chapter from downloads list
        current.downloads.mutableValue.remove(.init(remoteChapter))

        // Remove duplicated if presented (should not)
        if !current.chapters.value.contains(where: { $0.id == chapter.id }) {
            current.chapters.mutableValue.append(chapter)
        }

        // Apply downloaded manga model changes
        downloadedManga.mutableValue[key] = current
    }

    @MainActor
    func bindChapterModelToProgress(_ model: MangaDetailsChapterViewModel) {
        guard let progressBinding = progressBindings[.init(model)]
        else { return }

        bind(in: model.disposeBag) {
            model.loadingProgress <- progressBinding
        }
    }

    func keyFrom(_ mangaId: String, api: ApiProtocol) -> String {
        "\(api.name):\(mangaId)"
    }
}
