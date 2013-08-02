require 'spec_helper'

describe Dog do
  after :each do
    [Leg, Head, Dog].each(&:delete_all)
  end
  before :each do
    [Leg, Head, Dog].each(&:delete_all)
  end

  it 'dog should be normal' do
    50.times{ Dog.create }
    concurrently do
      begin
        headless = Dog.all.reject(&:head).first
        headless && headless.create_head
        legless = Dog.all.select{|d| d.legs.empty?}.first
        legless && legless.legs = 4.times.map{ Leg.create }
      end while headless || legless
    end

    Dog.all.group_by{ |dog| [ Head.where(:dog_id => dog.id).count, dog.legs.count ] }.
        map{ |k, v| [k[0], k[1], v.size] }.
        sort_by(&:last).
        reverse.
        map{ |(heads, legs, count)| "#{pz(count, 'dog')} with #{pz(heads, 'head')} and #{pz(legs, 'leg')}"}.
        join(', ').
        must_equal "50 dogs with 1 head and 4 legs"
  end

  def pz(n, str)
    "#{n} #{str}#{'s' if n != 1}"
  end
end
