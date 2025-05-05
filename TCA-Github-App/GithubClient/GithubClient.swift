import Dependencies
import DependenciesMacros

// インターフェースを定義
@DependencyClient
public struct GithubClient: Sendable {
    public var searchRepos: @Sendable (_ query: String, _ page: Int) async throws -> SearchReposResponse
    
    public init(searchRepos: @Sendable @escaping (_: String, _: Int) -> SearchReposResponse) {
        self.searchRepos = searchRepos
    }
}

// 今回はテストは無視
extension GithubClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

// githubClientという依存関係を使えるようにする
public extension DependencyValues {
    var githubClient: GithubClient {
        get { self[GithubClient.self] } // DependencyValuesからSimpleClientを取得
        set { self[GithubClient.self] = newValue } // DependencyValuesにSimpleClientを設定
    }
}

