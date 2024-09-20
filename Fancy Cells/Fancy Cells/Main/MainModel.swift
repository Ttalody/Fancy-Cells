//
//  MainModel.swift
//  Fancy Cells
//
//  Created by Artur Akulich on 18.09.24.
//

import Foundation

final class MainModel {
    enum CreatureType {
        case alive
        case dead
        case life
    }
    
    private(set) var cells: [CreatureType] = .init()
    private var aliveStreak: Int = .zero
    private var deadStreak: Int = .zero
    
    var onCreation: ((CreatureType) -> Void)?
    
    func createCell() {
        var newCell: CreatureType
        
        switch Bool.random() {
        case true:
            newCell = .alive
            aliveStreak += 1
            deadStreak = .zero
        case false:
            newCell = .dead
            aliveStreak = .zero
            deadStreak += 1
        }
        
        cells.append(newCell)
        
        if aliveStreak == 3 {
            cells.append(.life)
            aliveStreak = 0
        } else if deadStreak == 3 {
            kill()
            deadStreak = 0
        }
        onCreation?(newCell)
    }
    
    private func kill() {
        if let index = cells.lastIndex(of: .life) {
            cells[index] = .dead
        }
    }
}
