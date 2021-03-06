require 'spec_helper'

describe Dog do
  before :each do
    [Leg, Head, Dog].each(&:delete_all)
  end

  it 'dog should be normal' do
    20.times{ Dog.create }
    concurrently do
      begin
        headless = Dog.includes(:head).where(heads: {dog_id: nil}).first
        headless && headless.create_head

        legless = Dog.includes(:legs).where(legs: {dog_id: nil}).first
        legless && legless.legs = 4.times.map{ Leg.create }
      end while headless || legless
    end

    Dog.all_str.must_equal "20 dogs with 1 head and 4 legs"
  end

end
