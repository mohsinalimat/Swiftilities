//
//  FloatingPoint+Scale.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

public extension BinaryFloatingPoint {

    /// Re-maps a number from one range to another.
    ///
    /// - Parameters:
    ///   - source: The range to interpret the number as being a part of.
    ///   - destination: The range to map the number to.
    ///   - curve: An optional mapping of input percentage to output percentage. Defaults to `nil`
    ///   - clamped: Whether the result should be clamped to the `to` range. Defaults to `false`.
    ///   - reversed: whether the output mapping should be revserd, such that
    ///               as the input increases, the output decreases. Defaults to `false`.
    /// - Returns: The input number, scaled from the `from` range to the `to` range.
    public func scaled(from source: ClosedRange<Self>, to destination: ClosedRange<Self>, clamped: Bool = false, reversed: Bool = false, curve: CurveProvider? = nil) -> Self {

        let destinationStart = reversed ? destination.upperBound : destination.lowerBound
        let destinationEnd = reversed ? destination.lowerBound : destination.upperBound

        // these are broken up to speed up compile time
        let selfMinusLower = self - source.lowerBound
        let sourceUpperMinusLower = source.upperBound - source.lowerBound
        let destinationUpperMinusLower = destinationEnd - destinationStart

        var percentThroughSource = (selfMinusLower / sourceUpperMinusLower)
        if clamped {
            percentThroughSource = percentThroughSource.clamped(to: source)
        }

        let curvedPercent = curve?.map(percentThroughSource) ?? percentThroughSource
        var result = curvedPercent * destinationUpperMinusLower + destinationStart

        if clamped {
            result = result.clamped(to: destination)
        }
        
        return result
    }

}
