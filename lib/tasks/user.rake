namespace :ubexact do
  namespace :user do
    desc "Load demo user data"
    task :load => :environment do

      def generate_phone
        format '%d%09d', rand(8)+2, rand(10000000000)
      end
    
      def generate_expiration
        rand(365).days.from_now
      end
    
      def first_name
        names = %w(Jim John Mike Joe Jill James Joan Cindy Blair Paige Chase Tyler Vaughn Chris Sam Jeff Eric Mary Marylin Beth Amy Michele Pam Josh Alan George Bruce Ashley Walter Wilbur Barry Darby Kent Kelsey Kyle Lucy Merton Jeannine Megan Greg Jay Darrel Tim Foster Mark)
        names[rand(names.size)]
      end
    
      def last_name
        names = %w(Jones Johnson Ackers Benjamin Aldridge Arthur Ashford Clapp Conway Denton Fry Falkland Goodrich Hansel Heaton Henry Hogan Hurst Landon Kerr Morgan Ogden Osborn Paddock Randal Reynolds Rowley Roberts Sellick Stapleton Weller Artois Arundel Astor Barrow Barstow Beckett Bedford Bradford Breck Brighton Buckbee Cadwell Burton Dalton Davenport Dunbar Hartwell Hathaway Horton Irving Kinghorn Kirkpatrick Lancaster Lacy Lewes Milton Paxton Pollock Poole Sanders Scroggs Spalding Swift Thurston)
        names[rand(names.size)]
      end
    
      def generate_person
        Person.new :first_name => first_name, :last_name => last_name
      end
    
      def generate_user
        person = generate_person
        login = "#{person.first_name[0..0]}#{person.last_name[0..7]}"
        u = User.create(:email => "#{login}_test@netphase.com",
          :salt => '6676525af203e88945fe64ecec835be0877fad65',
          :crypted_password => '8056aa624b3503242f478a0dacbbd1d40d7ce835', # test
          :person => person)
        u.activate
      end    
    
      def load_demo_data
        ActionMailer::Base.delivery_method = :test
      
        Dir["#{RAILS_ROOT}/db/demo/**/*.rb"].sort.each do |demo_data|
          puts "Loading #{demo_data}"
          load(demo_data)
        end
      end
  
      load_demo_data
  
    end
  end
end