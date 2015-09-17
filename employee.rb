require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'development.sqlite3'
)

class Employee < ActiveRecord::Base
  belongs_to :department
  has_and_belongs_to_many :committees
  has_many :reviews, dependent: :destroy

  validates :salary, presence: true

  def satisfactory?
    satisfactory
  end

  def give_raise(amount)
    update(salary: self.salary + amount)
  end

  def give_review(new_review)
    self.review = new_review
    assess_performance
    save
  end

  def assess_performance
    good_terms = [/positive/i, /good/i, /\b(en)?courag(e[sd]?|ing)\b/i, /ease/i, /improvement/i, /quick(ly)?/i, /incredibl[ey]/i, /\bimpress[edving]?{2,3}/i]
    bad_terms = [/\broom\bfor\bimprovement/i, /\boccur(ed)?\b/i, /not/i, /\bnegative\b/i, /less/i, /\bun[a-z]?{4,9}\b/i, /\b((inter)|e|(dis))?rupt[ivnge]{0,3}\b/i]
    good_terms = Regexp.union(good_terms)
    bad_terms = Regexp.union(bad_terms)

    count_good = review.scan(good_terms).length
    count_bad = review.scan(bad_terms).length

    self.satisfactory = (count_good - count_bad > 0)
  end

  # SOLUTION FOR: * Return all employees who are getting paid more than the average salary.
  def self.overpaid
    # MOSTLY-SQL Solution
    # average = Employee.select("AVG(salary) AS average_salary").first.average_salary
    # Employee.where(["salary > ?", average])

    # MOSTLY-RUBY Solution
    total = 0
    Employee.all.each do |e|
      total += e.salary
    end
    average = total / Employee.count
    Employee.where(["salary > ?", average])
  end

end
