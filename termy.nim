import os, strutils, illwill
import std/exitprocs
export illwill.Key
from terminal import resetAttributes
var tb = newTerminalBuffer(terminalWidth(), terminalHeight())
proc exitProc() {.noconv.} =
    illwillDeinit()
    showCursor()
    quit(0)
proc confirm(message: string): Key =
    while true:
        var y = terminalHeight() - 1
        var key = getKey()
        tb.write(0, y, fgBlue, message)
        case key
        of Key.None: discard
        else: return key
        tb.display()
        sleep(10)
proc input(message: string) =
    var text = ""
    var y = terminalHeight() - 1
    while true:
        var key = getKey()
        var buf = message & " " & text
        tb.write(buf.len, y, bgWhite, " ", resetStyle)
        tb.write(0, y, fgBlue, buf)
        case key
        of Key.None: discard
        of Key.Escape: return
        of Key.Enter: return
        of Key.Backspace:
            if text.len > 0:
                text.delete(text.len-1, text.len-1)
                tb.write(buf.len, y, " ")
        else: text &= key.char
        tb.display()
        sleep(10)
proc edit() =
    var editor = getEnv("EDITOR", "/usr/bin/vim")
    resetAttributes()
    showCursor()
    discard execShellCmd(editor)
    hideCursor()
type Item* = ref object of RootObj
    text*: string
    status*: string
var Items = newSeq[Item]()
var selected = 0
proc show*(list: seq[Item]) =
    Items = list
    selected = 0
method command(c: Item, k: Key) = discard
proc start*() =
    illwillInit(fullscreen=true)
    setControlCHook(exitProc)
    addExitProc(resetAttributes)
    hideCursor()
    while true:
        tb.clear()
        tb.resetAttributes()
        for i, it in Items:
            if selected == i:
                tb.write(0, i, fgBlack, bgBlue, it.text, resetStyle)
            else: tb.write(0, i, fgBlue, it.text)
        var key = getKey()
        case key
        of Key.None: discard
        of Key.Escape, Key.Q: exitProc()
        of Key.ShiftG: selected = Items.len - 1
        of Key.G: selected = 0
        of Key.J: selected = min(Items.len - 1, selected + 1)
        of Key.K: selected = max(0, selected - 1)
        of Key.Enter: Items[selected].command(key)
        of Key.N: input("what would you like?")
        of Key.E: edit()
        else: discard
        if Items.len > 0:
            tb.write(0, terminalHeight() - 1, fgBlue, Items[selected].status)
        tb.display()
        sleep(20)
