def bbs_mode(client, navi_name)
	client_number = 1
	puts("BBS being read")
	log = File.new("bbslog","a")
  	log.puts((client_number.to_s) + " " + "Opened Connection")
	client.puts("hs")
	puts("Hand shake sent")
	while true
		num = client.gets.chomp()
		break if num == "q"
		file = File.new("news", "r")
		news = file.readlines()
		file.close
		if (num) == "d"
		then
			puts("Sending news")
			x = 1
			i = 1
		
			news.each do |line|
				if i % 2 != 0 and line != "\n"
				then
					client.puts(x.to_s + " " + line)
					x = x + 1
				end
					i = i + 1
			end
			client.puts("END")
		end
	
		if num == "p"
			log.puts("Getting new post")
			title = client.gets
			message = client.gets.chomp
			message = (message + " -" + navi_name + "\n")
			news.insert(0,title)
			news.insert(1,message)
			log.puts("Added new post")
			if message != ""
			then
				file = File.new("news", "w")
				news.each { |line|
					file.puts(line)
				} 
				file.close()
			end
		end
	
	
		if num.to_i != 0
			then
			news.insert(0,"")
			news.insert(1,"")		
			log.puts("Sending line!")
			num = num.to_i
			line = news[num * 2]
			client.puts(line)
			line = news[num * 2 + 1]
			client.puts(line)
			log.puts("Sent line!")
			news.delete_at(0)
			news.delete_at(0)
			client.puts("END")
		end
	end
	client_number = client_number + 1    
end

require 'socket'                # Get sockets from stdlib

server = TCPServer.open(2000)   # Socket to listen on port 2000
active_users = Array.new
loop {                          # Servers run forever
  Thread.start(server.accept) do |client|
		puts("Connection accepted")
		client.puts("v")
		navi_name = client.gets.chomp
		active_users.push(navi_name)
		puts(navi_name + " has jacked in")
		client.puts("hs")
		area_file = File.new("area","r")
		area = area_file.readlines()
		area_file.close
		
		while true
			cAction = client.gets.chomp()
			if cAction == "a"
			then
				puts("Area file being read")
				area.each { |line|
					client.puts(line)
				}
				client.puts("END")
			end
			if cAction == "u"
				puts("User list being read")
				active_users.each { |user|
					client.puts(user)
				}
				client.puts("END")
				puts("User list ended")
			end
			if cAction == "bbs"
			then
				bbs_mode(client, navi_name)
			end
			break if cAction == "j"
		end
		active_users.delete(navi_name)
  	end
}

