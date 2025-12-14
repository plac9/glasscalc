#!/usr/bin/env swift

import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

/// Generates a beautiful glassmorphic prism calculator icon
/// Matches the app's Aurora theme with glass effects

func generatePrismCalcIcon(size: CGFloat) -> CGImage? {
    let width = Int(size)
    let height = Int(size)

    guard let context = CGContext(
        data: nil,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: width * 4,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else {
        return nil
    }

    // Keep the full canvas rect explicit for clarity (even though we don't reuse it yet)
    _ = CGRect(x: 0, y: 0, width: size, height: size)

    // Background: Aurora gradient (purple to blue)
    let colors = [
        CGColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0),  // Purple
        CGColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0),  // Blue
        CGColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)   // Light blue
    ]

    if let gradient = CGGradient(
        colorsSpace: CGColorSpaceCreateDeviceRGB(),
        colors: colors as CFArray,
        locations: [0.0, 0.5, 1.0]
    ) {
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: size, y: size),
            options: []
        )
    }

    // Glass prism shape (rounded rectangle with depth)
    let padding = size * 0.15
    let glassRect = CGRect(
        x: padding,
        y: padding,
        width: size - padding * 2,
        height: size - padding * 2
    )
    let cornerRadius = size * 0.2

    // Shadow for depth
    context.saveGState()
    context.setShadow(
        offset: CGSize(width: 0, height: size * 0.03),
        blur: size * 0.08,
        color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    )

    // Glass base (semi-transparent white)
    let glassPath = CGPath(
        roundedRect: glassRect,
        cornerWidth: cornerRadius,
        cornerHeight: cornerRadius,
        transform: nil
    )
    context.addPath(glassPath)
    context.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.25))
    context.fillPath()
    context.restoreGState()

    // Glass border (gradient)
    context.addPath(glassPath)
    context.setLineWidth(size * 0.008)
    context.replacePathWithStrokedPath()
    context.clip()

    let borderColors = [
        CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6),
        CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
    ]

    if let borderGradient = CGGradient(
        colorsSpace: CGColorSpaceCreateDeviceRGB(),
        colors: borderColors as CFArray,
        locations: [0.0, 1.0]
    ) {
        context.drawLinearGradient(
            borderGradient,
            start: CGPoint(x: glassRect.minX, y: glassRect.minY),
            end: CGPoint(x: glassRect.maxX, y: glassRect.maxY),
            options: []
        )
    }

    context.resetClip()

    // Calculator symbol: Plus and minus in a grid
    let symbolSize = size * 0.12
    let symbolWeight = size * 0.025
    let centerX = size / 2
    let centerY = size / 2
    let offset = size * 0.15

    context.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95))

    // Plus sign (top-left)
    let plusX = centerX - offset
    let plusY = centerY - offset
    context.fill(CGRect(
        x: plusX - symbolSize / 2,
        y: plusY - symbolWeight / 2,
        width: symbolSize,
        height: symbolWeight
    ))
    context.fill(CGRect(
        x: plusX - symbolWeight / 2,
        y: plusY - symbolSize / 2,
        width: symbolWeight,
        height: symbolSize
    ))

    // Minus sign (top-right)
    let minusX = centerX + offset
    let minusY = centerY - offset
    context.fill(CGRect(
        x: minusX - symbolSize / 2,
        y: minusY - symbolWeight / 2,
        width: symbolSize,
        height: symbolWeight
    ))

    // Multiply sign (bottom-left)
    let multiplyX = centerX - offset
    let multiplyY = centerY + offset
    context.saveGState()
    context.translateBy(x: multiplyX, y: multiplyY)
    context.rotate(by: .pi / 4)
    context.fill(CGRect(
        x: -symbolSize / 2,
        y: -symbolWeight / 2,
        width: symbolSize,
        height: symbolWeight
    ))
    context.fill(CGRect(
        x: -symbolWeight / 2,
        y: -symbolSize / 2,
        width: symbolWeight,
        height: symbolSize
    ))
    context.restoreGState()

    // Divide sign (bottom-right)
    let divideX = centerX + offset
    let divideY = centerY + offset
    let dotRadius = symbolWeight * 1.5
    context.fill(CGRect(
        x: divideX - symbolSize / 2,
        y: divideY - symbolWeight / 2,
        width: symbolSize,
        height: symbolWeight
    ))
    context.fillEllipse(in: CGRect(
        x: divideX - dotRadius,
        y: divideY - symbolSize / 2 - dotRadius,
        width: dotRadius * 2,
        height: dotRadius * 2
    ))
    context.fillEllipse(in: CGRect(
        x: divideX - dotRadius,
        y: divideY + symbolSize / 2 - dotRadius,
        width: dotRadius * 2,
        height: dotRadius * 2
    ))

    return context.makeImage()
}

func saveImage(_ image: CGImage, to path: String) -> Bool {
    let url = URL(fileURLWithPath: path)

    guard let destination = CGImageDestinationCreateWithURL(
        url as CFURL,
        UTType.png.identifier as CFString,
        1,
        nil
    ) else {
        return false
    }

    CGImageDestinationAddImage(destination, image, nil)
    return CGImageDestinationFinalize(destination)
}

// Generate all required icon sizes
let sizes: [(String, CGFloat)] = [
    ("Icon-20@2x.png", 40),
    ("Icon-20@3x.png", 60),
    ("Icon-29@2x.png", 58),
    ("Icon-29@3x.png", 87),
    ("Icon-40@2x.png", 80),
    ("Icon-40@3x.png", 120),
    ("Icon-60@2x.png", 120),
    ("Icon-60@3x.png", 180),
    ("Icon-20@1x.png", 20),
    ("Icon-20~ipad@2x.png", 40),
    ("Icon-29~ipad@1x.png", 29),
    ("Icon-29~ipad@2x.png", 58),
    ("Icon-40~ipad@1x.png", 40),
    ("Icon-40~ipad@2x.png", 80),
    ("Icon-76@1x.png", 76),
    ("Icon-76@2x.png", 152),
    ("Icon-83.5@2x.png", 167),
    ("Icon-1024.png", 1024)
]

let basePath = "App/Assets.xcassets/AppIcon.appiconset"

print("🎨 Generating PrismCalc App Icons...")

var successCount = 0
for (filename, size) in sizes {
    if let image = generatePrismCalcIcon(size: size) {
        let path = "\(basePath)/\(filename)"
        if saveImage(image, to: path) {
            print("✅ Generated \(filename) (\(Int(size))x\(Int(size)))")
            successCount += 1
        } else {
            print("❌ Failed to save \(filename)")
        }
    } else {
        print("❌ Failed to generate \(filename)")
    }
}

print("\n✨ Generated \(successCount)/\(sizes.count) icons successfully!")
