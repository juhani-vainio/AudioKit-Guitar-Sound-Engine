//
//  Colors.swift
//  NonSkeuomorphicMusicApp
//
//  Created by Juhani Vainio on 28/04/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit



struct interface {
    // tables & collections
    // order from bottom
    static var main = UIColor()             // dark 1
    static var mainAlt = UIColor()          // dark 2
    static var tableAlt = UIColor()         // dark 2
    static var tab = UIColor()              // dark 2
    static var top = UIColor()              // dark 3
    static var bottom = UIColor()           // dark 3
    static var tableBackground = UIColor()  // dark 3
    
    static var button = UIColor()           // bright 1
    static var text = UIColor()             // bright 1
    static var buttonAlt = UIColor()        // bright 2
    static var textAlt = UIColor()          // bright 2
    static var textIdle = UIColor()         // brigth 3
    
    static var theme1 = UIColor()       // TABS
    static var theme2 = UIColor()       // special switch & in tune & wave
    static var theme3 = UIColor()
    
    static var sliderMin = UIColor()        // theme 4
    static var sliderMax = UIColor()        // theme 5
    static var sliderThumb = UIColor()      // theme 1
    
    static var transparent = UIColor()
  
}

class Colors {
    
    static let palette = Colors()
    
    func colorForEffect(name: String) -> UIColor {
        var color = UIColor()
       
        switch name {
        case "bitCrusher" : color = UIColor.magenta
        case "tanhDistortion" : color = UIColor.brown
        case "clipper" : color = UIColor.blue
        case "dynaRageCompressor" : color = UIColor.white
        case "autoWah" : color = UIColor.yellow
        case "delay" : color = UIColor.yellow
        case "decimator" : color = UIColor.cyan
        case "ringModulator" : color = UIColor.purple
    
        case "flanger": color = UIColor.brown
        case "phaser": color = UIColor.cyan
        case "chorus": color = UIColor.magenta
        case "compressor": color = UIColor.white
        case "dynamicsProcessor": color = UIColor.white
        case "dynamicRangeCompressor": color = UIColor.white
        case "reverb": color = UIColor.green
        case "reverb2": color = UIColor.green
        case "chowningReverb": color = UIColor.red
        case "costelloReverb": color = UIColor.red
        case "flatFrequencyResponseReverb": color = UIColor.red
        case "tremolo": color = UIColor.yellow
        default : color = UIColor.white
        }
        return color
    }
    
    func next(value: Int) -> UIColor {
        var color = UIColor()
        var newValue = Int()
        if value > 8 {
            newValue = value - 8
            if newValue > 8 {
                newValue = value - 16
                if newValue > 8 {
                    newValue = value - 24
                }
            }
            
        }
        else {
            newValue = value
        }
        switch newValue {
        case 1 : color = UIColor.magenta
        case 2 : color = UIColor.brown
        case 3 : color = UIColor.blue
        case 4 : color = UIColor.white
        case 5 : color = UIColor.black
        case 6 : color = UIColor.yellow
        case 7 : color = UIColor.cyan
        case 8 : color = UIColor.purple
        default : color = UIColor.black
            
        }
        return color
    }
    
    
    
    
    
    let options = ["spotify", "bluePinkGreen", "finder", "joku", "defaultti"]

    func setInterfaceColorScheme(name: String) {
        print("Interface color scheme is:  \(name)")
        switch name {
            
        case "GravityX":
            interface.main = UIColor(rgb: 0x2B92AD)
            
            interface.mainAlt = UIColor(rgb: 0x2B92AD)
            interface.tableAlt = UIColor(rgb: 0xE7B335)
            interface.tab = UIColor(rgb: 0x121212)
            
            interface.top = UIColor(rgb: 0xE7B335) //yellow
            interface.bottom = UIColor(rgb: 0xE7B335)
            interface.tableBackground = UIColor.black
            
            interface.button = UIColor(rgb: 0xD15F2E) // orange
            interface.text = UIColor(rgb: 0xD15F2E)
            
            interface.buttonAlt = UIColor.clear
            interface.textAlt = UIColor(rgb: 0x8691AB)
            interface.textIdle = UIColor(rgb: 0x686F81)
            
            interface.theme1 = UIColor(rgb: 0x2B92AD) // blue
            interface.theme2 = UIColor.yellow
            interface.theme3 = UIColor(rgb: 0x2B92AD)
            
            interface.sliderMin = UIColor(rgb: 0x2B92AD)
            interface.sliderMax = UIColor(rgb: 0xE7B335)
            interface.sliderThumb = UIColor(rgb: 0xD15F2E)
            interface.transparent = UIColor.clear
            
        case "Polka":
            // white & pink
            interface.main = UIColor.black
            
            interface.mainAlt = UIColor.black
            interface.tableAlt = UIColor(rgb: 0x121212)
            interface.tab = UIColor(rgb: 0x121212)
            
            interface.top = UIColor(rgb: 0x121212)
            interface.bottom = UIColor(rgb: 0x121212)
            interface.tableBackground = UIColor(rgb: 0x121212)
            
            interface.button = UIColor(rgb: 0xDBDBE6)
            interface.text = UIColor(rgb: 0xDBDBE6)
            
            interface.buttonAlt = UIColor.clear
            interface.textAlt = UIColor(rgb: 0x8691AB)
            interface.textIdle = UIColor(rgb: 0x686F81)
            
            interface.theme1 = UIColor(rgb: 0x4286D2)
            interface.theme2 = UIColor.yellow
            interface.theme3 = UIColor(rgb: 0x4286D2)
            
            interface.sliderMin = UIColor.white
            interface.sliderMax = UIColor.white
            interface.sliderThumb = UIColor(rgb: 0xC95A90) // pink
            interface.transparent = UIColor.clear
            
        case "PinkBlue":
            //pink & blue
            interface.main = UIColor.black
            
            interface.mainAlt = UIColor.black
            interface.tableAlt = UIColor(rgb: 0x121212)
            interface.tab = UIColor(rgb: 0x121212)
            
            interface.top = UIColor(rgb: 0x121212)
            interface.bottom = UIColor(rgb: 0x121212)
            interface.tableBackground = UIColor(rgb: 0x121212)
            
            interface.button = UIColor(rgb: 0xC95A90) // pink
            interface.text = UIColor(rgb: 0xC95A90) // pink
            
            interface.buttonAlt = UIColor.clear
            interface.textAlt = UIColor(rgb: 0x8691AB)
            interface.textIdle = UIColor(rgb: 0x686F81)
            
            interface.theme1 = UIColor(rgb: 0x2B92AD) // blue
            interface.theme2 = UIColor(rgb: 0xC95A90) // pink
            interface.theme3 = UIColor(rgb: 0xC95A90) // pink
            
            interface.sliderMin = UIColor(rgb: 0xC95A90) // pink
            interface.sliderMax = UIColor.black
            interface.sliderThumb = UIColor(rgb: 0x2B92AD) // blue
            interface.transparent = UIColor.clear
            
        case "YellowBlue":
            // yellow and blue
            interface.main = UIColor.black
            
            interface.mainAlt = UIColor.black
            interface.tableAlt = UIColor(rgb: 0x121212)
            interface.tab = UIColor(rgb: 0x121212)
            
            interface.top = UIColor(rgb: 0x121212)
            interface.bottom = UIColor(rgb: 0x121212)
            interface.tableBackground = UIColor(rgb: 0x121212)
            
            interface.button = UIColor(rgb: 0xDBDBE6)
            interface.text = UIColor(rgb: 0xDBDBE6)
            
            interface.buttonAlt = UIColor.clear
            interface.textAlt = UIColor(rgb: 0x8691AB)
            interface.textIdle = UIColor(rgb: 0x686F81)
            
            interface.theme1 = UIColor(rgb: 0x4286D2)
            interface.theme2 = UIColor.cyan
            interface.theme3 = UIColor(rgb: 0x4286D2)
            
            interface.sliderMin = UIColor.yellow
            interface.sliderMax = UIColor.black
            interface.sliderThumb = UIColor(rgb: 0x4286D2)
            interface.transparent = UIColor.clear
            
            
        case "Candy":
            // blue pink yellow
            interface.main = UIColor.black
            
            interface.mainAlt = UIColor.black
            interface.tableAlt = UIColor(rgb: 0x121212)
            interface.tab = UIColor(rgb: 0x121212)
            
            interface.top = UIColor(rgb: 0x121212)
            interface.bottom = UIColor(rgb: 0x121212)
            interface.tableBackground = UIColor(rgb: 0x121212)
            
            interface.button = UIColor(rgb: 0xDBDBE6)
            interface.text = UIColor(rgb: 0xDBDBE6)
            
            interface.buttonAlt = UIColor.clear
            interface.textAlt = UIColor(rgb: 0x8691AB)
            interface.textIdle = UIColor(rgb: 0x686F81)
            
            interface.theme1 = UIColor(rgb: 0xEC708C)
            interface.theme2 = UIColor(rgb: 0xC95A90) // pink
            interface.theme3 = UIColor(rgb: 0x433261)
            
            interface.sliderMin = UIColor(rgb: 0x2B92AD) // blue
            interface.sliderMax = UIColor.yellow
            interface.sliderThumb = UIColor(rgb: 0xC95A90) // pink
            interface.transparent = UIColor.clear
            
        case "grabient":
            interface.main = UIColor(rgb: 0x0A0526)
            interface.mainAlt = UIColor(rgb: 0x941346)
            interface.top = UIColor(rgb: 0x000000)
            interface.bottom = UIColor(rgb: 0x000000)
            interface.button = UIColor(rgb: 0xD5D5D5)
            interface.buttonAlt = UIColor.clear
            interface.tableBackground = UIColor(rgb: 0x121212)
            interface.tableAlt = UIColor(rgb: 0x121212)
            interface.tab = UIColor(rgb: 0x181818)
            interface.text = UIColor(rgb: 0xD5D5D5)
            interface.textIdle = UIColor(rgb: 0x888888)
            interface.textAlt = UIColor(rgb: 0xD5D5D5)
            interface.theme2 = UIColor(rgb: 0x00B95B)
            interface.theme3 = UIColor(rgb: 0xFF4A3A)
            interface.theme1 = UIColor(rgb: 0x57CCC3)
            interface.sliderMin = UIColor(rgb: 0x00B95B)
            interface.sliderMax = UIColor(rgb: 0x000000)
            interface.sliderThumb = UIColor(rgb: 0x3DBFB6)
            interface.transparent = UIColor.clear
     
        case "Spotify":
            interface.main = UIColor.black
            
            interface.mainAlt = UIColor.black
            interface.tableAlt = UIColor(rgb: 0x121212)
            interface.tab = UIColor(rgb: 0x121212)
            
            interface.top = UIColor(rgb: 0x121212)
            interface.bottom = UIColor(rgb: 0x121212)
            interface.tableBackground = UIColor(rgb: 0x121212)
            
           
            interface.button = UIColor(rgb: 0xFFFFFF)
            interface.buttonAlt = UIColor(rgb: 0x121212)
            
            interface.text = UIColor(rgb: 0xFFFFFF)
            interface.textIdle = UIColor(rgb: 0x888888)
            interface.textAlt = UIColor(rgb: 0xFFFFFF)
            interface.theme2 = UIColor(rgb: 0x00B95B)
            interface.theme3 = UIColor(rgb: 0xFF4A3A)
            interface.theme1 = UIColor(rgb: 0x4286D2)
            interface.sliderMin = UIColor(rgb: 0x4286D2)
            interface.sliderMax = UIColor(rgb: 0x4286D2)
            interface.sliderThumb = UIColor(rgb: 0xFFFFFF)
            interface.transparent = UIColor.clear
        
        default:
            interface.main = UIColor.black
            interface.mainAlt = UIColor.white
            interface.button = UIColor.white
            interface.buttonAlt = UIColor.darkGray
            interface.tableBackground = UIColor.gray
            interface.tableAlt = UIColor.lightGray
            interface.tab = UIColor.lightText
            interface.text = UIColor.lightText
            interface.textAlt = UIColor.lightText
            interface.textIdle = UIColor.darkText
            interface.theme1 = UIColor.cyan
            interface.theme2 = UIColor.green
            interface.theme3 = UIColor.red
            interface.sliderMin = UIColor.yellow
            interface.sliderMax = UIColor.magenta
            interface.sliderThumb = UIColor.white
            interface.transparent = UIColor.clear
        }
        
    }
    let finder = [0x000000, 0x1D1F22, 0x1F2124, 0x2A2C2F, 0x393B3E, 0xD9DADE, 0x525457, 0x00D050, 0xFF5954, 0xFFC045]
    let spotify = [0x000000, 0x121212, 0x181818, 0x333333, 0x000000, 0xFFFFFF, 0x888888, 0x00B95B, 0xFF4A3A, 0x4286D2]
    let bluePinkGreen = [0x000000, 0x0E0E0E, 0x212121, 0x041821, 0x041821, 0xD6D6D6, 0x929292, 0x00D7FC, 0xFF3291, 0x009055]
    let joku = [0x000000, 0x212121, 0x303030, 0x424242, 0x00100B, 0xDCCDE8, 0x33A1FD, 0x52FFEE, 0xD72483, 0xFFC045]
    
    
    
    
    let paletteNames = ["0 Background", "1 Table Background", "2 Table Front", "3 Table Heading", "4 Button Background", "5 Text", "6 TextIdle", "7 Positive", "8 Negative", "9 Highlight"]
    
    
    let blue = [0x000000, 0x011E40, 0x012548, 0x003263, 0x0F497F, 0x0D5BC4, 0x2B95D7, 0xE5AC2F, 0xFF3291]
  
    

    //Material Design colors from https://htmlcolorcodes.com/color-chart/
    func materialDesignColors(x:Int,y:Int) -> Int {
        
        // 19 colors
        /*
         0 /* Red */
         .red { color: #f44336; }
         
         1 /* Pink */
         .pink { color: #e91e63; }
         
         2 /* Purple */
         .purple { color: #9c27b0; }
         
         3 /* Deep Purple */
         .deep-purple { color: #673ab7; }
         
         4 /* Indigo */
         .indigo { color: #3f51b5; }
         
         5 /* Blue */
         .blue { color: #2196f3; }
         
         6 /* Light Blue */
         .light-blue { color: #03a9f4; }
         
         7 /* Cyan */
         .cyan { color: #00bcd4; }
         
         8 /* Teal */
         .teal { color: #009688; }
         
         9 /* Green */
         .green { color: #4caf50; }
         
         10 /* Light Green */
         .light-green { color: #8bc34a; }
         
         11 /* Lime */
         .lime { color: #cddc39; }
         
         12 /* Yellow */
         .yellow { color: #ffeb3b; }
         
         13 /* Amber */
         .amber { color: #ffc107; }
         
         14 /* Orange */
         .orange { color: #ff9800; }
         
         15 /* Deep Orange */
         .deep-orange { color: #ff5722; }
         
         16 /* Brown */
         .brown { color: #795548; }
         
         17 /* Grey */
         .grey { color: #9e9e9e; }
         
         18 /* Blue Grey */
         .blue-grey { color: #607d8b; }
         
         /* White / Black */
         .white { color: #ffffff; }
         .black { color: #000000; }
         
         
        */
       
       // print("X: \(x) Y: \(y)")
        var hex = 0xFFFFFF
        
        // 10 shades for each color
        switch x {
        case 0:
            switch y {
            case 0: hex = 0xB71C1C
            case 1: hex = 0x880E4F
            case 2: hex = 0x4A148C
            case 3: hex = 0x311B92
            case 4: hex = 0x1A237E
            case 5: hex = 0x0D47A1
            case 6: hex = 0x01579B
            case 7: hex = 0x006064
            case 8: hex = 0x004D40
            case 9: hex = 0x1B5E20
            case 10: hex = 0x33691E
            case 11: hex = 0x827717
            case 12: hex = 0xF57F17
            case 13: hex = 0xFF6F00
            case 14: hex = 0xE65100
            case 15: hex = 0xBF360C
            case 16: hex = 0x3E2723
            case 17: hex = 0x212121
            case 18: hex = 0x263238
            default: hex = 0xFFFFFF
            }
        case 1:
            switch y {
            case 0: hex = 0xC62828
            case 1: hex = 0xad1457
            case 2: hex = 0x6a1b9a
            case 3: hex = 0x4527a0
            case 4: hex = 0x283593
            case 5: hex = 0x1565c0
            case 6: hex = 0x0277bd
            case 7: hex = 0x00838f
            case 8: hex = 0x00695c
            case 9: hex = 0x2e7d32
            case 10: hex = 0x558b2f
            case 11: hex = 0x9e9d24
            case 12: hex = 0xf9a825
            case 13: hex = 0xff8f00
            case 14: hex = 0xef6c00
            case 15: hex = 0xd84315
            case 16: hex = 0x4e342e
            case 17: hex = 0x424242
            case 18: hex = 0x37474f
            default: hex = 0xFFFFFF
            }
        case 2:
            switch y {
            case 0: hex = 0xD32F2F
            case 1: hex = 0xc2185b
            case 2: hex = 0x7b1fa2
            case 3: hex = 0x512da8
            case 4: hex = 0x303f9f
            case 5: hex = 0x1976d2
            case 6: hex = 0x0288d1
            case 7: hex = 0x0097a7
            case 8: hex = 0x00796b
            case 9: hex = 0x388e3c
            case 10: hex = 0x689f38
            case 11: hex = 0xafb42b
            case 12: hex = 0xfbc02d
            case 13: hex = 0xffa000
            case 14: hex = 0xf57c00
            case 15: hex = 0xe64a19
            case 16: hex = 0x5d4037
            case 17: hex = 0x616161
            case 18: hex = 0x455a64
            default: hex = 0xFFFFFF
            }
        case 3:
            switch y {
            case 0: hex = 0xE53935
            case 1: hex = 0xd81b60
            case 2: hex = 0x8e24aa
            case 3: hex = 0x5e35b1
            case 4: hex = 0x3949ab
            case 5: hex = 0x1e88e5
            case 6: hex = 0x039be5
            case 7: hex = 0x00acc1
            case 8: hex = 0x00897b
            case 9: hex = 0x43a047
            case 10: hex = 0x7cb342
            case 11: hex = 0xc0ca33
            case 12: hex = 0xfdd835
            case 13: hex = 0xffb300
            case 14: hex = 0xfb8c00
            case 15: hex = 0xf4511e
            case 16: hex = 0x6d4c41
            case 17: hex = 0x757575
            case 18: hex = 0x546e7a
            default: hex = 0xFFFFFF
            }
        case 4:
            switch y {
            case 0: hex = 0xF44336
            case 1: hex = 0xe91e63
            case 2: hex = 0x9c27b0
            case 3: hex = 0x673ab7
            case 4: hex = 0x3f51b5
            case 5: hex = 0x2196f3
            case 6: hex = 0x03a9f4
            case 7: hex = 0x00bcd4
            case 8: hex = 0x009688
            case 9: hex = 0x4caf50
            case 10: hex = 0x8bc34a
            case 11: hex = 0xcddc39
            case 12: hex = 0xffeb3b
            case 13: hex = 0xffc107
            case 14: hex = 0xff9800
            case 15: hex = 0xff5722
            case 16: hex = 0x795548
            case 17: hex = 0x9e9e9e
            case 18: hex = 0x607d8b
            default: hex = 0xFFFFFF
            }
        case 5:
            switch y {
            case 0: hex = 0xEF5350
            case 1: hex = 0xec407a
            case 2: hex = 0xab47bc
            case 3: hex = 0x7e57c2
            case 4: hex = 0x5c6bc0
            case 5: hex = 0x42a5f5
            case 6: hex = 0x29b6f6
            case 7: hex = 0x26c6da
            case 8: hex = 0x26a69a
            case 9: hex = 0x66bb6a
            case 10: hex = 0x9ccc65
            case 11: hex = 0xd4e157
            case 12: hex = 0xffee58
            case 13: hex = 0xffca28
            case 14: hex = 0xffa726
            case 15: hex = 0xff7043
            case 16: hex = 0x8d6e63
            case 17: hex = 0xbdbdbd
            case 18: hex = 0x78909c
            default: hex = 0xFFFFFF
            }
        case 6:
            switch y {
            case 0: hex = 0xE57373
            case 1: hex = 0xf06292
            case 2: hex = 0xba68c8
            case 3: hex = 0x9575cd
            case 4: hex = 0x7986cb
            case 5: hex = 0x64b5f6
            case 6: hex = 0x4fc3f7
            case 7: hex = 0x4dd0e1
            case 8: hex = 0x4db6ac
            case 9: hex = 0x81c784
            case 10: hex = 0xaed581
            case 11: hex = 0xdce775
            case 12: hex = 0xfff176
            case 13: hex = 0xffd54f
            case 14: hex = 0xffb74d
            case 15: hex = 0xff8a65
            case 16: hex = 0xa1887f
            case 17: hex = 0xe0e0e0
            case 18: hex = 0x90a4ae
            default: hex = 0xFFFFFF
            }
        case 7:
            switch y {
            case 0: hex = 0xEF9A9A
            case 1: hex = 0xf48fb1
            case 2: hex = 0xce93d8
            case 3: hex = 0xb39ddb
            case 4: hex = 0x9fa8da
            case 5: hex = 0x90caf9
            case 6: hex = 0x81d4fa
            case 7: hex = 0x80deea
            case 8: hex = 0x80cbc4
            case 9: hex = 0xa5d6a7
            case 10: hex = 0xc5e1a5
            case 11: hex = 0xe6ee9c
            case 12: hex = 0xfff59d
            case 13: hex = 0xffe082
            case 14: hex = 0xffcc80
            case 15: hex = 0xffab91
            case 16: hex = 0xbcaaa4
            case 17: hex = 0xeeeeee
            case 18: hex = 0xb0bec5
            default: hex = 0xFFFFFF
            }
        case 8:
            switch y {
            case 0: hex = 0xFFCDD2
            case 1: hex = 0xf8bbd0
            case 2: hex = 0xe1bee7
            case 3: hex = 0xd1c4e9
            case 4: hex = 0xc5cae9
            case 5: hex = 0xbbdefb
            case 6: hex = 0xb3e5fc
            case 7: hex = 0xb2ebf2
            case 8: hex = 0xb2dfdb
            case 9: hex = 0xc8e6c9
            case 10: hex = 0xdcedc8
            case 11: hex = 0xf0f4c3
            case 12: hex = 0xfff9c4
            case 13: hex = 0xffecb3
            case 14: hex = 0xffe0b2
            case 15: hex = 0xffccbc
            case 16: hex = 0xd7ccc8
            case 17: hex = 0xf5f5f5
            case 18: hex = 0xcfd8dc
            default: hex = 0xFFFFFF
            }
        case 9:
            switch y {
            case 0: hex = 0xFFEBEE
            case 1: hex = 0xfce4ec
            case 2: hex = 0xf3e5f5
            case 3: hex = 0xede7f6
            case 4: hex = 0xe8eaf6
            case 5: hex = 0xe3f2fd
            case 6: hex = 0xe1f5fe
            case 7: hex = 0xe0f7fa
            case 8: hex = 0xe0f2f1
            case 9: hex = 0xe8f5e9
            case 10: hex = 0xf1f8e9
            case 11: hex = 0xf9fbe7
            case 12: hex = 0xfffde7
            case 13: hex = 0xfff8e1
            case 14: hex = 0xfff3e0
            case 15: hex = 0xfbe9e7
            case 16: hex = 0xefebe9
            case 17: hex = 0xfafafa
            case 18: hex = 0xeceff1
            default: hex = 0xFFFFFF
            }
        default: hex = 0xFFFFFF
        }
      
        
        return hex
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
