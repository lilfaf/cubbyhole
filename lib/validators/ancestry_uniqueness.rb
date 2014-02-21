class AncestryUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    exclude_self = record.try(:id) ? ['id <> ?', record.id] : []
    attr_value = value.downcase if value
    if record.siblings.where(exclude_self).where("lower(#{attribute})= ?", attr_value).first
      record.errors.add(attribute, options[:message] || :taken)
    end
  end
end
