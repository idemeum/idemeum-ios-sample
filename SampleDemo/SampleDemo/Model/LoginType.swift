enum LoginType {
    case SingleSignIn
    case BioMetric
    case ViaApp
}

class LoginMedium {
    var key = ""
    init(type: LoginType) {
        switch type {
        case .SingleSignIn:
            key = Constants.IdemeumKeys.SingleSign
        case .BioMetric:
            key = Constants.IdemeumKeys.BioMetricKey
        case .ViaApp:
            key = Constants.IdemeumKeys.DVMIKey
            
        }
    }
}
