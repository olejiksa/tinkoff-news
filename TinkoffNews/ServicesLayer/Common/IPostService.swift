//
//  IPostService.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

protocol IPostService {
    func getNewsPost(id: String, completion: @escaping (PostItem?, String?) -> ())
}
