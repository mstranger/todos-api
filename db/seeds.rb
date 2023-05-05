#
# use `bin/rails db:seed` command
#

john = User.create(email: "jdoe@mail.com", password: "password")
mike = User.create(email: "mike@mail.com", password: "password")

p1 = Project.create(name: "First", user: john)
p2 = Project.create(name: "Second", user: john)
p3 = Project.create(name: "Third", user: mike)

t1 = Task.create(title: "do this", project: p1)
t2 = Task.create(title: "do that", project: p1)
t3 = Task.create(title: "foo bar", project: p3)

Task.create(title: "other things", project: p2)

Comment.create([
  {content: "comment 1", user: john, task: t1},
  {content: "comment 2", user: john, task: t2},
  {content: "comment 1", user: mike, task: t3}
])
