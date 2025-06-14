import Link from "next/link"
import { BookOpen, Heart, Home, Search, User } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

export default function HomePage() {
  return (
    <div className="flex flex-col h-screen bg-white">
      {/* Header */}
      <header className="border-b p-4 flex items-center justify-between">
        <div className="font-bold text-xl">NovelRead</div>
        <div className="flex items-center gap-4">
          <Link href="/search">
            <Search className="h-5 w-5" />
          </Link>
          <Link href="/profile">
            <User className="h-5 w-5" />
          </Link>
        </div>
      </header>

      {/* Main Content */}
      <main className="flex-1 overflow-auto">
        {/* Banner Promo */}
        <section className="relative h-48 mb-6">
          <div className="absolute inset-0 bg-gradient-to-r from-primary/80 to-primary p-6 flex flex-col justify-end">
            <Badge className="mb-2 w-fit">Trending</Badge>
            <h2 className="text-xl font-bold text-white mb-1">The Dragon's Legacy</h2>
            <div className="flex items-center mb-2">
              <div className="text-yellow-300 text-sm mr-2">★★★★★</div>
              <span className="text-white text-xs">4.9 (2.3k readers)</span>
            </div>
            <Link href="/novel/1">
              <Button size="sm" variant="secondary">
                Read Now
              </Button>
            </Link>
          </div>
        </section>

        {/* Categories */}
        <section className="px-4 mb-6">
          <div className="flex justify-between items-center mb-3">
            <h2 className="text-lg font-bold">Categories</h2>
            <Link href="/categories" className="text-sm text-primary">
              See All
            </Link>
          </div>
          <div className="flex overflow-x-auto gap-2 pb-2 no-scrollbar">
            {["Fantasy", "Romance", "Mystery", "Sci-Fi", "Horror", "Adventure", "Historical"].map((category) => (
              <Link href={`/category/${category.toLowerCase()}`} key={category}>
                <div className="flex-shrink-0 px-4 py-2 bg-primary/10 rounded-full text-sm font-medium">{category}</div>
              </Link>
            ))}
          </div>
        </section>

        {/* Popular Novels */}
        <section className="px-4 mb-6">
          <div className="flex justify-between items-center mb-3">
            <h2 className="text-lg font-bold">Popular Now</h2>
            <Link href="/popular" className="text-sm text-primary">
              See All
            </Link>
          </div>
          <div className="grid grid-cols-2 gap-4">
            {[
              { id: 1, title: "The Dragon's Legacy", author: "Sarah Johnson", rating: 4.9, readers: "2.3k" },
              { id: 2, title: "Midnight Shadows", author: "James Wilson", rating: 4.7, readers: "1.8k" },
              { id: 3, title: "The Lost City", author: "Emily Chen", rating: 4.8, readers: "2.1k" },
              { id: 4, title: "Heart's Desire", author: "Michael Brown", rating: 4.6, readers: "1.5k" },
            ].map((novel) => (
              <Link href={`/novel/${novel.id}`} key={novel.id}>
                <Card className="overflow-hidden border-none shadow-sm">
                  <div className="bg-gray-200 h-40 relative">
                    <div className="absolute bottom-2 right-2 bg-white rounded-full p-1">
                      <Heart className="h-4 w-4 text-gray-500" />
                    </div>
                  </div>
                  <CardContent className="p-3">
                    <h3 className="font-semibold text-sm line-clamp-1">{novel.title}</h3>
                    <p className="text-xs text-gray-500 mb-1">{novel.author}</p>
                    <div className="flex items-center">
                      <span className="text-yellow-500 text-xs mr-1">★</span>
                      <span className="text-xs">{novel.rating}</span>
                      <span className="text-xs text-gray-500 ml-2">({novel.readers})</span>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            ))}
          </div>
        </section>

        {/* Continue Reading */}
        <section className="px-4 mb-6">
          <div className="flex justify-between items-center mb-3">
            <h2 className="text-lg font-bold">Continue Reading</h2>
            <Link href="/reading-list" className="text-sm text-primary">
              See All
            </Link>
          </div>
          <Card className="overflow-hidden">
            <div className="flex p-3">
              <div className="bg-gray-200 h-24 w-16 rounded-md mr-3"></div>
              <div className="flex-1">
                <h3 className="font-semibold mb-1">The Lost City</h3>
                <p className="text-xs text-gray-500 mb-2">Chapter 5 of 32</p>
                <div className="w-full bg-gray-200 h-1.5 rounded-full mb-2">
                  <div className="bg-primary h-1.5 rounded-full w-[45%]"></div>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-xs text-gray-500">45% completed</span>
                  <Link href="/novel/3/chapter/5">
                    <Button size="sm" variant="outline">
                      Continue
                    </Button>
                  </Link>
                </div>
              </div>
            </div>
          </Card>
        </section>

        {/* New Releases */}
        <section className="px-4 mb-6">
          <div className="flex justify-between items-center mb-3">
            <h2 className="text-lg font-bold">New Releases</h2>
            <Link href="/new-releases" className="text-sm text-primary">
              See All
            </Link>
          </div>
          <div className="flex overflow-x-auto gap-3 pb-2 no-scrollbar">
            {[
              { id: 5, title: "Eternal Flame", author: "Lisa Wong" },
              { id: 6, title: "Silent Whispers", author: "Robert Davis" },
              { id: 7, title: "Beyond the Stars", author: "Anna Smith" },
              { id: 8, title: "The Hidden Truth", author: "David Miller" },
            ].map((novel) => (
              <Link href={`/novel/${novel.id}`} key={novel.id} className="flex-shrink-0 w-32">
                <div className="bg-gray-200 h-44 w-32 rounded-md mb-2"></div>
                <h3 className="font-semibold text-sm line-clamp-1">{novel.title}</h3>
                <p className="text-xs text-gray-500">{novel.author}</p>
              </Link>
            ))}
          </div>
        </section>
      </main>

      {/* Bottom Navigation */}
      <nav className="border-t grid grid-cols-3 py-2">
        <Link href="/" className="flex flex-col items-center p-2 text-primary">
          <Home className="h-5 w-5" />
          <span className="text-xs mt-1">Home</span>
        </Link>
        <Link href="/reading-list" className="flex flex-col items-center p-2 text-gray-500">
          <BookOpen className="h-5 w-5" />
          <span className="text-xs mt-1">My Books</span>
        </Link>
        <Link href="/profile" className="flex flex-col items-center p-2 text-gray-500">
          <User className="h-5 w-5" />
          <span className="text-xs mt-1">Profile</span>
        </Link>
      </nav>
    </div>
  )
}

