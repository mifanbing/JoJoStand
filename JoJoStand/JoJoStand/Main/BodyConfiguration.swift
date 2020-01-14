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
    
    func rotated(by angle: Double, withRespectTo location: NormalizedLocation) -> NormalizedLocation {
        let xRotated = (xNormalized - location.xNormalized) * cos(angle)
                        - (yNormalized - location.yNormalized) * sin(angle)
                        + location.xNormalized
        let yRotated = (xNormalized - location.xNormalized) * sin(angle)
                        + (yNormalized - location.yNormalized) * cos(angle)
                        + location.yNormalized
        
        return NormalizedLocation(xNormalized: xRotated, yNormalized: yRotated)
    }
}

class UnNormalizedLocation {
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    func rotated(by angle: Double) -> UnNormalizedLocation {
        let xRotated = x * cos(angle)
                        - y * sin(angle)
                    
        let yRotated = x * sin(angle)
                        + y * cos(angle)
                        
        return UnNormalizedLocation(x: xRotated, y: yRotated)
    }
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
