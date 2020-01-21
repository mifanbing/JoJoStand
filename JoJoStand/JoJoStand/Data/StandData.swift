class StandData {
    static var JosukeStand: BodyConfiguration {
        var bodyConfiguration = BodyConfiguration()
        var bodyLocations = [BodyJoint: NormalizedLocation]()
        var bodyVectors = [BodyVector: NormalizedVector]()
        
        bodyLocations[.head] = NormalizedLocation(xNormalized: 0.0355, yNormalized: -0.401)
        bodyLocations[.neck] = NormalizedLocation(xNormalized: -0.0133, yNormalized: -0.277)
        bodyLocations[.shoulderLeft] = NormalizedLocation(xNormalized: -0.12, yNormalized: -0.275)
        bodyLocations[.shoulderRight] = NormalizedLocation(xNormalized: 0.0622, yNormalized: -0.219)
        bodyLocations[.elbowLeft] = NormalizedLocation(xNormalized: -0.195, yNormalized:-0.384)
        bodyLocations[.handLeft] = NormalizedLocation(xNormalized: -0.0411, yNormalized: -0.356)
        bodyLocations[.elbowRight] = NormalizedLocation(xNormalized: 0.199, yNormalized: -0.305)
        bodyLocations[.handRight] = NormalizedLocation(xNormalized: 0.0477, yNormalized: -0.28)
        bodyLocations[.butt] = NormalizedLocation(xNormalized: -0.00111, yNormalized: 0.0211)
        bodyLocations[.kneeLeft] = NormalizedLocation(xNormalized: -0.136, yNormalized: 0.0977)
        bodyLocations[.kneeRight] = NormalizedLocation(xNormalized: 0.0222, yNormalized: 0.16)
        bodyLocations[.footLeft] = NormalizedLocation(xNormalized: -0.0577, yNormalized: 0.433)
        bodyLocations[.footRight] = NormalizedLocation(xNormalized: 0.0211, yNormalized: 0.367)
        
        bodyVectors[.head2Neck] = NormalizedVector(location1: bodyLocations[.head]!, location2: bodyLocations[.neck]!)
        bodyVectors[.head2Neck]!.width = 0.0987
        
        bodyVectors[.neck2ShoulderLeft] = NormalizedVector(location1: bodyLocations[.neck]!, location2: bodyLocations[.shoulderLeft]!)
        bodyVectors[.neck2ShoulderLeft]!.width = 0.0517
            
        bodyVectors[.neck2ShoulderRight] = NormalizedVector(location1: bodyLocations[.neck]!, location2: bodyLocations[.shoulderRight]!)
        bodyVectors[.neck2ShoulderRight]!.width = 0.0765
        
        bodyVectors[.neck2Butt] = NormalizedVector(location1: bodyLocations[.neck]!, location2: bodyLocations[.butt]!)
        bodyVectors[.neck2Butt]!.width = 0.213
        
        bodyVectors[.shoulderLeft2ElbowLeft] = NormalizedVector(location1: bodyLocations[.shoulderLeft]!, location2: bodyLocations[.elbowLeft]!)
        bodyVectors[.shoulderLeft2ElbowLeft]!.width = 0.0697
            
        bodyVectors[.elbowLeft2HandLeft] = NormalizedVector(location1: bodyLocations[.elbowLeft]!, location2: bodyLocations[.handLeft]!)
        bodyVectors[.elbowLeft2HandLeft]!.width = 0.0393
        
        bodyVectors[.shoulderRight2ElbowRight] = NormalizedVector(location1: bodyLocations[.shoulderRight]!, location2: bodyLocations[.elbowRight]!)
        bodyVectors[.shoulderRight2ElbowRight]!.width = 0.0393
            
        bodyVectors[.elbowRight2HandRight] = NormalizedVector(location1: bodyLocations[.elbowRight]!, location2: bodyLocations[.handRight]!)
        bodyVectors[.elbowRight2HandRight]!.width = 0.0542
        
        bodyVectors[.butt2KneeLeft] = NormalizedVector(location1: bodyLocations[.butt]!, location2: bodyLocations[.kneeLeft]!)
        bodyVectors[.butt2KneeLeft]!.width = 0.133
        
        bodyVectors[.butt2KneeRight] = NormalizedVector(location1: bodyLocations[.butt]!, location2: bodyLocations[.kneeRight]!)
        bodyVectors[.butt2KneeRight]!.width = 0.148
            
        bodyVectors[.kneeLeft2FootLeft] = NormalizedVector(location1: bodyLocations[.kneeLeft]!, location2: bodyLocations[.footLeft]!)
        bodyVectors[.kneeLeft2FootLeft]!.width = 0.126
        
        bodyVectors[.kneeRight2FootRight] = NormalizedVector(location1: bodyLocations[.kneeRight]!, location2: bodyLocations[.footRight]!)
        bodyVectors[.kneeRight2FootRight]!.width = 0.126
        
        bodyConfiguration.bodyLocations = bodyLocations
        bodyConfiguration.bodyVectors = bodyVectors
        
        return bodyConfiguration
    }
}
