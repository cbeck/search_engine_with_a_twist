u = User.create :email => 'demo_user@netphase.com',
    :salt => '6676525af203e88945fe64ecec835be0877fad65',
    :crypted_password => '8056aa624b3503242f478a0dacbbd1d40d7ce835'
u.activate
@@demo_user = u

# login: demo_admin@netphase.com / test2
u = User.create :email => 'demo_admin@netphase.com',
      :salt => '6676525af203e88945fe64ecec835be0877fad65',
      :crypted_password => 'e8a2d61aec7998e6eceaaff681371189fe516796'
u.admin = true
u.activate
@@demo_admin = u
