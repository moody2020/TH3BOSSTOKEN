local Redis = (loadfile "./libs/lua-redis.lua")()
local FakeRedis = (loadfile "./libs/fakeredis.lua")()

local params = {
  host = '127.0.0.1',
  port = 6379,
}

-- Overwrite HGETALL
Redis.commands.hgetall = Redis.command('hgetall', {
  response = function(reply, command, ...)
    local new_reply = { }
    for i = 1, #reply, 2 do new_reply[reply[i]] = reply[i + 1] end
    return new_reply
  end
})

local redis = nil

-- Won't launch an error if fails
local okxw = pcall(function()
  redis = Redis.connect(params)
end)
notredis=false
if not okxw then
local fake_func = function()
  notredis =true
end
  fake_func()
  fake = FakeRedis.new()

 -- print('\27[31mRedis addr: '..params.host..'\27[39m')
 -- print('\27[31mRedis port: '..params.port..'\27[39m')

  redis = setmetatable({fakeredis=true}, {
  __index = function(a, b)
    if b ~= 'data' and fake[b] then
      fake_func(b)
    end
    return fake[b] or fake_func
  end })

end

return redis
