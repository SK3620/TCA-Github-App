import Dependencies

extension GithubClient: DependencyKey {
    public static let liveValue: GithubClient = .live()

    static func live(apiClient: ApiClient = .liveValue) -> Self {
        .init(
            searchRepos: { query, page in
                try await apiClient.send(request: SearchReposRequest(query: query, page: page))
            }
        )
    }
}

/*
extension GithubClient: DependencyKey {
    public static let liveValue: GithubClient = {
        let apiClient = ApiClient.liveValue

        return .init(
            searchRepos: { query, page in
                try await apiClient.send(request: SearchReposRequest(query: query, page: page))
            }
        )
    }()
}
*/
