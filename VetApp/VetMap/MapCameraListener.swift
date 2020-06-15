//
//  MapCameraListener.swift
//  VetApp
//
//  Created by Artemiy Platonov on 29.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import YandexMapKit
import YandexMapKitSearch

 extension VetMapViewController: YMKMapCameraListener {
    
    
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
        userLocationLayer.resetAnchor()
        if !isLaunched{
            mapView.mapWindow.map.move(with:
            YMKCameraPosition(target: YMKPoint(latitude: userLocationLayer.cameraPosition()!.target.latitude, longitude: userLocationLayer.cameraPosition()!.target.longitude), zoom: 14, azimuth: 0, tilt: 0))
            isLaunched = true
        }
        
        if finished {
            let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error!) -> Void in
                if let response = searchResponse {
                    self.onSearchResponse(response)
                } else {
                    self.onSearchError(error)
                }
            }
            
            searchSession = searchManager!.submit(withText: "Ветеринарная клиника", geometry: YMKVisibleRegionUtils.toPolygon(with: map.visibleRegion), searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
            
        }
    }
    
    func onSearchResponse(_ response: YMKSearchResponse) {
        let mapObjects = mapView.mapWindow.map.mapObjects
        mapObjects.clear()
        for searchResult in response.collection.children {
            if let point = searchResult.obj?.geometry.first?.point, let metadata = searchResult.obj?.metadataContainer.getItemOf(YMKSearchBusinessObjectMetadata.self) as? YMKSearchBusinessObjectMetadata {
                var phone: String?
                var name: String?
                var description: String = ""
                
                if !metadata.phones.isEmpty {
                    phone = metadata.phones[0].formattedNumber
                }
                name = metadata.shortName
                
                
                if let wh = metadata.workingHours {
                    description.append(wh.text)
                }
                let placemark = mapObjects.addPlacemark(with: point)
                placemark.userData = ObjectUserData(phone: phone ?? "", name: name ?? metadata.name, description: description)
                placemark.setIconWith(UIImage(named: "vetMapIcon")!)
                
                placemark.addTapListener(with: self)
            }
        }
    }
    
    func onSearchError(_ error: Error) {
        let searchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Неизвестная ошибка"
        if searchError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Ошибка сети"
        } else if searchError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Ошибка удалённого сервера"
        }
        
        let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension VetMapViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return false }
        let oud = placemark.userData as! ObjectUserData
        let formattedDescription = oud.description.replacingOccurrences(of: ";", with: "\n")
        let alert = UIAlertController(title: oud.name, message: formattedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Назад", style: .cancel, handler: nil))
        if !oud.phone.isEmpty {
            alert.addAction(UIAlertAction(title: "Позвонить", style: .default, handler: { (action) in
                let tel = oud.phone.replacingOccurrences(of: " ", with: "")
                if let url = URL(string: "tel://\(tel)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }))
        }

        present(alert, animated: true)
        
        return true
    }

}
