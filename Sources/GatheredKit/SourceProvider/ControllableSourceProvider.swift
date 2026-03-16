import Combine

public protocol ControllableSourceProvider: SourceProvider, UpdatesProviding {
    func startUpdating()
    func stopUpdating()
}
