class SessionsView
  def display(employees)
    employees.each_with_index do |employee, index|
      puts "#{index + 1} - #{employee.username}"
    end
  end

  def ask_for(something)
    puts "#{something.capitalize}下さい！"
    gets.chomp
  end

  def wrong_pwd
    puts "Wrong password"
  end
end