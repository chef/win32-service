# Print all directories in the Ruby load path
$:.each do |lib|
  puts lib
end

# Check if a specific directory is in the load path
found = false
$:.each do |lib|
  if lib.include?("win32")
    found = true
    puts "Found win32 directory: #{lib}"
  end
end

puts "No win32 directories found in load path" unless found
