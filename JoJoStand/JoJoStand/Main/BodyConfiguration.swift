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
        case .neck:
            if let headLocation = bodyLocations[.head] {
                bodyVectors[.head2Neck] = NormalizedVector(location1: headLocation, location2: normalizedLocation)
            }
            if let buttLocation = bodyLocations[.butt] {
                bodyVectors[.neck2Butt] = NormalizedVector(location1: normalizedLocation, location2: buttLocation)
            }
            if let shoulderLeftLocation = bodyLocations[.shoulderLeft] {
                bodyVectors[.neck2ShoulderLeft] = NormalizedVector(location1: normalizedLocation, location2: shoulderLeftLocation)
            }
            if let shoulderRightLocation = bodyLocations[.shoulderRight] {
                bodyVectors[.neck2ShoulderRight] = NormalizedVector(location1: normalizedLocation, location2: shoulderRightLocation)
            }
        case .shoulderLeft:
            if let neckLocation = bodyLocations[.neck] {
                bodyVectors[.neck2ShoulderLeft] = NormalizedVector(location1: neckLocation, location2: normalizedLocation)
            }
            if let elbowLeftLocation = bodyLocations[.elbowLeft] {
                bodyVectors[.shoulderLeft2ElbowLeft] = NormalizedVector(location1: normalizedLocation, location2: elbowLeftLocation)
            }
        case .elbowLeft:
            if let shoulderLeftLocation = bodyLocations[.shoulderLeft] {
                bodyVectors[.shoulderLeft2ElbowLeft] = NormalizedVector(location1: shoulderLeftLocation, location2: normalizedLocation)
            }
            if let handLeftLocation = bodyLocations[.handLeft] {
                bodyVectors[.elbowLeft2HandLeft] = NormalizedVector(location1: normalizedLocation, location2: handLeftLocation)
            }
        case .handLeft:
            if let elbowLeftLocation = bodyLocations[.elbowLeft] {
                bodyVectors[.elbowLeft2HandLeft] = NormalizedVector(location1: elbowLeftLocation, location2: normalizedLocation)
            }
        case .shoulderRight:
            if let neckLocation = bodyLocations[.neck] {
                bodyVectors[.neck2ShoulderRight] = NormalizedVector(location1: neckLocation, location2: normalizedLocation)
            }
            if let elbowRightLocation = bodyLocations[.elbowRight] {
                bodyVectors[.shoulderRight2ElbowRight] = NormalizedVector(location1: normalizedLocation, location2: elbowRightLocation)
            }
        case .elbowRight:
            if let shoulderRightLocation = bodyLocations[.shoulderRight] {
                bodyVectors[.shoulderRight2ElbowRight] = NormalizedVector(location1: shoulderRightLocation, location2: normalizedLocation)
            }
            if let handRightLocation = bodyLocations[.handRight] {
                bodyVectors[.elbowRight2HandRight] = NormalizedVector(location1: normalizedLocation, location2: handRightLocation)
            }
        case .handRight:
            if let elbowRightLocation = bodyLocations[.elbowRight] {
                bodyVectors[.elbowRight2HandRight] = NormalizedVector(location1: elbowRightLocation, location2: normalizedLocation)
            }
        case .butt:
            if let neckLocation = bodyLocations[.neck] {
                bodyVectors[.neck2Butt] = NormalizedVector(location1: neckLocation, location2: normalizedLocation)
            }
            if let kneeLeftLocation = bodyLocations[.kneeLeft] {
                bodyVectors[.butt2KneeLeft] = NormalizedVector(location1: normalizedLocation, location2: kneeLeftLocation)
            }
            if let kneeRightLocation = bodyLocations[.kneeRight] {
                bodyVectors[.butt2KneeRight] = NormalizedVector(location1: normalizedLocation, location2: kneeRightLocation)
            }
        case .kneeLeft:
            if let buttLocation = bodyLocations[.butt] {
                bodyVectors[.butt2KneeLeft] = NormalizedVector(location1: buttLocation, location2: normalizedLocation)
            }
            if let footLeftLocation = bodyLocations[.footLeft] {
                bodyVectors[.kneeLeft2FootLeft] = NormalizedVector(location1: normalizedLocation, location2: footLeftLocation)
            }
        case .footLeft:
            if let kneeLeftLocation = bodyLocations[.kneeLeft] {
                bodyVectors[.kneeLeft2FootLeft] = NormalizedVector(location1: kneeLeftLocation, location2: normalizedLocation)
            }
        case .kneeRight:
            if let buttLocation = bodyLocations[.butt] {
                bodyVectors[.butt2KneeRight] = NormalizedVector(location1: buttLocation, location2: normalizedLocation)
            }
            if let footRightLocation = bodyLocations[.footRight] {
                bodyVectors[.kneeRight2FootRight] = NormalizedVector(location1: normalizedLocation, location2: footRightLocation)
            }
        case .footRight:
            if let kneeRightLocation = bodyLocations[.kneeRight] {
                bodyVectors[.kneeRight2FootRight] = NormalizedVector(location1: kneeRightLocation, location2: normalizedLocation)
            }
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

class Location {
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    func rotated(by angle: Double) -> Location {
        let xRotated = x * cos(angle)
                        - y * sin(angle)
                    
        let yRotated = x * sin(angle)
                        + y * cos(angle)
                        
        return Location(x: xRotated, y: yRotated)
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
    case butt
    case kneeLeft
    case kneeRight
    case footLeft
    case footRight
}

struct NormalizedVector {
    let xComponent: Double
    let yComponent: Double
    var norm: Double {
        return sqrt(xComponent*xComponent + yComponent*yComponent)
    }
    
    init(location1: NormalizedLocation, location2: NormalizedLocation) {
        xComponent = location2.xNormalized - location1.xNormalized
        yComponent = location2.yNormalized - location1.yNormalized
    }
}

enum BodyVector: String, CaseIterable {
    case head2Neck
    case neck2ShoulderLeft
    case neck2ShoulderRight
    case shoulderLeft2ElbowLeft
    case shoulderRight2ElbowRight
    case elbowLeft2HandLeft
    case elbowRight2HandRight
    case neck2Butt
    case butt2KneeLeft
    case butt2KneeRight
    case kneeLeft2FootLeft
    case kneeRight2FootRight
}
