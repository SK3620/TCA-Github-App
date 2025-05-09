//
//  ReducerAction.swift
//  TCA-Github-App
//
//  Created by 鈴木 健太 on 2025/05/08.
//

protocol ReducerAction {
    associatedtype ViewAction
    associatedtype InternalAction
    associatedtype DelegateAction

//    static func view(_ action: ViewAction) -> Self
//    static func `internal`(_ action: InternalAction) -> Self
//    static func delegate(_ action: DelegateAction) -> Self
}
