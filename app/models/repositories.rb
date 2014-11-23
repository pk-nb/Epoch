class Repositories
  include ActiveModel::Model
  attr_accessor :repos

  def initialize(client)
    repositories = client.repos
    @repos = repositories.map{|r| r.full_name}
  end
end
