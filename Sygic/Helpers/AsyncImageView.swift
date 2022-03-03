import SwiftUI
import Combine

struct AsyncImageView<Placeholder: View, ConfiguredImage: View>: View {
    var url: String
    private let placeholder: () -> Placeholder
    private let image: (Image) -> ConfiguredImage

    @ObservedObject var imageLoader: ImageLoaderService
    @State var imageData: UIImage?


    init(
        url: String,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> ConfiguredImage
    ) {
        self.url = url
        self.placeholder = placeholder
        self.image = image
        self.imageLoader = ImageLoaderService(url: url)
    }

    @ViewBuilder private var imageContent: some View {
        if let data = imageData {
            image(Image(uiImage: data))
        } else {
            placeholder()
        }
    }

    var body: some View {
        imageContent
            .onReceive(imageLoader.$image) { imageData in
                self.imageData = imageData
            }
    }
}

class ImageLoaderService: ObservableObject {
    @Published var image = UIImage()
    private var cancellables: Set<AnyCancellable> = []


    convenience init(url: String) {
        self.init()
        loadImage(for: url)
    }

    func loadImage(for url: String) {
        APIManager.downloadImage(url: url).sink(receiveCompletion: {value  in
            print(value)
        }, receiveValue: { data in
            self.image = UIImage(data: data) ?? UIImage()
        })
            .store(in: &cancellables)

        
//        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
//            guard let data = data else { return }
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data) ?? UIImage()
//            }
//        }
//        task.resume()
    }
}
