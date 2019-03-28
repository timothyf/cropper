class User < ApplicationRecord
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  #after_update :crop_avatar

  has_one_attached :avatar

  before_save :check_cropping

  def check_cropping
    self.crop_settings = {x: crop_x, y: crop_y, w: crop_w, h: crop_h} if cropping?
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def cropped_avatar
    if avatar.attached?
      if crop_settings.is_a? Hash
        dimensions = "#{crop_settings['w']}x#{crop_settings['h']}"
        coord = "#{crop_settings['x']}+#{crop_settings['y']}"
        avatar.variant(
          crop: "#{dimensions}+#{coord}"
        ).processed
      else
        avatar
      end
    end
  end

  def thumbnail(size = '100x100')
    if avatar.attached?
      if crop_settings.is_a? Hash
        dimensions = "#{crop_settings['w']}x#{crop_settings['h']}"
        coord = "#{crop_settings['x']}+#{crop_settings['y']}"
        avatar.variant(
        crop: "#{dimensions}+#{coord}",
        resize: size
        ).processed
      else
        avatar.variant(resize: size).processed
      end
    end
  end


  # def crop_avatar
  #   avatar.recreate_versions! if crop_x.present?
  # end

  private

  def delete_avatar
    self.avatar = nil
    self.save
  end

end
