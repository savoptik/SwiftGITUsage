//
//  main.swift
//  SwiftGITUsage
//
//  Created by Артём Семёнов on 21.03.2020.
//  Copyright © 2020 Артём Семёнов. All rights reserved.
//

import Foundation
import SwiftGit2

func printLatestCommit(repository repo: Repository) {
    do {
        let latestCommit = try repo.HEAD().flatMap {repo.commit($0.oid)}.get()
        print("Latest Commit: \(latestCommit.message) by \(latestCommit.author.name)")
    } catch {
        print("Не удалось получить коммит")
    }
}

let url = URL(string: "https://github.com/tpairpodcast/tpair.git")!
let locurl = URL(string: URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent().path + "/tpair/")!
if FileManager.default.fileExists(atPath:  locurl.path + "/.git/config") {
    print("репозиторий уже клонирован")
    do {
        let repo = try Repository.at(locurl).get()
        do {
            repo.fetch(try repo.allRemotes().get()[0])
        } catch {
            debugPrint("Не удалось обновить репозиторий, нет ремоута")
        }
        printLatestCommit(repository: repo)
    } catch {
        print("Не удалось получить репазиторий")
    }
} else {
    do {
            print("Клонирую")
        let repo = try Repository.clone(from: url, to: locurl).get()
        printLatestCommit(repository: repo)
    } catch {
        print("Не удалось получить репазиторий")
    }
}

