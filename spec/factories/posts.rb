FactoryGirl.define do
  factory :post do
    title FFaker::Product.product_name
    time FFaker::Time.date
    content FFaker::HTMLIpsum.fancy_string
    published false
    user
  end
end
