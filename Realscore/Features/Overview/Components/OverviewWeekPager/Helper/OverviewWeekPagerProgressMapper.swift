//
//  OverviewWeekPagerProgressMapper.swift
//  Realscore
//

import Foundation

struct OverviewWeekPagerProgressMapper {
    let visiblePageCount: Int
    let firstVisiblePageIndex: Int

    var leftOutsideProgress: CGFloat {
        guard visiblePageCount > 1 else { return 0 }

        return -1 / CGFloat(visiblePageCount - 1)
    }

    var rightOutsideProgress: CGFloat {
        guard visiblePageCount > 1 else { return 1 }

        return CGFloat(visiblePageCount) / CGFloat(visiblePageCount - 1)
    }

    func tabProgress(forRealIndex index: Int) -> CGFloat {
        guard visiblePageCount > 1 else { return 0 }

        return CGFloat(index - firstVisiblePageIndex) / CGFloat(visiblePageCount - 1)
    }

    func tabProgress(forPageProgress pageProgress: CGFloat) -> CGFloat {
        guard visiblePageCount > 1 else { return 0 }

        return (pageProgress - CGFloat(firstVisiblePageIndex)) / CGFloat(visiblePageCount - 1)
    }
}
