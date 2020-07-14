// Kevin Li - 3:24 PM - 7/13/20

import SwiftUI

extension Image {

    static var uTurnLeft: Image {
        if let path = Bundle.main.path(forResource: "uturn.left", ofType: "png") {
            let image = UIImage(contentsOfFile: path)!
            return Image(uiImage: image)
        }
        fatalError("Error: uturn.left not found")
    }

}
