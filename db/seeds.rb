# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

john = User.create(email: "jdoe@mail.com", password: "password")
mike = User.create(email: "mike@mail.com", password: "password")

p1 = Project.create(name: "First", user: john)
p2 = Project.create(name: "Second", user: john)
p3 = Project.create(name: "Third", user: mike)

t1 = Task.create(title: "do this", project: p1)
t2 = Task.create(title: "do that", project: p1)
t3 = Task.create(title: "other things", project: p2)
t4 = Task.create(title: "foo bar", project: p3)
