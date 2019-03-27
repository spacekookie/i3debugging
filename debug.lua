#!/usr/bin/env luajit
-- This Script only runs via luajit and is lua 5.1 compliant

local ffi = require 'ffi'
local os = require 'os'

ffi.cdef [[
  int open(const char* pathname, int flags);
  int close(int fd);
  int read(int fd, void* buf, size_t count);
]]

-- Because I listened!
function listener()
  return coroutine.create(function ()
    local O_NONBLOCK = 2048
    local chunk_size = 4096
    local buffer = ffi.new('uint8_t[?]', chunk_size)
    local fd = ffi.C.open('/tmp/i3debugger', O_NONBLOCK)
  end)
end

function destroy_pipe()
  os.remove('/tmp/i3debugger')
end

local running = true

-- Let's just loop for a while actually
while running

  -- Run the xdo magic
  os.execute("bash xdo_script.sh")

  -- Set ourselves an upper limit
  alarm(2, function() running = false end)

  -- Listen for a reply
  local thing = listener().resume()
  
  
end



local nbytes = ffi.C.read(fd, buffer, chunksize)
