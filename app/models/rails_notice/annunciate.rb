module RailsNotice::Annunciate
  extend ActiveSupport::Concern
  included do
    attribute :receiver_type, :string, default: 'User'
    attribute :notifications_count, :integer, default: 0
    
    belongs_to :annunciation
    belongs_to :user_tag, optional: true
    has_many :user_taggeds, foreign_key: :user_tag_id, primary_key: :user_tag_id
    has_many :notification_settings, through: :user_taggeds
    has_many :annunciates, class_name: self.name, foreign_key: :annunciation_id, primary_key: :annunciation_id
    
    after_create :increment_unread_count
    after_destroy :decrement_unread_count
  end
  
  def increment_unread_count
    ['total', 'official', 'Annunciation'].each do |col|
      notification_settings.where(receiver_type: self.receiver_type).where.not(receiver_id: same_user_ids).increment_unread_counter(col)
    end
  end
  
  def decrement_unread_count
    ['total', 'official', 'Annunciation'].each do |col|
      notification_settings.where(receiver_type: self.receiver_type).where.not(receiver_id: same_user_ids).decrement_unread_counter(col)
    end
  end
  
  # todo better sql
  def same_user_ids
    user_tag_ids = self.annunciates.pluck(:user_tag_id)
    UserTagged.where(user_tag_id: user_tag_ids).having('COUNT(user_id) > 1').group(:user_id).count(:user_id).keys
  end
  
end
