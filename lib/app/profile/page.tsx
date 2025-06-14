"use client"

import Link from "next/link"
import { useState } from "react"
import { BookOpen, Home, LogOut, Moon, Settings, Sun, User } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Card, CardContent } from "@/components/ui/card"
import { Switch } from "@/components/ui/switch"

export default function ProfilePage() {
  const [isDarkMode, setIsDarkMode] = useState(false)

  return (
    <div className={`flex flex-col h-screen ${isDarkMode ? "dark" : ""}`}>
      {/* Header */}
      <header className="border-b p-4 flex items-center justify-between">
        <h1 className="text-xl font-semibold">Profile</h1>
        <Link href="/settings">
          <Settings className="h-5 w-5" />
        </Link>
      </header>

      {/* Main Content */}
      <main className="flex-1 overflow-auto">
        {/* Profile Info */}
        <div className="p-6 flex flex-col items-center border-b">
          <Avatar className="h-20 w-20 mb-3">
            <AvatarImage src="/placeholder.svg?height=80&width=80" />
            <AvatarFallback>JD</AvatarFallback>
          </Avatar>
          <h2 className="text-xl font-bold mb-1">John Doe</h2>
          <p className="text-sm text-gray-500 mb-3">@johndoe</p>
          <div className="flex gap-4 text-sm text-gray-600">
            <div className="flex flex-col items-center">
              <span className="font-bold">42</span>
              <span>Books</span>
            </div>
            <div className="border-r border-gray-300"></div>
            <div className="flex flex-col items-center">
              <span className="font-bold">128</span>
              <span>Reviews</span>
            </div>
            <div className="border-r border-gray-300"></div>
            <div className="flex flex-col items-center">
              <span className="font-bold">15</span>
              <span>Lists</span>
            </div>
          </div>
        </div>

        {/* Reading Lists */}
        <Tabs defaultValue="reading" className="w-full">
          <TabsList className="grid grid-cols-3 w-full">
            <TabsTrigger value="reading">Reading</TabsTrigger>
            <TabsTrigger value="completed">Completed</TabsTrigger>
            <TabsTrigger value="wishlist">Wishlist</TabsTrigger>
          </TabsList>

          <TabsContent value="reading" className="p-4">
            <div className="grid gap-4">
              {[
                { id: 3, title: "The Lost City", author: "Emily Chen", progress: 45 },
                { id: 2, title: "Midnight Shadows", author: "James Wilson", progress: 23 },
              ].map((book) => (
                <Card key={book.id}>
                  <CardContent className="p-0">
                    <Link href={`/novel/${book.id}`}>
                      <div className="flex p-3">
                        <div className="bg-gray-200 h-24 w-16 rounded-md mr-3"></div>
                        <div className="flex-1">
                          <h3 className="font-semibold mb-1">{book.title}</h3>
                          <p className="text-xs text-gray-500 mb-2">{book.author}</p>
                          <div className="w-full bg-gray-200 h-1.5 rounded-full mb-1">
                            <div className="bg-primary h-1.5 rounded-full" style={{ width: `${book.progress}%` }}></div>
                          </div>
                          <span className="text-xs text-gray-500">{book.progress}% completed</span>
                        </div>
                      </div>
                    </Link>
                  </CardContent>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="completed" className="p-4">
            <div className="grid gap-4">
              {[
                { id: 1, title: "The Dragon's Legacy", author: "Sarah Johnson" },
                { id: 5, title: "Eternal Flame", author: "Lisa Wong" },
              ].map((book) => (
                <Card key={book.id}>
                  <CardContent className="p-0">
                    <Link href={`/novel/${book.id}`}>
                      <div className="flex p-3">
                        <div className="bg-gray-200 h-24 w-16 rounded-md mr-3"></div>
                        <div className="flex-1">
                          <h3 className="font-semibold mb-1">{book.title}</h3>
                          <p className="text-xs text-gray-500 mb-2">{book.author}</p>
                          <div className="flex items-center">
                            <div className="text-yellow-500 text-xs mr-1">★★★★★</div>
                            <span className="text-xs">Completed</span>
                          </div>
                        </div>
                      </div>
                    </Link>
                  </CardContent>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="wishlist" className="p-4">
            <div className="grid gap-4">
              {[
                { id: 6, title: "Silent Whispers", author: "Robert Davis" },
                { id: 7, title: "Beyond the Stars", author: "Anna Smith" },
              ].map((book) => (
                <Card key={book.id}>
                  <CardContent className="p-0">
                    <Link href={`/novel/${book.id}`}>
                      <div className="flex p-3">
                        <div className="bg-gray-200 h-24 w-16 rounded-md mr-3"></div>
                        <div className="flex-1">
                          <h3 className="font-semibold mb-1">{book.title}</h3>
                          <p className="text-xs text-gray-500 mb-2">{book.author}</p>
                          <Button size="sm" variant="outline">
                            Add to Reading
                          </Button>
                        </div>
                      </div>
                    </Link>
                  </CardContent>
                </Card>
              ))}
            </div>
          </TabsContent>
        </Tabs>

        {/* App Settings */}
        <div className="p-4 border-t">
          <h3 className="text-lg font-semibold mb-4">Settings</h3>

          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                {isDarkMode ? <Moon className="h-5 w-5" /> : <Sun className="h-5 w-5" />}
                <span>Dark Mode</span>
              </div>
              <Switch checked={isDarkMode} onCheckedChange={setIsDarkMode} />
            </div>

            <div className="flex items-center justify-between">
              <span>Notifications</span>
              <Switch defaultChecked />
            </div>

            <div className="flex items-center justify-between">
              <span>Download over WiFi only</span>
              <Switch defaultChecked />
            </div>

            <Button variant="destructive" className="w-full mt-6 flex items-center justify-center gap-2">
              <LogOut className="h-4 w-4" />
              Logout
            </Button>
          </div>
        </div>
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
        <Link href="/profile" className="flex flex-col items-center p-2 text-primary">
          <User className="h-5 w-5" />
          <span className="text-xs mt-1">Profile</span>
        </Link>
      </nav>
    </div>
  )
}

