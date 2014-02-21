class Filo < Entry

  validate :ensure_container_type

  def ensure_container_type
    if parent && parent.type != 'Folder'
      errors.add(:parent, :invalid)
    end
  end
end
