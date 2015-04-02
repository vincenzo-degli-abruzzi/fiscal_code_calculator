# fiscal_code_calculator
Program that calculates the italian fiscal code

Before running this program it's necessary to create a MySQL database on your computer that will contain the data
for the cadastral code of Italian towns. 

Then run populator.rb to insert the data of the file town_list.csv in the MySql database.

The program uses the following data for MySql access: 
  user: script
  pass: password
  database name: town
  
Finally you can run fiscal_code.rb
