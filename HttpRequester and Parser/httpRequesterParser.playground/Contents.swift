	//: Playground - noun: a place where people can play

import UIKit
import Foundation
    
    enum URLs{
        case RedditGetJson(subredit: String, limit: Int)
        
        var url : String {
            switch self{
            case .RedditGetJson(let subredit, let limit):
                return "https://www.reddit.com/r/\(subredit)/top.json?limit=\(limit)"
            }
        }
    }

    struct NeededInfo: Decodable{
        var username : String
        var title : String
        var picture: String
        var score: Int
        var domain : String
        var numComments : Int
        var createdUtc : Double
        
    }
    
    struct Post: Decodable {
        var neededInfo: [NeededInfo]
        
        
        enum CodingKeys: String, CodingKey {
            case data
            enum DataKeys : String, CodingKey{
                case children
                enum ChildrenKeys: String, CodingKey{
                    case data
                    enum DataInKeys: String, CodingKey{
                        case username = "author"
                        case title
                        case score
                        case domain
                        case numComments = "num_comments"
                        case createdUtc = "created_utc"
                        case preview
                        enum PreviewKeys : String, CodingKey{
                            case images
                            enum ImagesKeys : String, CodingKey{
                                case source
                                enum SourceKeys : String, CodingKey{
                                    case picture = "url"
                                }
                            }
                        }
                    }
                }
            }
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Nested ratings
            let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.DataKeys.self, forKey: .data)
            
            var childrenContainer = try dataContainer.nestedUnkeyedContainer(forKey: .children)
            
            var decodedInfo: [NeededInfo] = []
            
            // Iterate array of objects
            while !childrenContainer.isAtEnd {
                let childrenEntry = try childrenContainer.nestedContainer(keyedBy: CodingKeys.DataKeys.ChildrenKeys.self)
                let data = try childrenEntry.nestedContainer(keyedBy: CodingKeys.DataKeys.ChildrenKeys.DataInKeys.self, forKey: .data)
                
                let username = try data.decode(String.self, forKey: .username)
                let title = try data.decode(String.self, forKey: .title)
                let score = try data.decode(Int.self, forKey: .score)
                let domain = try data.decode(String.self, forKey: .domain)
                let numComments = try data.decode(Int.self, forKey: .numComments)
                let createdUtc = try data.decode(Double.self, forKey: .createdUtc)
                var picture = ""

                let previewContainer = try data.nestedContainer(keyedBy: CodingKeys.DataKeys.ChildrenKeys.DataInKeys.PreviewKeys.self, forKey: .preview)
                var imageContainer = try previewContainer.nestedUnkeyedContainer(forKey: .images)
                while imageContainer.currentIndex == 0
                {
                    let imageEntry = try imageContainer.nestedContainer(keyedBy: CodingKeys.DataKeys.ChildrenKeys.DataInKeys.PreviewKeys.ImagesKeys.self)
                    let source = try imageEntry.nestedContainer(keyedBy: CodingKeys.DataKeys.ChildrenKeys.DataInKeys.PreviewKeys.ImagesKeys.SourceKeys.self, forKey: .source)
                    picture = try source.decode(String.self, forKey: .picture)
                    
                }
                
                
                let neededInfo = NeededInfo(username: username,
                                            title: title,
                                            picture : picture,
                                            score: score,
                                            domain: domain,
                                            numComments: numComments,
                                            createdUtc: createdUtc)

                    decodedInfo.append(neededInfo)
            }
            
            neededInfo = decodedInfo
        }
        
        
    }

    
    class HttpRequester{
 
        func createRequest(_ url: URLs, completion: @escaping (Data?, URLResponse?, Error?) -> Void) throws
        {
            let task = URLSession.shared.dataTask(with: URL(string: url.url)!) { (data, response, error) in
                completion(data, response, error)
            }
            task.resume()
        }
    }
    
    let request = HttpRequester()
    try request.createRequest(URLs.RedditGetJson(subredit: "ios", limit: 1)) { (data, response, error) in
        if let error = error {
            fatalError("clinet error")
        }
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                fatalError("server error")
        }
        print("Response: ",response)
        print()
        print()
        do {
            let decoder = JSONDecoder()
            let post = try decoder.decode(Post.self, from: data!)
            print("DATA: ", post)
        } catch {
            print("something went wrong when serializing JSON")
        }
        
    }
    sleep(100500)

