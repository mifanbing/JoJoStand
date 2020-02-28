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
    
    static func connectedBodyVector(bodyJoint: BodyJoint) -> [BodyVector] {
        switch bodyJoint {
        case .head:
            return [.head2Neck]
        case .neck:
            return [.head2Neck, .neck2Butt, .neck2ShoulderLeft, .neck2ShoulderRight]
        case .shoulderLeft:
            return [.neck2ShoulderLeft, .shoulderLeft2ElbowLeft]
        case .shoulderRight:
            return [.neck2ShoulderRight, .shoulderRight2ElbowRight]
        case .elbowLeft:
            return [.shoulderLeft2ElbowLeft, .elbowLeft2HandLeft]
        case .elbowRight:
            return [.elbowRight2HandRight, .shoulderRight2ElbowRight]
        case .handLeft:
            return [.elbowLeft2HandLeft]
        case .handRight:
            return [.elbowRight2HandRight]
        case .butt:
            return [.butt2KneeLeft, .butt2KneeRight, .neck2Butt]
        case .kneeLeft:
            return [.kneeLeft2FootLeft, .butt2KneeLeft]
        case .kneeRight:
            return [.kneeRight2FootRight, .butt2KneeRight]
        case .footLeft:
            return [.kneeLeft2FootLeft]
        case .footRight:
            return [.kneeRight2FootRight]
        }
    }
}

struct NormalizedVector {
    let xComponent: Double
    let yComponent: Double
    let start: NormalizedLocation
    let end: NormalizedLocation
    var width: Double
    
    var norm: Double {
        return sqrt(xComponent*xComponent + yComponent*yComponent)
    }
    
    init(location1: NormalizedLocation, location2: NormalizedLocation) {
        xComponent = location2.xNormalized - location1.xNormalized
        yComponent = location2.yNormalized - location1.yNormalized
        start = location1
        end = location2
        width = 0
    }
}

enum BodyVector: Int, CaseIterable {
    case head2Neck = 100
    case neck2ShoulderLeft = 101
    case neck2ShoulderRight = 102
    case shoulderLeft2ElbowLeft = 103
    case shoulderRight2ElbowRight = 104
    case elbowLeft2HandLeft = 105
    case elbowRight2HandRight = 106
    case neck2Butt = 107
    case butt2KneeLeft = 108
    case butt2KneeRight = 109
    case kneeLeft2FootLeft = 110
    case kneeRight2FootRight = 111
}
