User.find(:all).each do |u|
  u.destroy
end

Person.find(:all).each do |p|
  p.destroy
end
