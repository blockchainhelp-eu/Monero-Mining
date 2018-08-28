//
//  Theme.swift
//  Notepad
//
//  Created by Rudd Fawcett on 10/14/16.
//  Copyright © 2016 Rudd Fawcett. All rights reserved.
//  Modified for Simplenote usage


import AppKit

public struct Theme {
    /// The body style for the Notepad editor.
    public fileprivate(set) var body: Style = Style()
    /// The background color of the Notepad.
    public fileprivate(set) var backgroundColor: NSColor = NSColor.white
    /// The tint color (AKA cursor color) of the Notepad.
    public fileprivate(set) var tintColor: NSColor = NSColor.blue

    /// All of the other styles for the Notepad editor.
    var styles: [Style] = []
    

    /// Build a theme from a JSON theme file.
    ///
    /// - parameter name: The name of the JSON theme file.
    ///
    /// - returns: The Theme.
    public init(markdownEnabled: Bool) {
        applyStyles(markdownEnabled: markdownEnabled)
    }

    /// Style the
    public mutating func applyStyles(markdownEnabled: Bool) {
        let theme = VSThemeManager.shared().theme();

        backgroundColor = (theme?.color(forKey: "backgroundColor"))!
        tintColor = (theme?.color(forKey: "tintColor"))!
        
        var fontSize = CGFloat(UserDefaults.standard.integer(forKey: "kFontSizePreferencesKey"))
        if (fontSize == 0) {
            fontSize = 15.0; // Just in case!
        }
        
        /* All Text */
        let attributes = [
            NSAttributedStringKey.foregroundColor: theme?.color(forKey: "textColor"),
            NSAttributedStringKey.font: NSFont.systemFont(ofSize: fontSize)
        ]
        body = Style(element: .body, attributes: attributes as [NSAttributedStringKey : AnyObject])
        
        /* Header Text */
        let firstLineAttributes = [
            NSAttributedStringKey.font: NSFont.systemFont(ofSize: fontSize * 1.25)
        ]
        styles.append(Style(element: Element.unknown.from(string: "firstLine"), attributes: firstLineAttributes))
        
        // Stop styling here if the note doesn't have markdown enabled
        if (!markdownEnabled) {
            return
        }
        
        let headingAttributes = [
            NSAttributedStringKey.font: NSFont.boldSystemFont(ofSize: fontSize)
        ]
        styles.append(Style(element: Element.unknown.from(string: "h1"), attributes: headingAttributes))
        styles.append(Style(element: Element.unknown.from(string: "h2"), attributes: headingAttributes))
        styles.append(Style(element: Element.unknown.from(string: "firstLine"), attributes: firstLineAttributes))
        
        /* Bold Text*/
        let boldAttributes = [
            NSAttributedStringKey.font: NSFont.boldSystemFont(ofSize: fontSize)
        ]
        styles.append(Style(element: Element.unknown.from(string: "bold"), attributes: boldAttributes))
        
        let codeAttributes = [
            NSAttributedStringKey.foregroundColor: theme?.color(forKey: "secondaryTextColor"),
            NSAttributedStringKey.font: NSFont(name: "Courier", size: fontSize)
        ]
        styles.append(Style(element: Element.unknown.from(string: "inlineCode"), attributes: codeAttributes as [NSAttributedStringKey : AnyObject]))
        
         /* Emphasized Text*/
        let fontManager = NSFontManager.shared;
        let defaultFont = NSFont.systemFont(ofSize: fontSize)
        let italicFont = fontManager.convert(defaultFont, toHaveTrait: NSFontTraitMask.italicFontMask)
        
        let italicAttributes = [
            NSAttributedStringKey.font: italicFont
        ]
        styles.append(Style(element: Element.unknown.from(string: "italic"), attributes: italicAttributes as [NSAttributedStringKey : AnyObject]))
        
         /* Quoted Text */
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 20.0;
        paragraphStyle.firstLineHeadIndent = 20.0;
        paragraphStyle.tailIndent = -20.0;
        
        let quoteAttributes = [
            NSAttributedStringKey.font: italicFont,
            NSAttributedStringKey.foregroundColor: theme?.color(forKey: "secondaryTextColor") as Any,
            NSAttributedStringKey.paragraphStyle: paragraphStyle
            ] as [NSAttributedStringKey : Any]
        styles.append(Style(element: Element.unknown.from(string: "quote"), attributes: quoteAttributes as [NSAttributedStringKey : AnyObject]))
        
         /* Links and Images */
        let urlAttributes = [
            NSAttributedStringKey.foregroundColor: theme?.color(forKey: "tintColor")
        ]
        styles.append(Style(element: Element.unknown.from(string: "url"), attributes: urlAttributes as [NSAttributedStringKey : AnyObject]))
        styles.append(Style(element: Element.unknown.from(string: "image"), attributes: urlAttributes as [NSAttributedStringKey : AnyObject]))
    }
}
