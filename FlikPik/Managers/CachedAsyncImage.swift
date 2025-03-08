//
//  CachedAsyncImage.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/7/25.
//

import SwiftUI

// Create a custom image loader with cache
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private static var cache = NSCache<NSString, UIImage>()
    private var cancellable: Task<Void, Never>?
    private var url: URL?
    
    func load(from url: URL) {
        self.url = url
        let urlString = url.absoluteString as NSString
        
        // Check if image is in cache
        if let cachedImage = Self.cache.object(forKey: urlString) {
            self.image = cachedImage
            #if DEBUG
//            print("✅ Found image in cache for: \(url.absoluteString)")
            #endif
            return
        }
        
        // Cancel previous task if any
        cancellable?.cancel()
        
        // Start new download task
        cancellable = Task {
            do {
                #if DEBUG
//                print("🔄 Starting to download image: \(url.absoluteString)")
                #endif
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // Check if not cancelled
                if !Task.isCancelled, let uiImage = UIImage(data: data) {
                    Self.cache.setObject(uiImage, forKey: urlString)
                    
                    // Make sure we're still loading the same URL
                    if self.url == url {
                        await MainActor.run {
                            #if DEBUG
//                            print("✅ Successfully downloaded image: \(url.absoluteString)")
                            #endif
                            self.image = uiImage
                        }
                    }
                }
            } catch {
                if !Task.isCancelled {
                    #if DEBUG
//                    print("❌ Failed to load image: \(error.localizedDescription)")
                    #endif
                }
            }
        }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    deinit {
        cancel()
    }
}

struct CachedAsyncImage: View {
    let url: URL?
    @StateObject private var loader = ImageLoader()
    let aspectRatio: CGFloat
    
    init(url: URL?, aspectRatio: CGFloat = 2/3) {
        self.url = url
        self.aspectRatio = aspectRatio
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .cornerRadius(8)
                    .overlay(
                        ProgressView()
                    )
            }
        }
        .onAppear {
            if let url = url {
                #if DEBUG
//                print("🔍 CachedAsyncImage requesting image: \(url.absoluteString)")
                #endif
                loader.load(from: url)
            } else {
                #if DEBUG
                print("⚠️ CachedAsyncImage: URL is nil")
                #endif
            }
        }
        .onDisappear {
            loader.cancel()
        }
    }
}

// Placeholder for failed image loading
struct ImageLoadFailure: View {
    let aspectRatio: CGFloat
    
    init(aspectRatio: CGFloat = 2/3) {
        self.aspectRatio = aspectRatio
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .aspectRatio(aspectRatio, contentMode: .fit)
            .cornerRadius(8)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.white)
            )
    }
}
