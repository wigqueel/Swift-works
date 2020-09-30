//
//  main.swift
//  Gurin01
//
//  Created by Pro on 22.09.20.
//  Copyright © 2020 Pro. All rights reserved.
//

import Foundation

let commands:[String] = ["GO_TO"]
var result:[String] = []
var isSkiped = false

guard let path = String?(CommandLine.arguments[1])
else{
        fatalError("ERROR")
}

func readFile(_ path: String) -> Int {
    errno = 0
    if freopen(path, "r", stdin) == nil {
        perror(path)
        return 1
    }
    while let line = readLine() {
        
        //do something with lines..
        if(line.count > 3)
        {
            if(line.prefix(3) != "#if")
            {
                if(line.prefix(6) == "#endif")
                {
                    isSkiped = false
                }
                else
                {
                    if(!isSkiped){
                        print(line)
                        result.append(line)
                    }
                }
            }
            else
            {
                if(!commands.contains(String(line.suffix(line.count - 4))))
                {
                    isSkiped = true
                }
            }
        }
        else{
            if(!isSkiped){
                print(line)
                result.append(line)
            }
        }
    }
    //print(result)
    return 0
}


readFile(path)

