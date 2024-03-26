class Group < ApplicationRecord
  has_many :segments, dependent: :destroy

  def next_value
    add = true
    self.segments.order(order: :asc).each do |segment|
      if segment.s_type == "FECHA" && segment.behavior == "SISTEMA"
        yearnum = 0
        placedyear = false
        jump = false
        now = Time.now
        today = ""
        segment.format.each_char do |character|
          if character == "Y"
            yearnum = yearnum + 1
          end
        end
        segment.format.each_char do |character|
          if !jump
            case character
            when "D"
              today.concat(now.strftime("%d"))
            when "M"
              today.concat(now.strftime("%m"))
            when "Y"
              if !placedyear
                if yearnum >= 4
                  today.concat(now.strftime("%Y"))
                else
                  today.concat(now.strftime("%y"))
                end
                placedyear = true
              end
            end
            jump = true
          else
            jump = false
          end
        end

        if segment.value != today
          segment.update(value: today)
        end
      end

      if add && segment.s_type == "ALFANUMERICO" && segment.behavior == "CORRELATIVO"
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
