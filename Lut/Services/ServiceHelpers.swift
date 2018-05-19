//
//  ServiceHelpers.swift
//  Banana
//


import UIKit
import Foundation

class ServiceHelpers: BaseServiceHelper {
    
    static func getEventList(userID: String,callback: @escaping (_ result: ClusterListResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetEventList(userID: userID)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! ClusterListResponse
                callback(res)
            }
        }
    }
    
    static func getEvent(eventID: String, callback: @escaping (_ result: EventDetailsResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetEvent(eventID: eventID)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! EventDetailsResponse
                callback(res)
            }
        }
    }
    
    static func register(param: Dictionary<String, Any>, callback: @escaping (_ result: RegisterResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.Register(param: param)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! RegisterResponse
                callback(res)
            }
        }
    }
    
    static func postEvent(param: Dictionary<String, Any>,token: String, callback: @escaping (_ result: PostEventResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.PostEvent(param: param,token: token)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! PostEventResponse
                callback(res)
            }
        }
    }

    static func login(param: Dictionary<String, Any>, callback: @escaping (_ result: LoginResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.Login(param: param)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! LoginResponse
                callback(res)
            }
        }
    }
    
    static func updateUser(param: Dictionary<String, Any>,token: String,userID: String, callback: @escaping (_ result: UpdateUserResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.UpdateUser(param: param, token: token,userID: userID)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! UpdateUserResponse
                callback(res)
            }
        }
    }
    
    static func updatePassword(param: Dictionary<String, Any>,token: String,userID: String, callback: @escaping (_ result: UpdatePasswordResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.UpdatePassword(param: param, token: token,userID: userID)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! UpdatePasswordResponse
                callback(res)
            }
        }
    }
    
    static func upvoteEvent(param: Dictionary<String, Any>, callback: @escaping (_ result: UpvoteEventResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.UpvoteEvent(param: param)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! UpvoteEventResponse
                callback(res)
            }
        }
    }
    
    static func downvoteEvent(eventID: String,token: String, callback: @escaping (_ result: DownvoteEventResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.DownvoteEvent(eventID: eventID, token: token)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! DownvoteEventResponse
                callback(res)
            }
        }
    }
    
    static func getLeaderboardAllTime( callback: @escaping (_ result: GetLeaderBoardResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetLeaderboardAllTime()
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! GetLeaderBoardResponse
                callback(res)
            }
        }
    }
    
    static func getLeaderboardMonth(time: String, callback: @escaping (_ result: GetLeaderBoardResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetLeaderboardMonth(time: time)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! GetLeaderBoardResponse
                callback(res)
            }
        }
    }
    
    static func getLeaderboardYear(time: String, callback: @escaping (_ result: GetLeaderBoardResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetLeaderboardYear(time: time)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! GetLeaderBoardResponse
                callback(res)
            }
        }
    }
    
    static func getUser(userID: String,token: String, callback: @escaping (_ result: GetUserResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetUser(userID: userID, token: token)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! GetUserResponse
                callback(res)
            }
        }
    }
    
}
