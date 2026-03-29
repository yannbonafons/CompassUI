//
//  RouterContext.swift
//  CompassUI
//
//  Created by Yann Bonafons on 27/03/2026.
//

public struct RouterContext: Hashable {
    public let navigationCoordinator: NavigationCoordinator
    public let sheetCoordinator: SheetCoordinator
    public let alertCoordinator: AlertCoordinator
    public let tabCoordinator: TabCoordinator
    
    public var globalContext: RouterGlobalContext {
        RouterGlobalContext(sheetCoordinator: sheetCoordinator,
                            alertCoordinator: alertCoordinator,
                            tabCoordinator: tabCoordinator)
    }

    public init(navigationCoordinator: NavigationCoordinator,
                globalContext: RouterGlobalContext) {
        self.navigationCoordinator = navigationCoordinator
        self.sheetCoordinator = globalContext.sheetCoordinator
        self.alertCoordinator = globalContext.alertCoordinator
        self.tabCoordinator = globalContext.tabCoordinator
    }

    public static var mockValue: RouterContext {
        enum MockTable: TabRoute, CaseIterable {
            case tab
        }
        return RouterContext(
            navigationCoordinator: NavigationCoordinator(),
            globalContext: RouterGlobalContext.mockValue
        )
    }
}

public struct RouterGlobalContext: Hashable {
    public let sheetCoordinator: SheetCoordinator
    public let alertCoordinator: AlertCoordinator
    public let tabCoordinator: TabCoordinator

    public init(sheetCoordinator: SheetCoordinator,
                alertCoordinator: AlertCoordinator,
                tabCoordinator: TabCoordinator) {
        self.sheetCoordinator = sheetCoordinator
        self.alertCoordinator = alertCoordinator
        self.tabCoordinator = tabCoordinator
    }

    public static var mockValue: RouterGlobalContext {
        enum MockTable: TabRoute, CaseIterable {
            case tab
        }
        return RouterGlobalContext(
            sheetCoordinator: SheetCoordinator(),
            alertCoordinator: AlertCoordinator(),
            tabCoordinator: TabCoordinator(selectedTab: MockTable.tab.erased(),
                                           possibleTabs: MockTable.allCases.map({ $0.erased() }))
        )
    }
}
