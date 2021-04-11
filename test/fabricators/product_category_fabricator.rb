Fabricator(:product_category) do
  name { sequence(:name) { |i| "CPU#{i}" } }
  code { sequence(:code) { |i| "COMP#{i}" } }
end
