import Link from "next/link"
import { Bookmark, Home, Search, User } from "lucide-react"

export default function BookmarksPage() {
  return (
    <div className="flex flex-col h-screen bg-white">
      {/* Header */}
      <header className="border-b p-4">
        <h1 className="text-xl font-semibold text-center">Bookmarks</h1>
      </header>

      {/* Main Content */}
      <main className="flex-1 overflow-auto p-4">
        {/* Bookmarked Novels */}
        <section className="mb-6">
          <h2 className="text-lg font-medium mb-3">Bookmarked Novels</h2>
          <div className="border rounded-md divide-y">
            {[1, 2, 3].map((item) => (
              <Link href={`/novel/${item}`} key={item}>
                <div className="p-3 flex items-center">
                  <div className="bg-gray-200 h-16 w-12 rounded mr-3"></div>
                  <div className="flex-1">
                    <p className="font-medium">Novel Title {item}</p>
                    <p className="text-xs text-gray-500">Author Name</p>
                  </div>
                  <Bookmark className="h-4 w-4 fill-current" />
                </div>
              </Link>
            ))}
          </div>
        </section>

        {/* Bookmarked Chapters */}
        <section>
          <h2 className="text-lg font-medium mb-3">Bookmarked Chapters</h2>
          <div className="border rounded-md divide-y">
            {[
              { novel: 1, chapter: 3 },
              { novel: 2, chapter: 5 },
              { novel: 3, chapter: 1 },
            ].map((item, index) => (
              <Link href={`/novel/${item.novel}/chapter/${item.chapter}`} key={index}>
                <div className="p-3 flex items-center">
                  <div className="bg-gray-200 h-16 w-12 rounded mr-3"></div>
                  <div className="flex-1">
                    <p className="font-medium">Novel Title {item.novel}</p>
                    <p className="text-xs text-gray-500">Chapter {item.chapter}</p>
                  </div>
                  <Bookmark className="h-4 w-4 fill-current" />
                </div>
              </Link>
            ))}
          </div>
        </section>
      </main>

      {/* Bottom Navigation */}
      <nav className="border-t grid grid-cols-4 p-2">
        <Link href="/" className="flex flex-col items-center p-2">
          <Home className="h-5 w-5" />
          <span className="text-xs mt-1">Home</span>
        </Link>
        <Link href="/search" className="flex flex-col items-center p-2">
          <Search className="h-5 w-5" />
          <span className="text-xs mt-1">Search</span>
        </Link>
        <Link href="/bookmarks" className="flex flex-col items-center p-2">
          <Bookmark className="h-5 w-5 fill-current" />
          <span className="text-xs mt-1">Bookmarks</span>
        </Link>
        <Link href="/profile" className="flex flex-col items-center p-2">
          <User className="h-5 w-5" />
          <span className="text-xs mt-1">Profile</span>
        </Link>
      </nav>
    </div>
  )
}

