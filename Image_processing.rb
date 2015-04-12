require "exifr"
require "date" 
require "RMagick"
require "csv"

def set_exif_date(exifdate)
	begin
		return exifdate.strftime("%Y%m%d%H%M")
	rescue
		return nil
	end
end

def set_exif_int(exifint)
	begin
		return Integer(exifint).to_s
	rescue
		return 0
	end
end

savetarget = ARGV[0]
csv_data = Array.new()

#processing imagefiles
File.open('targetPaths.txt', "r:utf-8") do |f|
	while line = f.gets
		#image processing(rmagick)
		original_img = Magick::Image.read(line.chomp).first
		image = original_img.resize_to_fit(960, 960)
		resized_img_path = savetarget + File.basename(line.chomp)
		image.write(resized_img_path){
			self.quality = 80
		}

		#get Exif info and make csvdata
		pic = EXIFR::JPEG.new(line.chomp) 

		csv_line = line.chomp
		csv_line << ','
		csv_line << resized_img_path
		csv_line << ','

		if pic.model.empty?
			csv_line << "unknown camera"
		else
			csv_line << pic.model
		end

		csv_line << ','
		csv_line << set_exif_date(pic.date_time)
		csv_line << ','
		csv_line << set_exif_date(pic.date_time_original)
		csv_line << ','
		csv_line << set_exif_int(pic.pixel_x_dimension)
		csv_line << ','
		csv_line << set_exif_int(pic.pixel_y_dimension)
		csv_data.push(csv_line)
	end
end

#save csvfile
today = Date.today
csv_fname = today.strftime("%Y%m%d").to_s + ".csv"
CSV.open(csv_fname, "wb")  do |csv|
	csv_data.each do |csv_line|
		csv << CSV.parse_line(csv_line)
	end
end