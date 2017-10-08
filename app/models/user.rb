class User < ApplicationRecord
  has_many :reflections, dependent: :destroy
  has_many :todo_lists, dependent: :destroy
  has_many :todos, through: :todo_lists

  has_secure_password validations: false

  scope :want_sms_reminders,   -> { where(sms_reminders: true)   }
  scope :want_email_reminders, -> { where(email_reminders: true) }

  validates :phone, presence: true, if: -> { self.sms_reminders? }
  validates :email, presence: true, unless: -> { self.guest? }
  validates :email, uniqueness: true, unless: -> { self.guest? }
  validates :password_digest, presence: true, unless: :skip_password_validation
  validate  :validate_password

  attr_accessor :skip_password_validation

  # TODO extract timezone logic to concern and convert to scope
  def self.finishing_their_day
    timezones = ActiveSupport::TimeZone.all.map do |tz|
      Time.use_zone(tz) do
        tz.tzinfo.name if Time.current.utc.in_time_zone.hour == 17
      end
    end.compact

    User.where(timezone: timezones)
  end

  def validate_password
    if password.present? && password.length < 10 || password == email
      errors.add(:password, 'is invalid')
    end
  end

  def had_a_great_day?
    reflection = Reflection.today(self)
    tomorrows_todo_list = TodoList.tomorrow(self)

    reflection.present? &&
      reflection.rating == 10 &&
      tomorrows_todo_list.present?
  end

  def recently_signed_up?
    created_at > 30.minutes.ago
  end

  def trialing?
    reflections.count < 2
  end

  def completion_percentage(from:, to:)
    all_todos      = self.todos.where(created_at: from..to)
    complete_todos = all_todos.where(complete: true)

    if all_todos.count == 0 && complete_todos.count == 0
      return 0
    end

    (complete_todos.count.to_f / all_todos.count) * 100
  end

  def average_rating(from:, to:)
    (reflections.where(created_at: from..to).average(:rating) || 0).to_i
  end
end
