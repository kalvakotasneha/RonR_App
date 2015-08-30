require 'mysql2'

client = Mysql2::Client.new(host: 'localhost', database: 'hello_development', username: 'root', password: 'password')

#sql = 'select NOW() as timestamp'
sql = "select first_name,last_name from users where first_name='Thor';"
result = client.query(sql)
result.each do |row|
  print row['first_name'] + " " + row['last_name']
  print   print "\n"
end