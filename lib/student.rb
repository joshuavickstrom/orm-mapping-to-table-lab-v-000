class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      )
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(sql)

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id=DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(id:, name:, grade:)
    new_student = DB[:conn].execute("SELECT * FROM students WHERE student.id =?", id).flatten
    Student.new(id:new_student[0], name:new_student[1], grade:new_student[2])
    Student.save
  end

end
