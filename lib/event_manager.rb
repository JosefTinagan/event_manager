require "csv"
require "sunlight/congress"
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zipcode)
	Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
	Dir.mkdir("output") unless Dir.exists? "output"

	filename = "output/thanks_#{id}.html"

	File.open(filename,"w") do |file|
		file.puts form_letter
	end
end

def clean_phonenumber(phone_number)
	current_phonenum = phone_number.to_s.gsub(/[()-\.]|[\s]/,'')
	current_phone_num_length = current_phonenum.length

	if current_phone_num_length < 10
		"BAD NUMBER"
	elsif current_phone_num_length == 11
		if current_phonenum[0] == "1"
			current_phonenum[1..-1]
		else 
			"BAD NUMBER"
		end
	elsif current_phone_num_length > 11
		"BAD NUMBER"
	elsif current_phone_num_length == 10
		current_phonenum
	else
		"BAD NUMBER"
	end
end

def get_hour(date)
	date_object = DateTime.strptime(date,'%y/%d/%m %H:%M')
	date_object.hour
end

puts "EventManager Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter
arr_hours = []

contents.each do |row|
	#id = row[0]
	#name = row[:first_name]
	#zipcode = clean_zipcode(row[:zipcode])
	#legislators = legislators_by_zipcode(zipcode)
	#phone_number = clean_phonenumber(row[:homephone])
	hour = get_hour(row[:regdate])
	arr_hours.push(hour)
	#form_letter = erb_template.result(binding)

	#save_thank_you_letters(id,form_letter)
	#puts phone_number
end

best_hour = arr_hours.max_by{|x| arr_hours.count(x) }
puts "People register the most when its #{best_hour} o'clock"
=begin
#contents = File.read "event_attendees.csv"
#puts contents

lines = File.readlines "event_attendees.csv"
lines.each_with_index do |line,index|
	next if index == 0
	columns = line.split(",")
	name = columns[2]
	puts name	
end
=end
