import Foundation

class BodyConfiguration {
    var bodyLocations: [BodyJoint: NormalizedLocation]
    var bodyVectors: [BodyVector: NormalizedVector]
    
    init() {
        var bodyLocationsTemp = [BodyJoint: NormalizedLocation]()
        BodyJoint.allCases.forEach {
            bodyLocationsTemp[$0] = nil //NormalizedLocation(xNormalized: 0, yNormalized: 0)
        }
        bodyLocations = bodyLocationsTemp
        
        var bodyVectorsTemp = [BodyVector: NormalizedVector]()
        BodyVector.allCases.forEach {
            bodyVectorsTemp[$0] = nil
        }
        bodyVectors = bodyVectorsTemp
    }
    
    func update(bodyJoint: BodyJoint, normalizedLocation: NormalizedLocation) {
        bodyLocations[bodyJoint] = normalizedLocation
        switch bodyJoint {
        case .head:
            if let neckLocation = bodyLocations[.neck] {
                bodyVectors[.head2Neck] = NormalizedVector(location1: normalizedLocation, location2: neckLocation)
            }
        default:
            ()
        }
    }
}

struct NormalizedLocation {
    let xNormalized: Double
    let yNormalized: Double
}

enum BodyJoint: String, CaseIterable {
    case head
    case neck
    case shoulderLeft
    case shoulderRight
    case elbowLeft
    case elbowRight
    case handLeft
    case handRight
}

struct NormalizedVector {
    let xComponent: Double
    let yComponent: Double
    
    init(location1: NormalizedLocation, location2: NormalizedLocation) {
        xComponent = location2.xNormalized - location1.xNormalized
        yComponent = location2.yNormalized - location1.yNormalized
    }
}

enum BodyVector: String, CaseIterable {
    case head2Neck
    case neck2shoulderLeft
    case neck2shoulderRight
    case shoulderLeft2ElbowLeft
    case shoulderRight2ElbowRight
    case elbowLeft2HandLeft
    case elbowRight2HandRight
}
