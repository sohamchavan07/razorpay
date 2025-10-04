class WebhookEvent < ApplicationRecord
  validates :razorpay_event_id, presence: true, uniqueness: true
  validates :event_type, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending processing completed failed] }
  validates :raw_data, presence: true

  scope :pending, -> { where(status: "pending") }
  scope :processing, -> { where(status: "processing") }
  scope :completed, -> { where(status: "completed") }
  scope :failed, -> { where(status: "failed") }

  def pending?
    status == "pending"
  end

  def processing?
    status == "processing"
  end

  def completed?
    status == "completed"
  end

  def failed?
    status == "failed"
  end

  def mark_as_processing!
    update!(status: "processing")
  end

  def mark_as_completed!
    update!(status: "completed", processed_at: Time.current)
  end

  def mark_as_failed!
    update!(status: "failed", processed_at: Time.current)
  end

  def parsed_data
    @parsed_data ||= JSON.parse(raw_data)
  rescue JSON::ParserError
    {}
  end
end
