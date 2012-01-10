class Attendee
	include Mongoid::Document
  validates_presence_of :name, :email
  field :name
  field :email
  field :twitter
  field :t_shirt
  field :provider
  field :uid
  field :lunch, :type => Boolean, :default => false
  field :is_in_wait_list, :type => Boolean, :default => false

  field :donation
  field :lunch_paid, :type => Boolean, :default => false

  field :note
  field :exclude, :type => Boolean, :default => false

  def is_new
      return ! Attendee.exists?(conditions: { uid: uid })
  end
end
