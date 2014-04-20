host = ENV["REDIS_PORT_6379_TCP_ADDR"]
port = ENV["REDIS_PORT_6379_TCP_PORT"].to_i
db = Redis.new host, port

# Note: a value must be String
# > db.set "key1", 100
# (mirb):1: expected String (TypeError)

db.set "key1", "100"

value = db.get "key1"

r = Nginx::Request.new
r.content_type = "text/html"
Nginx.rputs "host = #{host}, port = #{port}, value is #{value}\n"
