require 'spec_helper'

describe ConstrainedNumber do
  after :each do
    ConstrainedNumber.delete_all
  end

  it 'should have unique valies' do
    concurrently do
      ConstrainedNumber.create(:value => ConstrainedNumber.count)
    end

    ConstrainedNumber.count.must_equal ConstrainedNumber.select('distinct value').count
  end
end
