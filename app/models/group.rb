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

        changed = ""

        for i in 0..(today.size - 1)
          if segment.value[i] != today[i]
            case segment.format[i]
            when "D"
              if changed != "M" && changed != "Y"
                changed = "D"
              end
            when "M"
              if changed != "Y"
                changed = "M"
              end
            when "Y"
              changed = "Y"
            end
          end
        end

        if changed != ""
          segment.update(value: today)
          case changed
          when "D"
            self.segments.order(order: :asc).each do |seg|
              if seg.reset == "DIA"
                seg.reset_value
                add = false
              end
            end
          when "M"
            self.segments.order(order: :asc).each do |seg|
              if seg.reset == "MES" || seg.reset == "DIA"
                seg.reset_value
                add = false
              end
            end
          when "Y"
            self.segments.order(order: :asc).each do |seg|
              if seg.reset == "AÑO" || seg.reset == "MES" || seg.reset == "DIA"
                seg.reset_value
                add = false
              end
            end
          end
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
