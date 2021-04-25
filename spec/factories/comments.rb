FactoryBot.define do
	factory :comment do
		body  { Faker::Lorem.sentences(number: 3).join('') }
		user
    ticket
	end
end
