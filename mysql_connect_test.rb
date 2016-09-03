require 'pp'
require 'bundler'
Bundler.require

HOST = "chatbot-hackathon.ckudyu9ubkf5.ap-northeast-1.rds.amazonaws.com"
USER = "guest"
PASSWORD = "retty"
DATABASE = "hackathon"
PORT = 3306

client = Mysql2::Client.new(
  host: HOST,
  user: USER,
  password: PASSWORD,
  database: DATABASE,
)

results = client.query("SELECT * FROM hackathon_restaurant LIMIT 10")

pp results

results.each do |row|
	pp row
	# puts row["restaurant_id"]
	# puts row["restaurant_name"]
end

