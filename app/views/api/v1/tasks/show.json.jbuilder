# json.partial! "api/v1/tasks/task", task: @task, project: @project
json.partial! @task, as: :task, project: @project
