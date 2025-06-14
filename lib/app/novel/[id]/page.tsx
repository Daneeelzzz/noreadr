import Link from "next/link"
import { ArrowLeft, Bookmark, Heart, Share2, Star } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"

export default function NovelDetailPage({ params }: { params: { id: string } }) {
  // Mock data based on novel ID
  const novel = {
    id: params.id,
    title:
      params.id === "1"
        ? "The Dragon's Legacy"
        : params.id === "2"
          ? "Midnight Shadows"
          : params.id === "3"
            ? "The Lost City"
            : `Novel Title ${params.id}`,
    author:
      params.id === "1"
        ? "Sarah Johnson"
        : params.id === "2"
          ? "James Wilson"
          : params.id === "3"
            ? "Emily Chen"
            : "Author Name",
    rating: 4.8,
    reviews: 120,
    genre: "Fantasy",
    chapters: 32,
    synopsis:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    reviews: [
      { id: 1, user: "Alex", rating: 5, comment: "Absolutely loved this novel! The character development is amazing." },
      { id: 2, user: "Jamie", rating: 4, comment: "Great story with a few slow parts, but overall very enjoyable." },
      {
        id: 3,
        user: "Taylor",
        rating: 5,
        comment: "One of the best novels I've read this year. Can't wait for more from this author!",
      },
    ],
  }

  return (
    <div className="flex flex-col h-screen bg-white">
      {/* Header */}
      <header className="border-b p-4 flex items-center justify-between">
        <Link href="/">
          <ArrowLeft className="h-5 w-5" />
        </Link>
        <h1 className="text-lg font-semibold">Novel Details</h1>
        <Share2 className="h-5 w-5" />
      </header>

      {/* Main Content */}
      <main className="flex-1 overflow-auto">
        {/* Novel Info */}
        <div className="p-4 flex">
          <div className="bg-gray-200 h-48 w-32 rounded-md mr-4 shadow-md"></div>
          <div className="flex-1">
            <h2 className="text-xl font-bold mb-1">{novel.title}</h2>
            <p className="text-sm text-gray-600 mb-2">{novel.author}</p>

            <div className="flex items-center mb-2">
              <div className="flex text-yellow-500 mr-2">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="h-4 w-4 fill-current" />
                ))}
              </div>
              <span className="text-sm">{novel.rating}</span>
              <span className="text-sm text-gray-500 ml-1">({novel.reviews} reviews)</span>
            </div>

            <div className="flex gap-2 mb-4">
              <span className="bg-primary/10 text-primary text-xs px-2 py-1 rounded-full">{novel.genre}</span>
              <span className="bg-gray-100 text-gray-700 text-xs px-2 py-1 rounded-full">
                {novel.chapters} chapters
              </span>
            </div>

            <div className="flex gap-2">
              <Button className="flex-1">Read Now</Button>
              <Button variant="outline" size="icon">
                <Bookmark className="h-4 w-4" />
              </Button>
              <Button variant="outline" size="icon">
                <Heart className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </div>

        {/* Tabs */}
        <Tabs defaultValue="about" className="w-full">
          <TabsList className="grid grid-cols-3 w-full">
            <TabsTrigger value="about">About</TabsTrigger>
            <TabsTrigger value="chapters">Chapters</TabsTrigger>
            <TabsTrigger value="reviews">Reviews</TabsTrigger>
          </TabsList>

          <TabsContent value="about" className="p-4">
            <h3 className="text-lg font-semibold mb-2">Synopsis</h3>
            <p className="text-sm text-gray-700 mb-4">{novel.synopsis}</p>
            <p className="text-sm text-gray-700">{novel.synopsis}</p>
          </TabsContent>

          <TabsContent value="chapters" className="divide-y">
            {[...Array(5)].map((_, i) => (
              <Link href={`/novel/${params.id}/chapter/${i + 1}`} key={i}>
                <div className="p-4 flex justify-between items-center">
                  <div>
                    <h3 className="font-medium">Chapter {i + 1}</h3>
                    <p className="text-xs text-gray-500">Updated 2 days ago</p>
                  </div>
                  <Bookmark className="h-4 w-4 text-gray-400" />
                </div>
              </Link>
            ))}
            <div className="p-4 text-center">
              <Button variant="outline">View All Chapters</Button>
            </div>
          </TabsContent>

          <TabsContent value="reviews" className="p-4">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-semibold">Reviews</h3>
              <Button variant="outline" size="sm">
                Write Review
              </Button>
            </div>

            <div className="space-y-4">
              {novel.reviews.map((review) => (
                <div key={review.id} className="border rounded-lg p-3">
                  <div className="flex items-center mb-2">
                    <Avatar className="h-8 w-8 mr-2">
                      <AvatarFallback>{review.user[0]}</AvatarFallback>
                    </Avatar>
                    <div>
                      <p className="font-medium text-sm">{review.user}</p>
                      <div className="flex text-yellow-500">
                        {[...Array(review.rating)].map((_, i) => (
                          <Star key={i} className="h-3 w-3 fill-current" />
                        ))}
                      </div>
                    </div>
                  </div>
                  <p className="text-sm text-gray-700">{review.comment}</p>
                </div>
              ))}
            </div>

            <Button variant="outline" className="w-full mt-4">
              Load More Reviews
            </Button>
          </TabsContent>
        </Tabs>
      </main>
    </div>
  )
}

