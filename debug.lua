#!/usr/bin/env luajit

local ffi = require 'ffi'
local io = require 'io'
local os = require 'os'

ffi.cdef [[
  int open(const char* pathname, int flags);
  int close(int fd);
  int read(int fd, void* buf, size_t count);
]]

function do_key(key)
  os.execute("xdotool key " .. key)
end

function type(str)
  os.execute("xdotool type " .. str)
end

function sleep(val)
  os.execute("sleep " .. val)
end

-- Because I listened!
function listener()
  return coroutine.wrap(function()
    local chunk_size = 1024
    local buffer = ffi.new('uint8_t[?]', chunk_size)
    local fd = ffi.C.open('/tmp/i3debugger', 0) -- O_RDONLY

    print("Yielding coroutine to start rust server")
    coroutine.yield()

    print("Waiting for read")
    print(ffi.C.read(fd, buffer, chunksize))
  end)
end

function destroy_pipe()
  os.remove('/tmp/i3debugger')
end

-- local reader = listener()
function xdotool(ctr)
  do_key("super+s")
  sleep(1)
  type("test")
  do_key("Return")
  do_key("super+d")
  sleep(1)
  type("firefox")
  do_key("Return")
  sleep(5)
  do_key("Ctrl+t")
  sleep(1)
  type("localhost:1312/All Computers Are Bricks/")
  do_key("Return")
end

function prepare_view()
  do_key("super+s")
  sleep(2)
  type("i3")
  do_key("Return")
end

local try_read = coroutine.wrap(
  function()
    local buf = ffi.new('char[?]', 64)
    local fd = ffi.C.open('/tmp/i3debugger', 2048)
    coroutine.yield()

    while true do
      ffi.C.read(fd, buf, 64)
      coroutine.yield(ffi.string(buf))
    end
  end)

-- Setup reader
try_read()

-- Try it maybe 10 times
try_ctr = 0
failed = false

-- Open the server and give it time to start
local server = io.popen("./server")
os.execute("sleep 1")

prepare_view()

while true do
  -- Execute xdomagic
  xdotool(ctr)

  -- Juuuust to make sure!
  os.execute("sleep 1")

  -- Read a reply
  local resp = try_read()
  if resp == "" then
    print("REPRODUCED ERROR!")
    failed = true
    break
  else
    ctr = ctr + 1
  end
end

-- Clean up for the next run
destroy_pipe()
os.execute("killall firefox")

prepare_view()

-- Only report error if we actually failed!
if failed then
  os.exit(2)
end
