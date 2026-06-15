//
//  PagerCapsuleMetrics.swift
//  Realscore
//

import SwiftUI

struct PagerCapsuleMetrics {
    let totalWidth: CGFloat
    let totalHeight: CGFloat
    let itemCount: Int
    let progress: CGFloat

    var isValid: Bool {
        totalWidth.isFinite &&
        totalHeight.isFinite &&
        progress.isFinite &&
        totalWidth > 0 &&
        totalHeight > 0 &&
        itemCount > 0 &&
        capsuleWidth > 0 &&
        capsuleHeight > 0
    }

    private var itemWidth: CGFloat {
        guard itemCount > 0 else { return 0 }
        return totalWidth / CGFloat(itemCount)
    }

    var capsuleWidth: CGFloat {
        max(itemWidth - PagerLayout.CAPSULE_INSET, 0)
    }

    var capsuleHeight: CGFloat {
        max(totalHeight - PagerLayout.CAPSULE_INSET, 0)
    }

    var travelDistance: CGFloat {
        max(totalWidth - itemWidth, 0)
    }

    var centerX: CGFloat {
        itemWidth / 2 + progress * travelDistance
    }

    var centerY: CGFloat {
        totalHeight / 2
    }
}
