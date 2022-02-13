import Foundation

struct TableViewSectionItem {
    let header: HeaderFooterDisplayable?
    let items: [CellDisplayable]
    let footer: HeaderFooterDisplayable?
    
    init(
        header: HeaderFooterDisplayable? = nil,
        items: [CellDisplayable] = [],
        footer: HeaderFooterDisplayable? = nil
    ) {
        self.header = header
        self.items = items
        self.footer = footer
    }
}
