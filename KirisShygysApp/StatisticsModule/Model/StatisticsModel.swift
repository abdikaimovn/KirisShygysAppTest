//
//  StatisticsModel.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 02.01.2024.
//

import Foundation
import DGCharts
import UIKit

enum FlowImageEnum: String {
    case income = "square.and.arrow.down"
    case expense = "square.and.arrow.up"
    case total = "dollarsign.arrow.circlepath"
}

struct FlowModel {
    let value: Int
    let flowImage: FlowImageEnum
}

enum ChartPeriod {
    case week, month, year
}

struct GroupedTransaction {
    let value: Int
    let date: String
}

struct ChartModel {
    let xAxisTitles: [String]
    let chartData: BarChartDataSet
}
