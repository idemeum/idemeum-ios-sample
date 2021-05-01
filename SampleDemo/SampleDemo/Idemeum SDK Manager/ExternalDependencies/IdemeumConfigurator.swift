class IdemeumConfigurator {
  
  static let shared = IdemeumConfigurator()
  
  // MARK: Properties
  
  private let idemeumGateway: IdemeumGateway
  
  // MARK: Initialisation
  
  private init() {
    idemeumGateway = IdemeumGatewayImpl()
  }
  
  func idemeumGateWay() -> IdemeumGateway{
    return idemeumGateway
  }
}

