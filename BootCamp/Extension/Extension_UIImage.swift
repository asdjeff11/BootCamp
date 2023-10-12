//
//  Extension_UIImage.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit
extension UIImage {
    static func scaleImage(image:UIImage, newSize:CGSize)->UIImage {
        //        获得原图像的尺寸属性
        let imageSize = image.size
        //        获得原图像的宽度数值
        let width = imageSize.width // 500
        //        获得原图像的高度数值
        let height = imageSize.height // 421

        //        计算图像新尺寸与旧尺寸的宽高比例
        let widthFactor = newSize.width/width // 0.115
        let heightFactor = newSize.height/height // 0.136579
        //        获取小邊的比例
        let scalerFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor // 0.136579

        //        计算图像新的高度和宽度，并构成标准的CGSize对象
        let scaledWidth = width * scalerFactor // 68.289
        let scaledHeight = height * scalerFactor // 57.49999
        let targetSize = CGSize(width: scaledWidth, height: scaledHeight)

        //        创建绘图上下文环境，
        UIGraphicsBeginImageContextWithOptions(targetSize,false,0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        //        获取上下文里的内容，将视图写入到新的图像对象
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 裁截
        let newWidth = newSize.width
        let newHeight = newSize.height
        
        let renderer = UIGraphicsImageRenderer(size:newSize)
        if let img = newImage {
            let x = -( img.size.width - newWidth ) / 2
            let y = -( img.size.height - newHeight ) / 2
            newImage = renderer.image { (context) in
                img.draw(at: CGPoint(x: x, y: y))
            }
        }
        return newImage ?? image
    } // 調整圖片大小
}
