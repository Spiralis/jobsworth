require 'machinist/active_record'
require 'faker'

Company.blueprint do
  name      { Faker::Name.name }
  subdomain { Faker::Internet.domain_name }
end

Customer.blueprint do
  company 
  name { Faker::Name.name }
end

OrganizationalUnit.blueprint do
  customer
  name { Faker::Name.name }
end

EmailDelivery.blueprint do
end

User.blueprint do
  company
  customer
  name          { Faker::Name.name }
  password      { Faker::Lorem.sentence(1) }
  email         { Faker::Internet.email }
  time_zone     { "Australia/Sydney" }
  date_format   { "%d/%m/%Y" }
  time_format   { "%H:%M" }
  username      { "user_#{serial_number}" }
end

Project.blueprint do
  name      { Faker::Name.name }
  customer
  company
end

AbstractTask.blueprint do
  name        { Faker::Name.name }
  description { Faker::Lorem.paragraph }
  company 
  project
end

Task.blueprint do
  company
  project
  users(1)
  weight  { 1 }
end

Milestone.blueprint do
  name { Faker::Name.name }
  company
  project
end

ResourceType.blueprint do
  name { Faker::Name.name }
  company
end

Resource.blueprint do
  name { Faker::Name.name }
  company
  customer
  resource_type
end

TaskFilter.blueprint do
  name { Faker::Name.name }
  user
  company { user.company }
end

TaskFilterUser.blueprint do
end

TaskPropertyValue.blueprint do
end

Tag.blueprint do
  company
  name { Faker::Name.name }
end

WorkLog.blueprint do
  prebuild_co      = Company.make!
  prebuild_cus     = Customer.make!(:company => prebuild_co)
  prebuild_project = Project.make!(:customer => prebuild_cus, :company => prebuild_co)
  prebuild_user    = User.make!(:company => prebuild_co, :projects => [prebuild_project])

  company  { prebuild_co }
  customer { prebuild_cus }
  body     { Faker::Lorem.paragraph }
  project  { prebuild_project }
  user     { prebuild_user }
  task     { Task.make( :project => prebuild_project,
                        :company => prebuild_co, 
                        :users=> [prebuild_user]) }
  started_at { Time.now }
end

Sheet.blueprint do
  task
  project
  user
end

TimeRange.blueprint do
  name { Faker::Name.name }
end

Trigger.blueprint do
  company
  event_id { 1 }
end

Page.blueprint do
  name { Faker::Name.name }
  company
  notable { Project.make!(:company => company) }
end

ProjectFile.blueprint do
  prebuild_co  = Company.make!
  prebuild_pro = Project.make!(:company  => prebuild_co)
  prebuild_cus = Customer.make!(:projects => [prebuild_pro])

  company  { prebuild_co }
  project  { prebuild_pro }
  customer { prebuild_cus }
  task     { Task.make!(:project => prebuild_pro) }
  user     { User.make!(:company => prebuild_co, :customer => prebuild_cus) }
  file_file_size { 999 }
  uri      { "http://example.com" }
end

WikiPage.blueprint do
  name { Faker::Name.name }
  company
end

ScmProject.blueprint do
  company
  scm_type  { ['git', 'svn', 'cvs', 'mercurial', 'bazar'][rand(4)]}
  location  { Faker::Internet.domain_name }
end

ScmChangeset.blueprint do
  scm_project
  message     { Faker::Lorem.paragraph }
  author      { Faker::Name.name }
  commit_date { Time.now - 3.days }
  changeset_num { rand(1000000) }
  task
end

Widget.blueprint do
  order_by  { "priority" }
  mine      { true }
  collapsed { false }
end