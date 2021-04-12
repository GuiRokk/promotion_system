Fabricator(:product_category) do
  name { sequence(:name) { |i| "Celular#{i + 1}" } }
  code { sequence(:code) { |i| "ELETRO#{i + 1}" } }
end
