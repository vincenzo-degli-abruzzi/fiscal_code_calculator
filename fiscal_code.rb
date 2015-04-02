#2015-03  Federico Cioschi & Giovanni Di Donato
#<federicocioschi@gmail.com>
#programma per calcolare codice fiscale


require 'mysql'
control=true
months_list = ['gennaio','febbraio','marzo','aprile','maggio','giugno','luglio','agosto','settembre','ottobre','novembre','dicembre']
months_letters = ['a','b','c','d','e','h','l','m','p','r','s','t']
gender_list = ['maschio','femmina']
code = ""

while control==true do
	puts "Qual e' il tuo nome?"
	name = gets.chomp.delete(" ")
	if name.empty?
		next
	end
	control=false
end

control=true
while control==true do
	puts "E il tuo cognome?"
	last_name = gets.chomp.delete(" ")
	if last_name.empty?
		next
	end
	control=false
end

control=true
while control==true do
	puts "Sei maschio o femmina?"
	gender = gets.chomp
	if !gender_list.include?(gender.downcase)
		next
	end
	control=false
end

control=true
while control==true do
	puts "In che anno sei nato?"
	year = gets.to_i
	if !year.integer? || (year.to_s.size!=4 && year.to_s.size!=2)
		next
	end
	year= year.to_s
	if year.size==2 
		year = '19' + year
	end
	control=false
end

control=true
while control==true do
	puts "Nel mese di:"
	month = gets.chomp
	if !months_list.include?(month.downcase)
		next
	end
	control=false
end


control=true
while control==true do
	puts "Giorno:"
	day = gets.to_i 
	if !day.integer? || day<1 || day>31
		next
	end
	if gender=="femmina"
		day+=40
	elsif day<10 #if there's a boy whit a 'one digit' day of birth
		day = '0'+day.to_s
	end
	day=day.to_s
	control=false
end

last_name_cons = last_name.scan(/[^aeiou]/i)
last_name_vow = last_name.scan(/[aeiou]/i)

n_cons=0
n_vow=0
i=0
while  i < 3 do
	if last_name_cons[n_cons]!=nil
		code += last_name_cons[n_cons]
		n_cons+=1
	elsif last_name_vow[n_vow]!=nil
		code += last_name_vow[n_vow]
		n_vow+=1
	else
		code += 'x'
	end
	
	i+=1
end


name_cons = name.scan(/[^aeiou]/i)
name_vow = name.scan(/[aeiou]/i)

n_cons=0
n_vow=0
i=0
while  i < 3 do
	if name_cons.size>=4#if the name has 4 or more consonants take the first,the third and the fourth consonants
		code += name_cons[n_cons]
		if n_cons==0  
			n_cons+=2
		else
			n_cons+=1
		end	
	else# if the name has 3 or less consonants
		if name_cons[n_cons]!=nil
			code += name_cons[n_cons]
			n_cons+=1
		elsif name_vow[n_vow]!=nil
			code += name_vow[n_vow]
			n_vow+=1
		else
			code += 'x' 
		end
	end
	i+=1
end

control=true
while control==true do
	puts"Comune di nascita?"
	place=gets.chomp
	begin
		
		con = Mysql.new 'localhost', 'script', 'password', 'town' #script-->name of mysql user, password--> password of 'script' user, town--> database name
		list= con.query("SELECT town_code FROM list_of_towns WHERE town_name=\"#{place}\"")
		catastale = list.fetch_row
		if catastale==nil
			next
		else
			control=false
		end
		
		rescue Mysql::Error => e
			puts e.errno
			puts e.error
			
		ensure
			con.close if con
	
	end
end


code += year[2]+year[3] + months_letters[months_list.index(month)] + day + catastale[0]

puts "\nIl tuo codice fiscale e' " +code.upcase

