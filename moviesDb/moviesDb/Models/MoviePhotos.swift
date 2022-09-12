struct MoviePhotos: Hashable {
    var id: Int
    var imagePhoto: String
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}
