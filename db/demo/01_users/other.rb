
while (User.count < 40) do
  begin
    generate_user
  rescue
    puts "generate user failed: #{$!}"
    retry
  end
end