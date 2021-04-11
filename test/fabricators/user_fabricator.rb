Fabricator(:user) do
  email { sequence(:email) { |i| "user#{i}@iugu.com.br" } }
  password '123123'
  name { sequence(:name) { |i| "user#{i}" } }
end
