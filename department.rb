require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'development.sqlite3'
)

class Department < ActiveRecord::Base
  has_many :employees, dependent: :restrict_with_error
  has_many :reviews, through: :employees
  validates :name, uniqueness: true

  def add_employee(employee)
    employees << employee
  end

  def total_salary
    employees.reduce(0){|sum, employee| sum + employee.salary}
  end

  def give_raise(total_amount)
    getting_raise = employees.select {|e| e.satisfactory?}
    getting_raise.each {|e| e.give_raise(total_amount / getting_raise.length)}
  end

  # SOLUTION FOR: * Return the total number of employees in a department.
  def employee_count
    employees.count
  end

  # SOLUTION FOR: * Return the employee who is being paid the least in a department.
  def lowest_paid_employee
    # SQL-HEAVY solution
    employees.order(:salary).first

    # RUBY-HEAVY solution
    # employees.sort_by {|e| e.salary}.first
  end

  # SOLUTION FOR: * Return all employees in a department, ordered alphabetically by name.
  def sorted_employees
    # SQL-HEAVY solution
    employees.order(:name)

    # RUBY-HEAVY solution
    # employees.sort_by {|e| e.name}

  end

  # SOLUTION FOR: * Move everyone from one department to another department.
  def move_employees(new_department)
    employees.each do |e|
      new_department.add_employee(e)
    end
  end

  # SOLUTION FOR: * Return the department with the most employees.
  def self.biggest
    # SQL-HEAVY solution
    joins(:employees).group(:department_id).order("count(employees.id) DESC").first

    # # RUBY-HEAVY solution
    # dept = nil
    # count = 0
    # all.each do |d|
    #   if d.employees.count > count
    #     dept = d
    #     count = d.employees.count
    #   end
    # end
    # dept
  end
end
