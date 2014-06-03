class User
  # This is a stand in for a database
  @@all = []

  attr_reader :id,
    :uid,
    :provider,
    :email,
    :avatar_url

  def initialize(attributes)
    @id = attributes[:id]
    @uid = attributes[:uid]
    @provider = attributes[:provider]
    @email = attributes[:email]
    @avatar_url = attributes[:avatar_url]
  end

  def self.create(attributes)
    attributes.merge(id: all.length + 1)
    user = self.new(attributes)

    # This is where you would want to store the user in the database rather
    # than the in a global variable
    @@all << user

    user
  end

  def self.all
    # This should query the database for all of the users
    @@all
  end

  def self.find_by_id(id)
    # You would want to use SQL here
    all.find { |user| user.id == id }
  end
end
