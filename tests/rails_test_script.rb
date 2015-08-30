require 'rubygems'
require 'watir'
require 'watir-webdriver'
require 'mysql2'

puts "---------------Ruby Automation Test Script -- Start ------------------------------"

browser = Watir::Browser.new
puts "** New Browser object created **"

client = Mysql2::Client.new(host: 'localhost', database: 'hello_development', username: 'root', password: 'password')
puts "** Created MySQL DB object **"
delete = "delete from users;"
client.query(delete)
puts  "** Deleted old user records from DB **"

#step 1 : Open http://localhost:3000/users in firefox
browser.goto 'http://localhost:3000/users'
puts "Step-1: Open 'http://localhost:3000/users' "

#step 2:Check if"New User" link appears
if browser.text.include? "New User"
	puts "Step-2: New User link appear"
#step 3: Check if New User page is loaded 
	browser.link(:text => 'New User').click
	puts "Step-3: Click 'New user' link"
else 
	puts "Step-2: Error: unable to find 'New user' link"
end

#step 4: Check if fields first name and last name appears
if browser.text_field(:id => 'user_first_name').exists? and browser.text_field(:id => 'user_last_name').exists?
	puts "Step-4: Fields first name and last name  appear"
#step 5: Enter "Thor" in firstname field 
	browser.text_field(:id => 'user_first_name').set 'Thor'
	puts "Step-5: Enter first_name: Thor"
#step 6:Enter "Avenger" in lastname field 
	browser.text_field(:id => 'user_last_name').set 'Avenger'
	puts "Step-6: Enter last_name: Avenger"
else
	puts "Step-4 : Error: unable to find fields" 
end

#step 7: Click button Create User
browser.button(:name => 'commit').click
if browser.text.include? "User was successfully created"
	puts "Step-7: User is successfully created"
else
	puts "Step-7: Error: User is not created"
end

#step 8: Check if first name and last name values are the same as step 5 and 6
if browser.text.include? 'First name: Thor' and browser.text.include? 'Last name: Avenger'
	puts "Step-8: first name:Thor and last name:Avenger values are same as entered"
else 
	puts "Step-8: Error:Unable to validate entered values"
end	

 #Step9: Validate database entry for user "Thor" in Users table in Hello_development 
sql = "select first_name,last_name from users where first_name='Thor';"
result = client.query(sql)
result.each do |row|
	if row['first_name'] == 'Thor' and row['last_name'] == 'Avenger'
		puts  "Step-9: SQL query result is #{row['first_name']} #{row['last_name']} "
	else
		 puts "Step-9: Error: SQL query result not as expected"
	end
end

#Step-10 : Close Browser

browser.close
puts "Step-10: Close Browser"
puts "----------------Ruby Automation Test Script Completed-------------------"





