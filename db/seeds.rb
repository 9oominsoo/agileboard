TITLES = ["Ruby On Rails","React", "Android", "IOS"]
PIMAGES=['test1.jpg', 'test2.jpg', 'test3.jpg', 'test4.jpg', 'test5.jpg','test6.jpg']
SIMAGES=['test1.jpg', 'test2.jpg', 'test3.jpg', 'test4.jpg', 'test5.jpg', 'app.png', 'rails1.png','android1.jpg','html.jpg','ios1.jpg','ios2.jpg','ios3.jpg','rails1.png','react2.jpg','web.jpg']
ROOT= "/public/image/seedimage/"
STATUS= [:to_do,:in_progress,:complete ,:feedback, :end]
FUNC_NAME = ["로그인 및 회원가입", "User", "active admin","로그인 및 회원가입 UI", "Post 기본 CRUD","Post 검색 기능", "Post UI","Project CRUD", "Project 검색 기능", "Project UI", "Function CRUD", "Function 그래프", "Function 검색 및 정렬", "Function UI", "배포"]
# AdminUser.create!(email: 'admin@test.com', password: '123456', password_confirmation: '123456') if Rails.env.development?
def get_user
  User.order("RANDOM()").limit(1).first
end 

def get_users
  User.order("RANDOM()").limit(3)
end

def get_project_broken_sunset
  #Project.order("RANDOM()").limit(1).first
  Project.find_by(name: "Broken Sunset")
end

def get_project
  Project.order("RANDOM()").limit(1).first
end

def destroy_all_data
  Conversation.destroy_all
  puts "Conversation 삭제"

  Post.destroy_all
  puts "Post 삭제"

  User.destroy_all
  puts "User 삭제"
  
  Function.destroy_all
  puts "Function 삭제"

  Project.destroy_all
  puts "Project 삭제"
end

def generate_project title = "프로젝트"
  
  TITLES.each do |project| 
    image_field = File.open(("#{Rails.root}"+ROOT+SIMAGES.shuffle.first))
    Project.create(name: project + " " + title, description: Faker::Lorem.sentence(word_count: 100), image: image_field, start_at: Date.today, end_at: Date.today + 10.days, updated_at: Date.today + Random.rand(10).days)
    puts "프로젝트 생성"
  end
end
   
def generate_users 
  User.developer.create(email: 'test@test.com', password: 'password',name:"허 윤행", phone: "010-8812-4574")
  5.times do
    user_info = {
      email: Faker::Internet.email,
      password: "password",
      name: "#{Faker::Name.name}",
      phone: "010-1234-5678",
    }

    User.customer.create(user_info)
    puts "고객 생성"
  end

  5.times do
    user_info = {
      email: Faker::Internet.email,
      password: "password",
      name: "#{Faker::Name.name}",
      phone: "010-1234-5678",
    }

    User.developer.create(user_info)
    puts "개발자 생성"
  end
end

def generate_userprojects
  15.times do
    get_user.user_projects.create(project: get_project)
  end
  puts "프로젝트에 유저 추가"
end
def generate_userprojects_broken_sunset
  5.times do 
    get_user.user_projects.create(project: get_project_broken_sunset)
  end
end
def generate_posts
  20.times do 
    image_field = File.open(("#{Rails.root}"+ROOT+SIMAGES.shuffle.first))
    post = Post.create( user: get_user, title: Faker::Computer.platform + " 게시글", body: Faker::Lorem.sentence(word_count: 100), project: get_project, image: image_field )
    puts "게시글 생성"
  end
end

def generate_posts_broken_sunset
  5.times do 
    image_field = File.open(("#{Rails.root}"+ROOT+PIMAGES.shuffle.first))
    post = Post.create( user: get_user, title: Faker::Computer.platform + " 게시글", body: Faker::Lorem.sentence(word_count: 100), project: get_project_broken_sunset, image: image_field )
    puts "broken sunset 게시글 생성"
  end
end

def generate_project_broken_sunset
  image_field = File.open(("#{Rails.root}"+ROOT+"sunset.jpg"))
  Project.create(name: "Broken Sunset", description: Faker::Lorem.sentence(word_count: 100), image: image_field, start_at: Date.today - 60.days, end_at: Date.today + 30.days, updated_at: Date.today)
  puts "broken sunset 프로젝트 생성"
end

def generate_functions_broken_sunset  
  FUNC_NAME.each_with_index do |name, index|
    date = Date.today - (FUNC_NAME.count - index)*2.days
    state_index = STATUS.count - index/3 - 1
    state_index = state_index + 1 if index % 3 == 0 && state_index != 4 && state_index != 0
    function = Function.new(title: name + " 구현하기" , description: Faker::Hacker.say_something_smart, start_at: date, end_at: date + 15.days , project: get_project_broken_sunset, user_list: [], updated_at: date, aasm_state: STATUS[state_index], to_do_updated_at: date, in_progress_updated_at: date+2.days, complete_updated_at: date+4.days, feedback_updated_at: date + 6.days,end_updated_at: date+10.days)
    function.user_list.add(get_users.ids)
    function.save
  end
 puts "broken sunset function 생성"
end

def generate_functions
  20.times do
    function = Function.new(title: Faker::Hacker.adjective + " 구현하기" ,description: Faker::Hacker.say_something_smart, start_at: Date.today, end_at: Date.today + 20.days , project: get_project, user_list: [], updated_at: Date.today + Random.rand(10).days, aasm_state: STATUS.shuffle.first)
    function.user_list.add(get_users.ids)
    function.save
  end
  puts "기능 생성"
end

destroy_all_data
generate_project
generate_users
generate_userprojects
generate_posts
generate_functions
generate_project_broken_sunset
generate_userprojects_broken_sunset
generate_posts_broken_sunset
generate_functions_broken_sunset
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?