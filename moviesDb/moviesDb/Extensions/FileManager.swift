
import Foundation

public extension FileManager {
  static var documentsDirectoryURL: URL {
    `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
