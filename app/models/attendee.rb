class Attendee
	include Mongoid::Document
  validates_presence_of :name, :email
  field :name
  field :email
  field :twitter
  field :t_shirt
  field :provider
  field :uid
  field :launch, :type => Boolean, :default => false
  field :is_in_wait_list, :type => Boolean, :default => false

  def is_new
      return ! Attendee.exists?(conditions: { uid: uid })
  end
end
