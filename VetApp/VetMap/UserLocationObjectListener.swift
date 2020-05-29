//
//  UserLocationObjectListener.swift
//  VetApp
//
//  Created by Artemiy Platonov on 29.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import YandexMapKit


extension VetMapViewController: YMKUserLocationObjectListener {
    
    func onObjectAdded(with view: YMKUserLocationView) {
        
        let pinPlacemark = view.pin.useCompositeIcon()

        view.arrow.setIconWith(UIImage(named: "userLocation")!)
        
        pinPlacemark.setIconWithName(
            "pin",
            image: UIImage(named:"userLocation")!,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil))
        view.accuracyCircle.fillColor = .clear
        
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {
    }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
        
    }
}
