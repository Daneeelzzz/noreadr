"use client"

import Link from "next/link"
import { useState } from "react"
import { ArrowLeft, Bookmark, ChevronLeft, ChevronRight, Menu, Moon, Settings, Sun } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Slider } from "@/components/ui/slider"
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet"
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu"

export default function ChapterPage({
  params,
}: {
  params: { id: string; chapterId: string }
}) {
  const [isBookmarked, setIsBookmarked] = useState(false)
  const [fontSize, setFontSize] = useState(16)
  const [isDarkMode, setIsDarkMode] = useState(false)

  // Mock chapter data
  const chapterTitle = `Chapter ${params.chapterId}: ${
    params.chapterId === "1"
      ? "The Beginning"
      : params.chapterId === "2"
        ? "Dark Shadows"
        : params.chapterId === "3"
          ? "Unexpected Allies"
          : params.chapterId === "4"
            ? "The Journey Begins"
            : params.chapterId === "5"
              ? "Secrets Revealed"
              : `Chapter Title ${params.chapterId}`
  }`

  return (
    <div className={`flex flex-col h-screen ${isDarkMode ? "bg-gray-900 text-gray-100" : "bg-white"}`}>
      {/* Header */}
      <header className={`border-b p-4 flex items-center justify-between ${isDarkMode ? "border-gray-700" : ""}`}>
        <Link href={`/novel/${params.id}`}>
          <ArrowLeft className="h-5 w-5" />
        </Link>
        <h1 className="text-sm font-medium">{chapterTitle}</h1>
        <div className="flex gap-3">
          <button onClick={() => setIsBookmarked(!isBookmarked)}>
            <Bookmark className={`h-5 w-5 ${isBookmarked ? "fill-current text-primary" : ""}`} />
          </button>
          <Sheet>
            <SheetTrigger asChild>
              <button>
                <Settings className="h-5 w-5" />
              </button>
            </SheetTrigger>
            <SheetContent>
              <SheetHeader>
                <SheetTitle>Reading Settings</SheetTitle>
              </SheetHeader>
              <div className="py-4">
                <div className="mb-6">
                  <div className="flex justify-between items-center mb-2">
                    <label className="text-sm font-medium">Font Size</label>
                    <span className="text-sm">{fontSize}px</span>
                  </div>
                  <Slider
                    value={[fontSize]}
                    min={12}
                    max={24}
                    step={1}
                    onValueChange={(value) => setFontSize(value[0])}
                  />
                </div>

                <div className="flex justify-between items-center py-2">
                  <label className="text-sm font-medium">Dark Mode</label>
                  <Button variant="outline" size="icon" onClick={() => setIsDarkMode(!isDarkMode)}>
                    {isDarkMode ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
                  </Button>
                </div>

                <div className="flex justify-between items-center py-2">
                  <label className="text-sm font-medium">Download Chapter</label>
                  <Button variant="outline" size="sm">
                    Download
                  </Button>
                </div>
              </div>
            </SheetContent>
          </Sheet>
        </div>
      </header>

      {/* Main Content */}
      <main className={`flex-1 overflow-auto p-4 ${isDarkMode ? "bg-gray-900 text-gray-100" : ""}`}>
        <h2 className="text-xl font-semibold mb-6 text-center">{chapterTitle}</h2>

        <div className="space-y-4" style={{ fontSize: `${fontSize}px` }}>
          <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et
            dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex
            ea commodo consequat.
          </p>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
            Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est
            laborum.
          </p>
          <p>
            Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem
            aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
          </p>
          <p>
            Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni
            dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor
            sit amet, consectetur, adipisci velit.
          </p>
          <p>
            Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex
            ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil
            molestiae consequatur.
          </p>
        </div>

        {/* Progress Bar */}
        <div className="mt-8 mb-4">
          <div className="w-full bg-gray-200 h-1 rounded-full">
            <div className="bg-primary h-1 rounded-full w-[35%]"></div>
          </div>
          <div className="flex justify-between mt-1">
            <span className="text-xs text-gray-500">35% of chapter</span>
            <span className="text-xs text-gray-500">Chapter {params.chapterId} of 32</span>
          </div>
        </div>
      </main>

      {/* Chapter Navigation */}
      <div className={`border-t p-4 flex justify-between ${isDarkMode ? "border-gray-700" : ""}`}>
        <Link href={`/novel/${params.id}/chapter/${Math.max(1, Number.parseInt(params.chapterId) - 1)}`}>
          <Button variant="outline" className="flex items-center">
            <ChevronLeft className="h-4 w-4 mr-1" />
            Previous
          </Button>
        </Link>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="outline" size="icon">
              <Menu className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="center">
            <DropdownMenuItem>Chapter 1</DropdownMenuItem>
            <DropdownMenuItem>Chapter 2</DropdownMenuItem>
            <DropdownMenuItem>Chapter 3</DropdownMenuItem>
            <DropdownMenuItem>Chapter 4</DropdownMenuItem>
            <DropdownMenuItem>Chapter 5</DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
        <Link href={`/novel/${params.id}/chapter/${Number.parseInt(params.chapterId) + 1}`}>
          <Button variant="outline" className="flex items-center">
            Next
            <ChevronRight className="h-4 w-4 ml-1" />
          </Button>
        </Link>
      </div>
    </div>
  )
}

