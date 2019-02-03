random = Random.new
roles = ['user', 'it_support', 'om_support', 'admin']
departments = ['IT', 'OM']
statuses = ['open', 'support_response', 'user_response', 'closed']

roles.each do |role|
  Role.find_or_create_by({ name: role })
end

departments.each do |department|
  Department.find_or_create_by({ name: department })
end

statuses.each do |status|
  Status.find_or_create_by({ name: status })
end

admin_role = Role.find_by(name: 'admin')
admin = User.create(first_name: 'admin', last_name: 'admin', email: 'admin@tickets.com', password: 'lolopolo', role_id: admin_role.id)
admin.confirm

role_ids = Role.pluck(:id)
department_ids = Department.pluck(:id)
statuses_ids = Status.pluck(:id)

(1..10).each do |value|
  user = User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "user_#{value}@tickets.com",
    password: 'lolopolo',
    role_id: role_ids.sample)
  user.confirm

  (1..random.rand(5)).each do
    ticket = Ticket.create(
      title: Faker::Lorem.question,
      note: Faker::Lorem.paragraph(2),
      user_id: user.id,
      department_id: department_ids.sample,
      status_id: statuses_ids.sample
    )
  end
end


