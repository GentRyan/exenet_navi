require 'socket'      # Sockets are in standard library

def print_area(area)
	area.each { |line|
	puts(line)
}
end
def print_users(users)
	print("Navis jacked in: ")
	users.each {|user|
		print(user," ")
	}
	print("\n")
end

def get_area(s)
	area = Array.new()
	s.puts("a")
	x = 0
	meh = ""
	while meh != "END"
		meh = s.gets.chomp
		area[x] = meh unless meh == "END"
		x = x + 1 unless meh == "END"
	end
	return area
end
def get_users(s)
		users = Array.new
		s.puts("u")
		while line = s.gets.chomp and line != "END"  # Read lines from the socket
			users.push(line)
		end
	return users
end

def bbs_mode(s)
	s.puts("bbs")
	until ((meg = s.gets.chomp) == "hs")
		puts(meg)
	end

	puts("----BBS_Mode----")
	while true
		choice = gets.chomp
		break if choice == "q"

		if choice == "p"
		then
			s.puts(choice)
			puts("Enter message title:")
			title = gets()
			s.puts(title)
			puts("Enter message:")
			message = gets()
			s.puts(message)
		else
			s.puts(choice)
			while line = s.gets and line != "END\n"  # Read lines from the socket
				puts(line)
			end
		end
		puts()
		puts("----BBS_Mode----")
	end
	s.puts("q")        # Close the socket when done
end


def main()

	puts("Enter IP Address to jack in to")
	host = gets().chomp
	host = '173.59.51.202' if host == ""
	port = 2000
	navi = File.new("navi","r")
	name = navi.readlines()
	navi.close
	s = TCPSocket.open(host, port)

	if s.gets.chomp == "v"
	then
		s.puts(name)
	end
	if s.gets.chomp == "hs"
	then
		area = get_area(s)
		users = get_users(s)
		puts "\e[H\e[2J"
		puts(host)
		puts("---------------------------")
		print_area(area)
		print_users(users)

		while true
			choice = gets.chomp
			if choice == "bbs"
			then
				bbs_mode(s)
			end
			if choice == "u"
			then
				print_users(get_users(s))
			end
			if choice == "a"
			then
				print_area(get_area(s))
			end
			break if choice == "j"
		end

	end
	s.puts("j")
	s.close()
end

main()
