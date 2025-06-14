"use client"

import type React from "react"

import Link from "next/link"
import { useState } from "react"
import { BookOpen, Home, Search, User, X } from "lucide-react"
import { Card, CardContent } from "@/components/ui/card"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

export default function SearchPage() {
  const [searchQuery, setSearchQuery] = useState("")
  const [hasSearched, setHasSearched] = useState(false)

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    if (searchQuery.trim()) {
      setHasSearched(true)
    }
  }

  const clearSearch = () => {
    setSearchQuery("")
    setHasSearched(false)
  }

  return (
    <div className="flex flex-col h-screen bg-white">
      {/* Header */}
      <header className="border-b p-4">
        <h1 className="text-xl font-semibold text-center">Search</h1>
      </header>

      {/* Main Content */}
      <main className="flex-1 overflow-auto p-4">
        {/* Search Input */}
        <form onSubmit={handleSearch} className="mb-6">
          <div className="relative">
            <input
              type="text"
              placeholder="Search novels, authors..."
              className="w-full border rounded-md p-3 pl-10 pr-10"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
            {searchQuery && (
              <button
                type="button"
                className="absolute right-3 top-1/2 transform -translate-y-1/2"
                onClick={clearSearch}
              >
                <X className="h-5 w-5 text-gray-400" />
              </button>
            )}
          </div>
        </form>

        {hasSearched ? (
          <Tabs defaultValue="all" className="w-full">
            <TabsList className="grid grid-cols-3 w-full mb-4">
              <TabsTrigger value="all">All</TabsTrigger>
              <TabsTrigger value="novels">Novels</TabsTrigger>
              <TabsTrigger value="authors">Authors</TabsTrigger>
            </TabsList>

            <TabsContent value="all">
              <div className="grid gap-4">
                {[
                  { id: 1, title: "The Dragon's Legacy", author: "Sarah Johnson", type: "Fantasy" },
                  { id: 2, title: "Midnight Shadows", author: "James Wilson", type: "Mystery" },
                ].map((result) => (
                  <Card key={result.id}>
                    <CardContent className="p-0">
                      <Link href={`/novel/${result.id}`}>
                        <div className="flex p-3">
                          <div className="bg-gray-200 h-24 w-16 rounded-md mr-3"></div>
                          <div className="flex-1">
                            <h3 className="font-semibold mb-1">{result.title}</h3>
                            <p className="text-xs text-gray-500 mb-1">{result.author}</p>
                            <span className="text-xs bg-gray-100 px-2 py-0.5 rounded-full">{result.type}</span>
                          </div>
                        </div>
                      </Link>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </TabsContent>

            <TabsContent value="novels">
              <div className="grid gap-4">
                {[
                  { id: 1, title: "The Dragon's Legacy", author: "Sarah Johnson", type: "Fantasy" },
                  { id: 3, title: "The Lost City", author: "Emily Chen", type: "Adventure" },
                ].map((result) => (
                  <Card key={result.id}>
                    <CardContent className="p-0">
                      <Link href={`/novel/${result.id}`}>
                        <div className="flex p-3">
                          <div className="bg-gray-200 h-24 w-16 rounded-md mr-3"></div>
                          <div className="flex-1">
                            <h3 className="font-semibold mb-1">{result.title}</h3>
                            <p className="text-xs text-gray-500 mb-1">{result.author}</p>
                            <span className="text-xs bg-gray-100 px-2 py-0.5 rounded-full">{result.type}</span>
                          </div>
                        </div>
                      </Link>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </TabsContent>

            <TabsContent value="authors">
              <div className="grid gap-4">
                {[
                  { id: 1, name: "Sarah Johnson", books: 12, genre: "Fantasy" },
                  { id: 2, name: "James Wilson", books: 8, genre: "Mystery" },
                ].map((author) => (
                  <Card key={author.id}>
                    <CardContent className="p-3">
                      <div className="flex items-center">
                        <div className="bg-gray-200 h-12 w-12 rounded-full mr-3"></div>
                        <div>
                          <h3 className="font-semibold">{author.name}</h3>
                          <p className="text-xs text-gray-500">
                            {author.books} books • {author.genre}
                          </p>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </TabsContent>
          </Tabs>
        ) : (
          <>
            {/* Popular Searches */}
            <section className="mb-6">
              <h2 className="text-lg font-medium mb-3">Popular Searches</h2>
              <div className="flex flex-wrap gap-2">
                {["Fantasy", "Romance", "Mystery", "Adventure", "Sci-Fi", "Horror", "Historical", "Young Adult"].map(
                  (tag) => (
                    <div
                      key={tag}
                      className="border rounded-full px-3 py-1 text-sm cursor-pointer hover:bg-gray-50"
                      onClick={() => {
                        setSearchQuery(tag)
                        setHasSearched(true)
                      }}
                    >
                      {tag}
                    </div>
                  ),
                )}
              </div>
            </section>

            {/* Recent Searches */}
            <section>
              <h2 className="text-lg font-medium mb-3">Recent Searches</h2>
              <div className="border rounded-md divide-y">
                {["Dragon Knight", "Love in Paris", "Mystery of the Ancient Temple"].map((search) => (
                  <div key={search} className="p-3 flex justify-between items-center">
                    <div
                      className="flex items-center cursor-pointer"
                      onClick={() => {
                        setSearchQuery(search)
                        setHasSearched(true)
                      }}
                    >
                      <Search className="h-4 w-4 mr-3 text-gray-400" />
                      <span>{search}</span>
                    </div>
                    <X className="h-4 w-4 text-gray-400 cursor-pointer" />
                  </div>
                ))}
              </div>
            </section>
          </>
        )}
      </main>

      {/* Bottom Navigation */}
      <nav className="border-t grid grid-cols-3 py-2">
        <Link href="/" className="flex flex-col items-center p-2 text-gray-500">
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

