# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

p1 = Post.create(author: "Igor", title: "node js", body: "nemam ulohu")
p2 = Post.create(author: "Matus", title: "node js", body: "node js developer strv")
p3 = Post.create(author: "Miso", title: "java", body: "java for life")
p4 = Post.create(author: "Peto", title: "sisarp", body: "sisarp for life")

t1 = Tag.create(name: "job")
t2 = Tag.create(name: "school")

t1.posts << [p2, p4]
t2.posts << [p1, p3, p4]
