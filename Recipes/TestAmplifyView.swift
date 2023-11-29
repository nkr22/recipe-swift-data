//
//  TestAmplifyView.swift
//  Recipes
//
//  Created by Noelia Root on 11/26/23.
//

import SwiftUI
import Amplify

struct TestAmplifyView: View {
    let imageKey: String = "house-icon"
    @State var image: UIImage?

    var body: some View {
        VStack(spacing: 40) {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            Button("Upload") {
                Task {
                       do {
                           try await uploadImage()
                       } catch {
                           print("Error uploading image: \(error)")
                       }
                   }
            }
            Button("Download") {
                Task {
                       do {
                           try await downloadImage()
                       } catch {
                           print("Error uploading image: \(error)")
                       }
                   }
            }
//            Button("Download", action: downloadImage)
        }
    }
    func uploadImage() async throws {
        print("start")
        guard let image = UIImage(systemName: "house") else {
                throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to create image"])
            }
            
            // Convert UIImage to Data
            print("image data")
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                print("error")
                throw NSError(domain: "ImageDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to convert image to Data"])
            }
            
            // Upload the image data
            let uploadTask = Amplify.Storage.uploadData(
                key: imageKey,
                data: imageData
            )

            Task {
                for await progress in await uploadTask.progress {
                    print("Progress: \(progress)")
                }
            }

            let value = try await uploadTask.value
            print("Completed: uploading \(value)")
        }
    
    func downloadImage() async throws {
        do {
           let downloadTask = Amplify.Storage.downloadData(key: imageKey)
           Task {
               for await progress in await downloadTask.progress {
                   print("Progress: \(progress)")
               }
           }
           let data = try await downloadTask.value
           print("Completed downloading: \(data)")
            DispatchQueue.main.async {
                            self.image = UIImage(data: data)
                        }
           // Process the downloaded data, e.g., convert to UIImage if it's image data
       } catch {
           // Handle the error appropriately
           print("Error downloading image: \(error)")
       }
    }
}
    

#Preview {
    TestAmplifyView()
}
