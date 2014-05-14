class Employee
  attr_reader :name, :title, :salary, :boss
  
  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
  end
  
  def bonus(multiplier)
    bonus = @salary * multiplier
  end
  
end

class Manager < Employee
  attr_reader :employees
  
  def initialize(name, title, salary, boss = nil)
    super(name, title, salary, boss)
    @employees = []
  end
  
  def add_employee(employee)
    @employees << employee
  end
  
  def bonus(multiplier)
    all_employees_queue = @employees.dup
    total_salaries = 0
    
    until all_employees_queue.empty?
      employee = all_employees_queue.shift
      total_salaries += employee.salary
      
      if employee.is_a?(Manager)
        all_employees_queue += employee.employees
      end
    end
    
    total_salaries * multiplier
  end
  
end