//
//  UILabel+actualNumberOfLines.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/19/24.
//

import UIKit

extension UILabel {
    func actualNumberOfLines() -> Int {
        // 레이아웃이 완료된 이후에만 프레임을 사용
        layoutIfNeeded()

        guard let text = self.text, let font = self.font else {
            return 0
        }

        // UILabel의 textContainer로 계산
        let textStorage = NSTextStorage(string: text)
        let textContainer = NSTextContainer(size: CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textStorage.addAttribute(.font, value: font, range: NSRange(location: 0, length: textStorage.length))
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode

        layoutManager.glyphRange(for: textContainer)

        let numberOfLines = layoutManager.numberOfLines(in: textContainer)
        return numberOfLines
    }
}

extension NSLayoutManager {
    func numberOfLines(in textContainer: NSTextContainer) -> Int {
        var numberOfLines = 0
        var index = 0
        var lineRange: NSRange = NSRange()

        while index < numberOfGlyphs {
            self.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        
        return numberOfLines
    }
}
