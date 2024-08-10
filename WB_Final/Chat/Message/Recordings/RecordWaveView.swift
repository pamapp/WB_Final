//
//  RecordWaveView.swift
//  WB_Final
//
//  Created by Alisa Mylnikova on 14.03.2023.
//
//  Не public код из библиотеки ExyteChat. Был отредактирован в соотвествии с дизайн-макетом.

import Foundation
import SwiftUI
import ExyteChat


struct RecordWaveView: View {
    @StateObject var recordPlayer = RecordingPlayer()
    
    var recording: Recording
    var colorButton: Color
    var colorWaveform: Color
    
    var duration: Int {
        max(Int((recordPlayer.secondsLeft != 0 ? recordPlayer.secondsLeft : recording.duration) - 0.5), 0)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            buttonView
                .foregroundColor(colorButton)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    recordPlayer.togglePlay(recording)
                }
            
            durationView
                .padding(.horizontal, 4)
            
            RecordWaveformPlaying(samples: recording.waveformSamples, progress: recordPlayer.progress, color: colorWaveform)
                .padding(.leading, 10)
        }
    }
}

extension RecordWaveView {

    @ViewBuilder
    private var buttonView: some View {
        switch recordPlayer.playing {
        case true:
            Image(UI.Icons.pauseAudio)
                .renderingMode(.template)
        case false:
            Image(UI.Icons.playAudio)
                .renderingMode(.template)
        }
    }
    
    private var durationView: some View {
        Text(DateFormatter.timeString(duration))
            .font(.metadata2())
            .monospacedDigit()
            .lineLimit(1)
            .foregroundColor(colorWaveform)
            .fixedSize()
    }
}

struct RecordWaveformPlaying: View {

    var samples: [CGFloat] // 0...1
    var progress: CGFloat
    var color: Color
    var maxVisibleWidth: CGFloat = 300

    var maxLength: CGFloat {
        let calculatedLength = (RecordWaveform.spacing + RecordWaveform.width) * CGFloat(samples.count) - RecordWaveform.spacing
        return max(0, min(maxVisibleWidth, calculatedLength))
    }

    var body: some View {
        ZStack {
            let adjusted = adjustedSamples(maxVisibleWidth)

            RecordWaveform(samples: adjusted)
                .foregroundColor(color.opacity(0.4))

            RecordWaveform(samples: adjusted)
                .foregroundColor(color)
                .mask(alignment: .leading) {
                    Rectangle()
                        .frame(width: maxLength * progress, height: 2 * RecordWaveform.maxSampleHeight)
                }
        }
        .frame(height: RecordWaveform.maxSampleHeight)
        .frame(maxWidth: maxVisibleWidth)
        .fixedSize(horizontal: true, vertical: true)
    }

    func adjustedSamples(_ width: CGFloat) -> [CGFloat] {
        let maxSamples = Int(width / (RecordWaveform.width + RecordWaveform.spacing))

        var adjusted = samples
        var temp = [CGFloat]()
        while adjusted.count > maxSamples {
            var i = 0
            while i < adjusted.count {
                if i == adjusted.count - 1 {
                    temp.append(adjusted[i])
                    break
                }
                temp.append((adjusted[i] + adjusted[i + 1]) / 2)
                i += 2
            }
            adjusted = temp
            temp = []
        }
        
        return adjusted
    }
}

struct RecordWaveform: View {

    var samples: [CGFloat] // 0...1

    static let spacing: CGFloat = 2
    static let width: CGFloat = 2
    static let maxSampleHeight: CGFloat = 21

    var body: some View {
        HStack(alignment: .center, spacing: RecordWaveform.spacing) {
            ForEach(Array(samples.enumerated()), id: \.offset) { _, s in
                Capsule()
                    .frame(width: RecordWaveform.width, height: RecordWaveform.maxSampleHeight * CGFloat(s))
            }
        }
        .frame(height: RecordWaveform.maxSampleHeight)
    }
}

extension DateFormatter {
    static func timeString(_ seconds: Int) -> String {
        let hour = Int(seconds) / 3600
        let minute = Int(seconds) / 60 % 60
        let second = Int(seconds) % 60

        if hour > 0 {
            return String(format: "%02i:%02i:%02i", hour, minute, second)
        }
        return String(format: "%02i:%02i", minute, second)
    }
}
