require "pry-byebug"

class Password
  REQUIRED_CLASSES = {
    lowercase: ("a".."z").to_a.freeze,
    uppercase: ("A".."Z").to_a.freeze,
    digits: ("0".."9").to_a.freeze,
  }.freeze
  # ALLOWED_MISC_CHARS = ["!", "."].freeze
  MIN_LENGTH = 6
  MAX_LENGTH = 20

  attr_reader :password_string, :step_count

  def initialize(s)
    @password_string = s
    @step_count = 0
  end

  def character_class_of(char:)
    if REQUIRED_CLASSES[:uppercase].include?(char)
      :uppercase
    elsif REQUIRED_CLASSES[:lowercase].include?(char)
      :lowercase
    elsif REQUIRED_CLASSES[:digits].include?(char)
      :digits
    end
  end

  def character_class_stats
    result = {
      uppercase: 0,
      lowercase: 0,
      digits: 0,
    }

    @password_string.each_char do |char|
      klass = character_class_of(char:)
      result[klass] += 1 if klass
    end
    result
  end

  # returns the first needed character class
  # if no class is needed, defaults to :uppercase
  def character_classes_needed(stats:)
    stats.select { |_k, v| v.zero? }.keys
  end

  # returns the first needed character class,
  # or defaults to uppercase if none needed
  def give_me_a_character_class(stats:)
    needed = character_classes_needed(stats:)

    needed.first || :uppercase
  end

  def surplus_class?(char:, stats:)
    return false if character_class_of(char:).nil?

    stats.detect do |klass, klass_count|
      klass_count > 1 && klass == character_class_of(char:)
    end
  end

  def give_me_a_character(stats:, output_string:)
    (REQUIRED_CLASSES[give_me_a_character_class(stats:)] - [output_string.last]).first
  end

  def make_strong_2pass!
    stats = character_class_stats

    output_string = []
    old_length = password_string.length
    steps = 0

    putsif "-- begin (#{password_string}) --"

    if old_length < MIN_LENGTH
      0.upto(MIN_LENGTH - old_length - 1) do
        new_c = give_me_a_character(stats:, output_string:)
        putsif "    prepending #{new_c} because string too short"
        steps += 1
        stats[character_class_of(char: new_c)] += 1
        output_string << new_c
      end
    end

    0.upto(old_length - 1) do |old_index|
      char = password_string[old_index]
      old_char_class = character_class_of(char:)
      old_length_remaining = old_length - old_index
      current_length = output_string.length + old_length_remaining
      character_classes_needed = character_classes_needed(stats:)
      too_long = current_length > MAX_LENGTH
      old_char_is_surplus_class = character_classes_needed.include?(old_char_class)

      putsif "  char:#{char} old_index:#{old_index} stats:#{stats}"
      putsif "    old_char_class:#{old_char_class} old_length_remaining:#{old_length_remaining} current_length:#{current_length}"
      putsif "    character_classes_needed:#{character_classes_needed} too_long:#{too_long} old_char_is_surplus_class:#{old_char_is_surplus_class}"

      new_c = if too_long && character_classes_needed.none?
                # string is too long, and all classes are present, skip this char
                putsif "    string is already too long and we don't need any classes"
                nil
              elsif too_long && !character_classes_needed.include?(old_char_class)
                # replace this character class with one we actually need
                putsif "    string is too long and we have a surplus of the class of #{old_char} - #{old_char_class}"
                give_me_a_character(stats:, output_string:)
              elsif character_classes_needed.any? && surplus_class?(char:, stats:)
                putsif "    we have a surplus of #{old_char_class} but need #{character_classes_needed}"
                give_me_a_character(stats:, output_string:)
              else
                char
              end

      # if the last two chars in output_string are identical to this, change
      # it to another character of a needed class.
      # TODO: should not be equal to the next char in password_string?
      if new_c == output_string[-1] && new_c == output_string[-2]
        new_c = give_me_a_character(stats:, output_string: [new_c]) # kludge
        putsif "    changing char to #{new_c} to avoid 3 in a row"
      end

      output_string << new_c

      if new_c != char
        steps += 1
        # binding.pry
        stats[old_char_class] -= 1
        stats[character_class_of(char: new_c)] += 1
        putsif "    updated! steps:#{steps} stats:#{stats}"
      end

      putsif "    output_string:#{output_string.join}"
    end



    putsif "-- end (output_string:#{output_string.join}, steps:#{steps}) --"
    steps
  end
end
