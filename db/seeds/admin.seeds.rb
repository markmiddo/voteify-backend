puts '==================== Seed admin to db ====================='
admin = FactoryBot.build(:user, email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'],
                         password_confirmation: ENV['ADMIN_PASSWORD'], type: 'Admin')
admin.save(validate: false)
puts '==================== Admin added to db ====================='