# encoding: utf-8

class Array
  def compact_blank
    self.select{ |i| not i.blank? }
  end
end
