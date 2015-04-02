#This program must be run before 'fiscal_code' because it's necessary
#to populate the MySQL database with the data contained in the file town_list.csv

require 'mysql'

begin
    
    con = Mysql.new 'localhost', 'script', 'password', 'town'#script-->name of mysql user, password--> password of 'script' user, town--> database name
	list = File.open("town_list.csv").read
	list.each_line do |line|
		temp = line.split(',')
		if temp[0]==""
			puts "Nella nostra banca dati, manca il codice catastale\ndel comune di #{temp[1]}\nInseriscilo: "
			temp[0]=gets.chomp
		end
		input= "INSERT INTO list_of_towns VALUES(\"#{temp[0]}\",\"#{temp[1]}\");".delete("\n")
		con.query(input)
		puts input
	end
	
 
    
rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end

