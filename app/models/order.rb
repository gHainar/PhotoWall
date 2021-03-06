class Order < ApplicationRecord
  mount_uploader :in_image_url, ImageUploader
  mount_uploader :out_image_url, ImageUploader
  include AASM
  belongs_to :user

  attr_accessor :active_admin_requested_event

  scope :waiting, ->{ where(state: 'waiting')}
  scope :priced, ->{ where(state: 'priced')}
  scope :work_in_progress, ->{ where(state: 'wip')}
  scope :completed, ->{ where(state: 'completed')}
  scope :paid, ->{ where(state: 'paid')}
  scope :canceled, ->{ where(state: 'canceled')}

  def ready?
    completed? || paid?
  end

  aasm column: :state do
    state :waiting, initial: true
    state :priced
    state :wip
    state :completed
    state :paid
    state :canceled

    # forward
    event :set_price do
      transitions from: [:waiting], to: :priced
    end

    event :accept_price do
      transitions from: [:priced], to: :wip
    end

    event :mark_as_completed do
      transitions from: [:wip], to: :completed
    end

    event :pay_for do
      transitions from: [:completed], to: :paid
    end

    event :cancel do
      transitions from: [:waiting, :priced], to: :canceled
    end
  end
end