require 'rails_helper'

RSpec.describe 'Code style' do
  it 'rubocop without offenses' do
    puts 'Running rubocop'
    result = system 'bundle exec rubocop -a --config .rubocop.yml'
    expect(result).to be(true)
  end
end
