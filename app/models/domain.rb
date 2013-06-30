class Domain < ActiveRecord::Base
  
  def url
    case RAILS_ENV
    # when "development"
    #   'rails.local'
    when "staging"
      "demo.#{self[:url]}"
    when "production"
      self[:url]
    else
      self[:url]
    end
  end
  
  def msa?
    self[:url] =~ /msa\./
  end
end
