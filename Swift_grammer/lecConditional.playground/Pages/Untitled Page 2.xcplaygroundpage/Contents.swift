import Foundation

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) { // 2-phase init
        self.artist = artist
        super.init(name: name)
    }
}


// 타입 캐스팅 연산자
// is, as
let library = [
    Song(name: "butter", artist: "BTS"),
    Song(name: "Wonderwall", artist: "Oasis"),
    Song(name: "Rain", artist: "이적"),
    Movie(name: "interstella", director: "christoperNolan"),
    Movie(name: "올드보이", director: "박찬욱")
]

var movieCount = 0
var songCount = 0

// casting 연산자 is
for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}

print("movieCount: \(movieCount)") // result: movieCount: 2
print("songCount: \(songCount)") // result: songCount: 3

// casting 연산자 as?
// downCasting
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir: \(movie.director)")
    } else if let song = item as? Song {
        print("Song : \(song.name), singer: \(song.artist)")
    }
}
