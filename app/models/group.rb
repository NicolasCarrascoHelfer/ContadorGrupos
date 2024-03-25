class Group < ApplicationRecord
  has_many :segments, dependent: :destroy

  def next_value
    add = true
    self.segments.order(order: :asc).each do |segment|
      if add && segment.behavior == "CORRELATIVO" && segment.s_type == "ALFANUMERICO"
        plus = true
        newvalue = ""
        segment.value.reverse.each_char do |character|
          if plus
            numval = character.ord - 63
            if numval >= 27
              newvalue.concat("A")
              plus = true
            else
              newvalue.concat((numval + 64).chr)
              plus = false
            end
          else
            newvalue.concat(character)
          end
        end
        segment.update(value: newvalue.reverse)
        add = plus
      end
    end
  end
end
