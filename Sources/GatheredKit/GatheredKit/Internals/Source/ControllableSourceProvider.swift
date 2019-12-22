import Combine

public protocol ControllableSourceProvider: Controllable & SourceProvider where Publisher == PassthroughSubject<SourceProviderEvent<ProvidedSource>, Never> {}
