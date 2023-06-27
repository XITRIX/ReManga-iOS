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
    private var progressBindings = [String: BehaviorRelay<CGFloat>]()
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
        for chapter in chapters {
            progressBindings[chapter.id.value] = BehaviorRelay(value: 0)
            await bindChapterModelToProgress(chapter, api: api)
        }

        let sortedChapters = chapters.sorted { l, r in
            if l.tome.value == r.tome.value {
                return l.chapter.value < r.chapter.value
            }
            return l.tome.value < r.tome.value
        }

        for chapter in sortedChapters {
            let pages = try await downloadChapter(api: api, manga: manga, chapter: chapter, progressCallback: { [progressBindings] progress in
                progressBindings[chapter.id.value]?.accept(progress)
            })
            await finalizeDownloading(of: manga, with: chapter, api: api, pages: pages)
            progressBindings[chapter.id.value] = nil
        }
    }

    @MainActor
    func bindChapterToDownloadManager(chapter: MangaDetailsChapterViewModel, of manga: MangaDetailsViewModel, from api: ApiProtocol) {
        bindChapterModelToProgress(chapter, api: api)

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
                    progressCallback?(progress + localProgress)
                } completionHandler: { result in
                    progress += 1 / Double(pages.count)
                    progressCallback?(progress)
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
        guard let mangaModel = downloadedManga.value[mangaId]
        else { return }

        for chapter in mangaModel.chapters.value {
            for page in chapter.pages {
                try? FileManager.default.removeItem(atPath: page.path)
            }
        }

        var tmp = downloadedManga.value
        tmp[mangaId] = nil
        downloadedManga.accept(tmp)
    }

    func deleteChapter(_ chapter: MangaDetailsChapterViewModel, of manga: DownloadsMangaViewModel) {

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
    func finalizeDownloading(of manga: MangaDetailsViewModel, with chapter: MangaDetailsChapterViewModel, api: ApiProtocol, pages: [ApiMangaChapterPageModel]) async {
        let key = await keyFrom(manga.id, api: api)
        var current = downloadedManga.value[key]

        if current == nil {
            current = MangaDownloadModel(
                id: key,
                name: manga.title.value,
                image: manga.image.value,
                date: .now,
                chapters: []
            )
        }

        current?.date.accept(.now)
        let chapter = MangaChapterDownloadModel(
            id: chapter.id.value,
            tome: chapter.tome.value,
            chapter: chapter.chapter.value,
            title: chapter.title.value,
            pages: pages
        )

        if current != nil,
           !current!.chapters.value.contains(where: { $0.id == chapter.id })
        {
            var chapters = current!.chapters.value
            chapters.append(chapter)
            current?.chapters.accept(chapters)
        }

        var value = downloadedManga.value
        value[key] = current
        downloadedManga.accept(value)
    }

    @MainActor
    func bindChapterModelToProgress(_ model: MangaDetailsChapterViewModel, api: ApiProtocol) {
        guard let progressBinding = progressBindings[model.id.value]
        else { return }

        bind(in: model.disposeBag) {
            model.loadingProgress <- progressBinding
        }
    }

    func keyFrom(_ mangaId: String, api: ApiProtocol) -> String {
        "\(api.name):\(mangaId)"
    }
}
