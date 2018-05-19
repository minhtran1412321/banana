//
//  BananaServiceProtocol.swift
//  Banana
//

import Bolts

protocol BananaServiceProtocol {
    func GetEventList(userID: String)                            ->      BFTask<AnyObject>
    func GetEvent(eventID: String)                 ->      BFTask<AnyObject>
    func Login(param: Dictionary<String, Any>)     ->      BFTask<AnyObject>
    func PostEvent(param: Dictionary<String, Any>,token: String) ->      BFTask<AnyObject>
    func Register(param: Dictionary<String, Any>)  ->      BFTask<AnyObject>
    func UpdateUser(param: Dictionary<String, Any>,token: String,userID: String) ->      BFTask<AnyObject>
    func UpdatePassword(param: Dictionary<String, Any>,token: String,userID: String) ->      BFTask<AnyObject>
    func UpvoteEvent(param: Dictionary<String, Any>)                ->      BFTask<AnyObject>
    func DownvoteEvent(eventID: String, token: String)              ->      BFTask<AnyObject>
    func GetLeaderboardAllTime()                ->      BFTask<AnyObject>
    func GetLeaderboardMonth(time: String)                ->      BFTask<AnyObject>
    func GetLeaderboardYear(time: String)                ->      BFTask<AnyObject>
    func GetUser(userID: String,token: String)       ->      BFTask<AnyObject>
}
