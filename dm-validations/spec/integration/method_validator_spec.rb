require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe DataMapper::Validate::MethodValidator do
  before(:all) do
    class Ship
      include DataMapper::Resource
      property :id, Integer, :key => true
      property :name, String

      validates_with_method :fail_validation, :when => [:testing_failure]
      validates_with_method :pass_validation, :when => [:testing_success]
      validates_with_method :first_validation, :second_validation, :when => [:multiple_validations]

      def fail_validation
        return false, 'Validation failed'
      end

      def pass_validation
        return true
      end

      def first_validation
        return true
      end

      def second_validation
        return false, 'Second Validation was false'
      end
    end
  end

  it "should validate via a method on the resource" do
    Ship.new.valid_for_testing_failure?.should == false
    Ship.new.valid_for_testing_success?.should == true
    ship = Ship.new
    ship.valid_for_testing_failure?.should == false
    ship.errors.full_messages.include?('Validation failed').should == true
  end

  it "should run multiple validation methods" do
    ship = Ship.new
    ship.valid_for_multiple_validations?.should == false
    ship.errors.full_messages.should include('Second Validation was false')
  end
end
