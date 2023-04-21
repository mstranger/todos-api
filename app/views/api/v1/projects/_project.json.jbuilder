json.ignore_nil!

json.data do
  json.(project, :id)
  json.type :projects
  json.attributes do
    json.name project.name
  end
  json.links do
    json.self api_v1_project_url(project, format: :json)
  end
end
