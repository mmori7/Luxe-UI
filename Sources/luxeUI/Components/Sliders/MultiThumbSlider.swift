import SwiftUI

/// A slider component that supports multiple draggable thumbs for range selection.
///
/// This component allows users to create sliders with 2 or more thumbs, perfect for
/// selecting ranges, multi-value inputs, or complex filtering interfaces.
///
/// Example usage:
/// ```swift
/// @State private var values: [Double] = [0.2, 0.7]
///
/// MultiThumbSlider(
///     values: $values,
///     range: 0...100
/// )
/// ```
///
/// With customization:
/// ```swift
/// MultiThumbSlider(
///     values: $values,
///     range: 0...100,
///     step: 5,
///     showLabels: true
/// )
/// ```
public struct MultiThumbSlider: View {
    @Environment(\.luxeTheme) private var theme
    @Binding private var values: [Double]
    
    private let range: ClosedRange<Double>
    private let step: Double?
    private let trackHeight: CGFloat
    private let thumbSize: CGFloat
    private let showLabels: Bool
    private let trackColor: Color?
    private let activeTrackColor: Color?
    private let thumbColor: Color?
    
    @State private var draggedIndex: Int?
    @State private var sliderWidth: CGFloat = 0
    
    /// Creates a multi-thumb slider
    /// - Parameters:
    ///   - values: Binding to array of values (must have at least 2 elements)
    ///   - range: The range of valid values
    ///   - step: Optional step increment (nil for continuous)
    ///   - trackHeight: Height of the slider track (default: 6)
    ///   - thumbSize: Size of the draggable thumbs (default: 24)
    ///   - showLabels: Whether to show value labels above thumbs (default: false)
    ///   - trackColor: Color of the inactive track (default: uses theme)
    ///   - activeTrackColor: Color of the active track between thumbs (default: uses theme)
    ///   - thumbColor: Color of the thumb handles (default: uses theme)
    public init(
        values: Binding<[Double]>,
        range: ClosedRange<Double>,
        step: Double? = nil,
        trackHeight: CGFloat = 6,
        thumbSize: CGFloat = 24,
        showLabels: Bool = false,
        trackColor: Color? = nil,
        activeTrackColor: Color? = nil,
        thumbColor: Color? = nil
    ) {
        self._values = values
        self.range = range
        self.step = step
        self.trackHeight = trackHeight
        self.thumbSize = thumbSize
        self.showLabels = showLabels
        self.trackColor = trackColor
        self.activeTrackColor = activeTrackColor
        self.thumbColor = thumbColor
    }
    
    public var body: some View {
        VStack(spacing: theme.spacingS) {
            // Value labels
            if showLabels {
                HStack {
                    ForEach(sortedValues.indices, id: \.self) { index in
                        Text(formatValue(sortedValues[index]))
                            .font(.system(size: theme.fontSizeCaption, weight: theme.fontWeightMedium))
                            .foregroundColor(theme.textSecondary)
                        
                        if index < sortedValues.count - 1 {
                            Spacer()
                        }
                    }
                }
            }
            
            // Slider
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: trackHeight / 2)
                        .fill(trackColor ?? theme.secondaryBackgroundColor)
                        .frame(height: trackHeight)
                    
                    // Active track segments
                    ForEach(0..<max(sortedValues.count - 1, 0), id: \.self) { index in
                        activeTrackSegment(
                            from: sortedValues[index],
                            to: sortedValues[index + 1],
                            in: geometry.size.width
                        )
                    }
                    
                    // Thumbs
                    ForEach(values.indices, id: \.self) { index in
                        thumb(for: index, in: geometry.size.width)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        handleDrag(value: value, index: index, width: geometry.size.width)
                                    }
                                    .onEnded { _ in
                                        draggedIndex = nil
                                    }
                            )
                    }
                }
                .onAppear {
                    sliderWidth = geometry.size.width
                }
            }
            .frame(height: thumbSize)
        }
    }
    
    private var sortedValues: [Double] {
        values.sorted()
    }
    
    private func activeTrackSegment(from: Double, to: Double, in width: CGFloat) -> some View {
        let startX = positionForValue(from, width: width)
        let endX = positionForValue(to, width: width)
        
        return RoundedRectangle(cornerRadius: trackHeight / 2)
            .fill(activeTrackColor ?? theme.primaryColor)
            .frame(width: endX - startX, height: trackHeight)
            .offset(x: startX)
    }
    
    private func thumb(for index: Int, in width: CGFloat) -> some View {
        let position = positionForValue(values[index], width: width)
        let isBeingDragged = draggedIndex == index
        
        return Circle()
            .fill(thumbColor ?? theme.primaryColor)
            .frame(width: thumbSize, height: thumbSize)
            .shadow(
                color: Color.black.opacity(0.2),
                radius: isBeingDragged ? 8 : 4,
                y: isBeingDragged ? 4 : 2
            )
            .overlay(
                Circle()
                    .strokeBorder(Color.white, lineWidth: 2)
            )
            .scaleEffect(isBeingDragged ? 1.15 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isBeingDragged)
            .position(x: position, y: thumbSize / 2)
    }
    
    private func positionForValue(_ value: Double, width: CGFloat) -> CGFloat {
        let normalizedValue = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(normalizedValue) * width
    }
    
    private func valueForPosition(_ position: CGFloat, width: CGFloat) -> Double {
        let normalizedPosition = max(0, min(1, position / width))
        var value = range.lowerBound + Double(normalizedPosition) * (range.upperBound - range.lowerBound)
        
        // Apply step if specified
        if let step = step {
            value = round(value / step) * step
        }
        
        return max(range.lowerBound, min(range.upperBound, value))
    }
    
    private func handleDrag(value: DragGesture.Value, index: Int, width: CGFloat) {
        draggedIndex = index
        let newValue = valueForPosition(value.location.x, width: width)
        values[index] = newValue
    }
    
    private func formatValue(_ value: Double) -> String {
        if let step = step, step >= 1 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
}
